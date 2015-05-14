function [posicionNodos, modoPropioNormaGrafica ] = ...
    grafica_modo_propio( n, vibraciones, elementosFinitos, handles )
% grafica_modo_propio   Representa las gráficas de los modos propios de la
%                       viga.
% 
% [] = grafica_modo_propio( n, vibraciones, elementosFinitos )
% 
% ENTRADA
% n                     Número de frecuencia natural a representar
% vibraciones           Estructura con las frecuencias angulares de 
%                       vibración, frecuencias naturales de vibración y los
%                       modos propios de vibración
% elementosFinitos      Estructura actualizada con valores relativos al 
%                       cálculo de elementos finitos
% 

    condicionesContorno = elementosFinitos.condicionesContorno;
    modosPropiosNorma = vibraciones.modosPropiosNorma;
    posicionNodos = elementosFinitos.posicionNodos;
    frecuenciaNatural = vibraciones.frecuenciaNatural;
    m = frecuenciaNatural( n, 1 );
    
    nNodos = max( size( posicionNodos ) );
    
    if ( condicionesContorno == 1 )
        modoPropioNormaGrafica = zeros( 1, nNodos );
        for i = 1 : nNodos
            modoPropioNormaGrafica( i ) = modosPropiosNorma( 2 * i - 1, n );
        end  
    elseif ( condicionesContorno == 2 )
        modoPropioNormaGrafica = zeros( 1, nNodos );
        for i = 1 : nNodos - 1
            modoPropioNormaGrafica( i + 1 ) = modosPropiosNorma( 2 * i - 1, n );
        end
    elseif ( condicionesContorno == 3 )
        modoPropioNormaGrafica = zeros( 1, nNodos );
        for i = 1 : nNodos - 2
            modoPropioNormaGrafica( i + 1 ) = modosPropiosNorma( 2 * i - 1, n );
        end
    elseif ( condicionesContorno == 4 )
        modoPropioNormaGrafica = zeros( 1, nNodos );
        for i = 1 : nNodos - 2
            modoPropioNormaGrafica( i + 1 ) = modosPropiosNorma( 2 * i - 1, n );
        end        
    elseif ( condicionesContorno == 5 )
        modoPropioNormaGrafica = zeros( 1, nNodos );
        for i = 1 : nNodos - 2
            modoPropioNormaGrafica( i + 1 ) = modosPropiosNorma( 2 * i, n );
        end
    end

    plot( posicionNodos, modoPropioNormaGrafica );
    grid;
    set( gca, 'MinorGridLineStyle', 'none', 'GridLineStyle', ...
        ':', 'XScale', 'lin', 'YScale', 'lin' );    
    title( sprintf( ' Modo propio %d (%g Hz) ', n, m ) );
    xlabel( 'x (m)' );
    ylabel( 'Desplazamiento' );
    xlim([0 posicionNodos(end)]);
    yLimites = ylim;
    yMaxAbs = max( abs( yLimites ) );
    ylim( [ -yMaxAbs yMaxAbs ] );
    
end