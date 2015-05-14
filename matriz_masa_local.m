function [ mLocal ] = matriz_masa_local( viga, elementosFinitos )

% matriz_masa_local Esta función define una matriz de masa según la teoría 
%                   de Euler-Bernoulli para cada dx:
% 
% [ mLocal ] = matriz_masa_local( viga, elementosFinitos )
% 
% ENTRADA
% viga                  Estructura con las propiedades de una viga
% elementosFinitos      Estructura con valores relativos al cálculo de 
%                       elementos finitos
% 
% SALIDA
% mLocal( k, i, j ) = 	L·rho·A/420	[	156		22L		54		-13L
% 									  	22L		4L^2	13L		-3L^2
% 										54		13L		156		-22L
% 										-13L	-3L^2	-22L	4L^2	]
% 

    rho = viga.rho;
    A = viga.A;
    nElementos = elementosFinitos.nElementos;
    longitudElementos = elementosFinitos.longitudElementos;
    
    mLocal = zeros( nElementos, 4, 4 );

    for k = 1 : nElementos
        mLocal( k, 1, 1 ) = 156;
        mLocal( k, 1, 2 ) = 22 * longitudElementos( k );
        mLocal( k, 1, 3 ) = 54;
        mLocal( k, 1, 4 ) = -13 * longitudElementos( k );
        mLocal( k, 2, 2 ) = 4 * longitudElementos( k ) ^ 2;
        mLocal( k, 2, 3 ) = 13 * longitudElementos( k );
        mLocal( k, 2, 4 ) = -3 * longitudElementos( k ) ^ 2;
        mLocal( k, 3, 3 ) = 156;
        mLocal( k, 3, 4 ) = -22 * longitudElementos( k );
        mLocal( k, 4, 4 ) = 4 * longitudElementos( k ) ^ 2;

        for i = 1 : 4
            for j = i : 4
                mLocal( k, i, j ) = ...
                    mLocal( k, i, j ) * longitudElementos( k ) * rho * A / 420.; 
                mLocal( k, j, i ) = mLocal( k, i, j );
            end
        end
    end
end
