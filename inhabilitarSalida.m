function inhabilitarSalida( handles )

    % Inhabilitar guardarFrecuenciasNaturales
    set( handles.guardarFrecuenciasNaturales, ...
        'ForegroundColor', [0.8 0.8 0.8], 'Enable', 'inactive' );

    % Inhabilitar botonGuardarGrafica
    set( handles.botonGuardarGrafica, ...
        'ForegroundColor', [0.8 0.8 0.8], 'Enable', 'inactive' );
    
    % Inhabilitar botonGuardarMP
    set( handles.botonGuardarMP, ...
        'ForegroundColor', [0.8 0.8 0.8], 'Enable', 'inactive' );

    % Inhabilitar masBoton, menosBoton y nGraficaEdit
    set( handles.masBoton, ...
        'ForegroundColor', [0.8 0.8 0.8], 'Enable', 'inactive' );
    set( handles.menosBoton, ...
        'ForegroundColor', [0.8 0.8 0.8], 'Enable', 'inactive' );
    set( handles.nGraficaEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
        'Enable', 'inactive');

end