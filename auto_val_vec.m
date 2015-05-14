function [ vibraciones ] = auto_val_vec ( matrizRigidez, matrizMasa, ...
    elementosFinitos )

% auto_val_vec  Obtiene las frecuencias naturales y los modos propios de
%               vibraci�n mediante el c�lculo de autovalores y
%               autovectores.
% 
% [ vibraciones ] = auto_val_vec ( matrizRigidez, matrizMasa, ...
%   elementosFinitos )
% 
% ENTRADA
% matrizRigidez         Matriz de rigidez de la viga en 2 dimensiones
% matrizMasa            Matriz de masa de la viga en 2 dimensiones
% elementosFinitos      Estructura actualizada con valores relativos al 
%                       c�lculo de elementos finitos
% 
% SALIDA
% vibraciones           Estructura con las frecuencias angulares de 
%                       vibraci�n, frecuencias naturales de vibraci�n y los
%                       modos propios de vibraci�n

    gdl = elementosFinitos.gdl;

    [ modosPropiosNoNorma, autoValoresMatriz ] = ...
        eig( matrizRigidez, matrizMasa );

    autoValoresVector = zeros( gdl, 1 );

    for i = 1 : gdl
       autoValoresVector( i, 1 ) = autoValoresMatriz( i, i ); 
    end
    
    omega = sqrt( autoValoresVector );
    frecuenciaNatural = omega / ( 2 * pi );

    QTMQ = modosPropiosNoNorma' * matrizMasa * modosPropiosNoNorma;
    
    modosPropiosNorma = zeros( gdl );
    
    for i = 1 : gdl
        coefNorma = 1 ./ sqrt( QTMQ( i, i ) );
        modosPropiosNorma( :, i ) = modosPropiosNoNorma( :, i ) * coefNorma;
    end

    vibraciones.omega = omega;
    vibraciones.frecuenciaNatural = frecuenciaNatural;
    vibraciones.modosPropiosNorma = modosPropiosNorma;

end
