function [ kLocal ] = matriz_rigidez_local( viga, elementosFinitos )

% matriz_rigidez_local  Esta función define una matriz de rigidez
%                       según la teoría de Euler-Bernoulli para cada dx:
% 
% [ mLocal ] = matriz_masa_local( viga, elementosFinitos )
% 
% ENTRADA
% viga                  Estructura con las propiedades de una viga
% elementosFinitos      Estructura con valores relativos al cálculo de 
%                       elementos finitos
% 
% SALIDA
% kLocal( k, i, j ) = 	E·I/L^3	[	12 		6L 		-12		6L
% 									6L		4L^2	-6L		2L^2
% 									-12		-6L		12		-6L
% 									6L		2L^2	-6L		4L^2	]

    E = viga.E;
    Ix = viga.Ix;
    nElementos = elementosFinitos.nElementos;
    longitudElementos = elementosFinitos.longitudElementos;
    
    kLocal = zeros( nElementos, 4, 4 );

    for k = 1 : nElementos
        kLocal( k, 1, 1 ) = 12;
        kLocal( k, 1, 2 ) = 6 * longitudElementos( k );
        kLocal( k, 1, 3 ) = -12;
        kLocal( k, 1, 4 ) = 6 * longitudElementos( k );
        kLocal( k, 2, 2 ) = 4 * longitudElementos( k ) ^ 2;
        kLocal( k, 2, 3 ) = -6 * longitudElementos( k );
        kLocal( k, 2, 4 ) = 2 * longitudElementos( k ) ^ 2;
        kLocal( k, 3, 3 ) = 12;
        kLocal( k, 3, 4 ) = -6 * longitudElementos( k );
        kLocal( k, 4, 4 ) = 4 * longitudElementos( k ) ^ 2;

        for i = 1 : 4
            for j = i : 4
                kLocal( k, i, j ) = ...
                    kLocal( k, i, j ) * E * Ix / longitudElementos( k ) ^ 3;            
                kLocal( k, j, i ) = kLocal( k, i, j );
            end
        end
    end
end
