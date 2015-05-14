function [ viga, masaPuntualViga, elementosFinitos ] = ...
    entrada_datos( handles )
% entrada_datos Función encargada de tomar los valores introducidos en
%               en los campos de entrada.
% 
% [ viga, masaPuntualViga, elementosFinitos ] = entrada_datos( handles )
% 
% ENTRADA
% handles               handles de la figura
% 
% SALIDA
% viga                  Estructura con las propiedades de una viga
% masaPuntualViga       Estructura con valores referentes a la masa puntual
% elementosFinitos      Estructura con valores relativos al cálculo de 
%                       elementos finitos 

    % Obtención de las condiciones de contorno.
    seleccionCCString = ...
        get( get( handles.condicionesContornoPanel, 'SelectedObject' ), ...
        'String' );

    switch seleccionCCString
        case 'Libre - Libre'
            condicionesContorno = 1;
        case 'Empotrada - Libre'
            condicionesContorno = 2;
        case 'Empotrada - Empotrada'
            condicionesContorno = 3;
        case 'Empotrada - Apoyada'
            condicionesContorno = 4;
        case 'Apoyada - Apoyada'
            condicionesContorno = 5;
    end
    
    % Obtención de la longitud de la viga.
    longitud = str2double( get( handles.longitudViga, 'String' ) );

    % Obtención de la sección seleccionada.
    seleccionSeccionString = ...
        get( get(handles.seccionPanel,'SelectedObject'), 'String' );
    
    switch seleccionSeccionString
		case 'Rectangular'
		    anchura = str2double( get( handles.anchuraEdit, 'String' ) );
		    altura = str2double( get( handles.alturaEdit, 'String' ) );
		    A = anchura * altura;
            % Momento de inercia con respecto al eje x
		    Ix = ( 1 / 12 ) * anchura * altura ^ 3;
		case 'Cilíndrica'
		    diametro = str2double( get( handles.diametroEdit, 'String' ) );
		    A = ( pi * diametro ^ 2 ) / 4;
            % Momento de inercia con respecto al eje x
		    Ix = ( pi * diametro ^ 4 ) / 64;
		case 'Otra'
		    A = str2double( get( handles.areaSeccionEdit, 'String' ) );
            % Momento de inercia con respecto al eje x
		    Ix = str2double( get( handles.momentoIEdit, 'String' ) );
    end

    % Obtención de la densidad y del módulo de elasticidad.
    rho = str2double( get( handles.densidadEdit, 'String' ) );
	E = str2double( get( handles.eEdit, 'String' ) );
    
    % Comprobación de la existencia de masa puntual.
	estadoMP = get( handles.masaPuntualCheckbox, 'Value' );

	if estadoMP == 1
		existeMasaPuntual = 1;
		masaPuntual = str2double( get( handles.masaPuntualEdit, 'String' ) );
		xMasaPuntual = str2double( get( handles.xMasaPuntualEdit, 'String' ) );
    else
		existeMasaPuntual = 0;
		masaPuntual = 0; 
		xMasaPuntual = 0;
        nodoMasaPuntual = 0;
	end

	% Obtención del número de elementos finitos que se emplearán en el
	% algoritmo.
	nElementos = str2double( get( handles.nElementosFinitosEdit, 'String' ) );
	
    % Tamaño de elemento inicial.
	dxElemento = longitud / nElementos;

	% posicionNodos es la posición de todos los nodos desde 1 a 
    % nElementos + 1.
    posicionNodos = zeros( 1, nElementos + 1 );
    for i = 2 : ( nElementos + 1 )
		posicionNodos( i ) = posicionNodos( i - 1 ) + dxElemento;
    end
        
	% longitudElementos: incrementos entre posicionNodos( i ) y 
    % posicionNodos( i + 1 ). Distancia entre nodos. Longitud de los
    % elementos finitos.
    longitudElementos = zeros( 1, nElementos );
    for i = ( 1 : nElementos )
		longitudElementos( i ) = posicionNodos( i + 1 ) - posicionNodos( i );
    end
    
    % Para hacer coincidir la posición de la masa puntual, en caso de
    % existir, con los nodos de los elementos finitos se toman 2 enfoques. 
    % El primero, por aproximación a un nodo. El segundo, creando un nodo 
    % más para acomodar la masa puntual.
    if ( existeMasaPuntual == 1 )
        i = 1;
        continuar = true;
        while ( i <= ( nElementos + 1 ) && continuar == true )
		    if abs( xMasaPuntual - posicionNodos( i ) ) < longitud / 1000
		        xMasaPuntual = posicionNodos( i );
                nodoMasaPuntual = i;
		        continuar = false;
		    end
		    i = i + 1;
        end
        if ( continuar == true )
		    posicionNodos( nElementos + 2 ) = xMasaPuntual;
		    posicionNodos = sort( posicionNodos );
		    for i = 1 : nElementos + 1
		        longitudElementos( i ) = ...
                    posicionNodos( i + 1 ) - posicionNodos( i );
		    end    
		    nElementos = nElementos + 1;
            nodoMasaPuntual = find( posicionNodos == xMasaPuntual );
        end
    end
    
    % El número de grados de libertad que tendremos en la viga será el 
    % número de nodos por el número de grados de libertad de cada nodo 
    % (2 en este caso).
	gdl = 2 * ( nElementos + 1 );
    
    % Asignación de las variables locales a las estructuras salida.
    viga.longitud = longitud;
    viga.A = A;
    viga.Ix = Ix;
    viga.rho = rho;
	viga.E = E;
    
    masaPuntualViga.existeMasaPuntual = existeMasaPuntual;
    masaPuntualViga.masaPuntual = masaPuntual; 
    masaPuntualViga.xMasaPuntual = xMasaPuntual;
    masaPuntualViga.nodoMasaPuntual = nodoMasaPuntual;
    
    elementosFinitos.condicionesContorno = condicionesContorno;
    elementosFinitos.nElementos = nElementos;
	elementosFinitos.posicionNodos = posicionNodos;
	elementosFinitos.longitudElementos = longitudElementos;
	elementosFinitos.gdl = gdl;

end








