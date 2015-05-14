function [ matrizRigidez, matrizMasa, elementosFinitos ] = ...
    generar_matrices( kLocal, mLocal, elementosFinitos, masaPuntualViga )

% generar_matrices  Función encargada de obtener las matrices de masa y de
%                   rigidez de la viga en 2 dimensiones.
% 
% [ matrizRigidez, matrizMasa, elementosFinitos ] = ...
%   generar_matrices( kLocal, mLocal, elementosFinitos, masaPuntualViga )
% 
% ENTRADA
% kLocal                Matriz de rigidez local en 3 dimensiones
% mLocal                Matriz de masa local en 3 dimensiones
% elementosFinitos      Estructura con valores relativos al cálculo de 
%                       elementos finitos
% masaPuntualViga       Estructura con valores referentes a la masa puntual
% 
% SALIDA
% matrizRigidez         Matriz de rigidez de la viga en 2 dimensiones
% matrizMasa            Matriz de masa de la viga en 2 dimensiones
% elementosFinitos      Estructura con valores relativos al cálculo de 
%                       elementos finitos actualizada

	nElementos = elementosFinitos.nElementos;
	condicionesContorno = elementosFinitos.condicionesContorno;
	gdl = elementosFinitos.gdl;

	existeMasaPuntual = masaPuntualViga.existeMasaPuntual;
	masaPuntual = masaPuntualViga.masaPuntual;
    nodoMasaPuntual = masaPuntualViga.nodoMasaPuntual;
    
  	% kLocal y mLocal, matrices de 3 dimensiones, se transforman en 
    % kGlobal y mGlobal, matrices de 2 dimensiones.
	kGlobal = zeros( gdl );
	mGlobal = zeros( gdl );

	ii = 0;
	jj = 0;

	for k = 1 : nElementos
		for i = 1 : 4
		    for j = 1 : 4
		        kGlobal( ii + i, jj + j ) = ...
		            kGlobal( ii + i, jj + j ) + kLocal( k, i, j );
		        mGlobal( ii + i, jj + j ) = ...
		            mGlobal( ii + i, jj + j ) + mLocal( k, i, j );
		    end
		end
		ii = ii + 2;
		jj = jj + 2;
	end

	% En caso de existir, se añade la masa puntual.
	if ( existeMasaPuntual == 1 )
		mGlobal( 2 * nodoMasaPuntual - 1, 2 * nodoMasaPuntual - 1 ) = ...
		    mGlobal( 2 * nodoMasaPuntual - 1, 2 * nodoMasaPuntual - 1) ...
            + masaPuntual;
	end

	% Aplicación de las condiciones de contorno.
	% 
	% Condiciones de contorno:
	% 1 - Viga libre            (Libre - Libre)
	% 2 - Ménsula               (Empotrada - Libre)
	% 3 - Biempotrada           (Empotrada - Empotrada)
    % 4 - Empotrada - Apoyada
	% 5 - Biapoyada             (Apoyada - Apoyada)

	if ( condicionesContorno == 1 )
		matrizRigidez = kGlobal;
		matrizMasa = mGlobal;
	elseif ( condicionesContorno == 2 )
		gdl = gdl - 2;
		matrizRigidez = zeros( gdl );
		matrizMasa = zeros( gdl );
        for i = 1 : gdl
		    for j = 1 : gdl
		        matrizRigidez( i, j ) = kGlobal( i + 2, j + 2 );
		        matrizMasa( i, j ) = mGlobal( i + 2, j + 2 );                
		    end
        end
	elseif ( condicionesContorno == 3 )
		gdl = gdl - 4;
		matrizRigidez = zeros( gdl );
		matrizMasa = zeros( gdl );
        for i = 1 : gdl
		    for j = 1 : gdl
		        matrizRigidez( i, j ) = kGlobal( i + 2, j + 2 );
		        matrizMasa( i, j ) = mGlobal( i + 2, j + 2 );                
		    end
        end  
    elseif ( condicionesContorno == 4 )
        for i = 1 : gdl
		    temp = kGlobal( i, gdl - 1 );
		    kGlobal( i, gdl - 1 ) = kGlobal( i, gdl );
		    kGlobal( i, gdl ) = temp;
        end
        for i = 1 : gdl
		    temp = kGlobal( gdl - 1, i );
		    kGlobal( gdl - 1, i ) = kGlobal( gdl, i );
		    kGlobal( gdl, i ) = temp;
        end
        for i = 1 : gdl
		    temp = mGlobal( i, gdl - 1 );
		    mGlobal( i, gdl - 1 ) = mGlobal( i, gdl );
		    mGlobal( i, gdl ) = temp;
        end
        for i = 1 : gdl
		    temp = mGlobal( gdl - 1, i );
		    mGlobal( gdl - 1, i ) = mGlobal( gdl, i );
		    mGlobal( gdl, i ) = temp;
        end
        gdl = gdl - 3;
		matrizRigidez = zeros( gdl );
		matrizMasa = zeros( gdl );
        for i = 1 : gdl
		    for j = 1 : gdl
		        matrizRigidez( i, j ) = kGlobal( i + 2, j + 2 );
		        matrizMasa( i, j ) = mGlobal( i + 2, j + 2 );                
		    end
        end
	elseif ( condicionesContorno == 5 ) 
		for i = 1 : gdl
		    temp = kGlobal( i, gdl - 1 );
		    kGlobal( i, gdl - 1 ) = kGlobal( i, gdl );
		    kGlobal( i, gdl ) = temp;
		end
		for i = 1 : gdl
		    temp = kGlobal( gdl - 1, i );
		    kGlobal( gdl - 1, i ) = kGlobal( gdl, i );
		    kGlobal( gdl, i ) = temp;
		end 
		for i = 1 : gdl
		    temp = mGlobal( i, gdl - 1 );
		    mGlobal( i, gdl - 1 ) = mGlobal( i, gdl );
		    mGlobal( i, gdl ) = temp;
		end
		for i = 1 : gdl
		    temp = mGlobal( gdl - 1, i );
		    mGlobal( gdl - 1, i ) = mGlobal( gdl, i );
		    mGlobal( gdl, i ) = temp;
		end  
		gdl = gdl - 2;
		matrizRigidez = zeros( gdl );
		matrizMasa = zeros( gdl );
		for i = 1 : gdl
		    for j = 1 : gdl
		        matrizRigidez( i, j ) = kGlobal( i + 1, j + 1 );
		        matrizMasa( i, j ) = mGlobal( i + 1, j + 1 );                
		    end
		end    
	end

	% gdl ha cambiado de valor --> se asigna a la estructura a devolver
	elementosFinitos.gdl = gdl;

end
