function varargout = AMVI(varargin)
% AMVI MATLAB code for AMVI.fig
%      AMVI, by itself, creates a new AMVI or raises the existing
%      singleton*.
%
%      H = AMVI returns the handle to a new AMVI or the handle to
%      the existing singleton*.
%
%      AMVI('CALLBACK',hObject,eventData,handles,...) calls the local
%      function named CALLBACK in AMVI.M with the given input arguments.
%
%      AMVI('Property','Value',...) creates a new AMVI or raises the
%      existing singleton*.  Starting from the left, property value pairs are
%      applied to the GUI before AMVI_OpeningFcn gets called.  An
%      unrecognized property name or invalid value makes property application
%      stop.  All inputs are passed to AMVI_OpeningFcn via varargin.
%
%      *See GUI Options on GUIDE's Tools menu.  Choose "GUI allows only one
%      instance to run (singleton)".
%
% See also: GUIDE, GUIDATA, GUIHANDLES

% Edit the above text to modify the response to help AMVI

% Last Modified by GUIDE v2.5 14-Sep-2014 11:52:27

% Begin initialization code - DO NOT EDIT
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @AMVI_OpeningFcn, ...
                   'gui_OutputFcn',  @AMVI_OutputFcn, ...
                   'gui_LayoutFcn',  [] , ...
                   'gui_Callback',   []);
if nargin && ischar(varargin{1})
    gui_State.gui_Callback = str2func(varargin{1});
end

if nargout
    [varargout{1:nargout}] = gui_mainfcn(gui_State, varargin{:});
else
    gui_mainfcn(gui_State, varargin{:});
end
% End initialization code - DO NOT EDIT


% --- Executes just before AMVI is made visible.
function AMVI_OpeningFcn(hObject, eventdata, handles, varargin)
% This function has no output args, see OutputFcn.
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)
% varargin   command line arguments to AMVI (see VARARGIN)

% masaPuntualPanel
set( handles.masaPuntualCheckbox, 'ForegroundColor', [0.8 0.8 0.8] );
set( handles.masaPuntualEstatic, 'ForegroundColor', [0.8 0.8 0.8] );
set( handles.masaPuntualEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
    'Enable', 'inactive' );
set( handles.xMasaPuntualEstatic, 'ForegroundColor', [0.8 0.8 0.8] );
set( handles.xMasaPuntualEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
    'Enable', 'inactive');

% geometriaVigaPanel
set( handles.anchuraEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
set( handles.alturaEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
set( handles.diametroEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
set( handles.areaSeccionStatic, 'ForegroundColor', [0.8 0.8 0.8] );
set( handles.momentoIStatic, 'ForegroundColor', [0.8 0.8 0.8] );
set( handles.anchuraEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
    'Enable', 'inactive');
set( handles.alturaEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
    'Enable', 'inactive');
set( handles.diametroEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
    'Enable', 'inactive');
set( handles.areaSeccionEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
    'Enable', 'inactive');
set( handles.momentoIEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
    'Enable', 'inactive');

% Preselección de material --> Acero
set( handles.densidadEdit, 'Enable', 'inactive' );
set( handles.eEdit, 'Enable', 'inactive' );
set( handles.densidadEdit, 'String', '7850' );
set( handles.eEdit, 'String', '210e9' );
handles.materialAnterior = 1;

% Inicialización de variables
handles.condicionesContorno = 0;
handles.seleccionSeccionPanel = 0;

% Inhabilitar salida de resultados
inhabilitarSalida( handles );

% Choose default command line output for AMVI
handles.output = hObject;

% Update handles structure
guidata(hObject, handles);

% UIWAIT makes AMVI wait for user response (see UIRESUME)
% uiwait(handles.AMVI);


% --- Outputs from this function are returned to the command line.
function varargout = AMVI_OutputFcn(hObject, eventdata, handles) 
% varargout  cell array for returning output args (see VARARGOUT);
% hObject    handle to figure
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Get default command line output from handles structure
varargout{1} = handles.output;



function longitudViga_Callback(hObject, eventdata, handles)
% hObject    handle to longitudViga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of longitudViga as text
%        str2double(get(hObject,'String')) returns contents of longitudViga as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
xMasaPuntualAuxiliar = 0;
checkbox = get( handles.masaPuntualCheckbox, 'Value' );
vacioMP = isempty( get( handles.xMasaPuntualEdit, 'String' ) );
inputStringC = (inputString == ',' );

if checkbox == 1 && vacioMP == 0
    xMasaPuntualAuxiliar = ...
        str2double( get( handles.xMasaPuntualEdit, 'String' ) );
end

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.longitudViga, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Longitud incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.longitudViga, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Longitud incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.longitudViga, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Longitud incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input < xMasaPuntualAuxiliar
        set( handles.longitudViga, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Longitud de la viga inferior\n a la posición de la masa puntual.', ...
            inputString), 'Longitud incorrecta', 'modal' )
        uicontrol( hObject )
        return
    else
        set( handles.masaPuntualCheckbox, 'Enable', 'on', ...
            'ForegroundColor', [ 0 0 0 ] );        
    end
else
    set( handles.masaPuntualCheckbox, 'Enable', 'inactive', ...
        'ForegroundColor', [ 0.8 0.8 0.8 ], 'Value', 0 );
    set( handles.masaPuntualEstatic, 'ForegroundColor', [0.8 0.8 0.8] );
    set( handles.masaPuntualEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
        'Enable', 'inactive' );
    set( handles.xMasaPuntualEstatic, 'ForegroundColor', [0.8 0.8 0.8] );
    set( handles.xMasaPuntualEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
        'Enable', 'inactive');
    set( handles.longitudViga, 'String', '' );    
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function longitudViga_CreateFcn(hObject, eventdata, handles)
% hObject    handle to longitudViga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


function masaPuntualEdit_Callback(hObject, eventdata, handles)
% hObject    handle to masaPuntualEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of masaPuntualEdit as text
%        str2double(get(hObject,'String')) returns contents of masaPuntualEdit as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = (inputString == ',' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.masaPuntualEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Masa puntual incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.masaPuntualEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Masa puntual incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.masaPuntualEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Masa puntual incorrecta', 'modal' )
        uicontrol( hObject )
        return    
    end
else
    set( handles.masaPuntualEdit, 'String', '' );    
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function masaPuntualEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to masaPuntualEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function xMasaPuntualEdit_Callback(hObject, eventdata, handles)
% hObject    handle to xMasaPuntualEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of xMasaPuntualEdit as text
%        str2double(get(hObject,'String')) returns contents of xMasaPuntualEdit as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
longitudMaxString = get( handles.longitudViga, 'String' );
longitudMax = str2double( get( handles.longitudViga, 'String' ) );
inputStringC = (inputString == ',' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.xMasaPuntualEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Distancia incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.xMasaPuntualEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Distancia incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.xMasaPuntualEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Distancia incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input > longitudMax
        set( handles.xMasaPuntualEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. El valor máximo es %s.', ...
            inputString, longitudMaxString ), ...
            'Distancia incorrecta', 'modal' )
        uicontrol( hObject )
        return    
    end
else
    set( handles.xMasaPuntualEdit, 'String', '' );    
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function xMasaPuntualEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to xMasaPuntualEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes when selected object is changed in condicionesContornoPanel.
function condicionesContornoPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in condicionesContornoPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

inhabilitarSalida( handles );

guidata( hObject, handles );



function anchuraEdit_Callback(hObject, eventdata, handles)
% hObject    handle to anchuraEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of anchuraEdit as text
%        str2double(get(hObject,'String')) returns contents of anchuraEdit as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = (inputString == ',' );


if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.anchuraEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Anchura incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.anchuraEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Anchura incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.anchuraEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Anchura incorrecta', 'modal' )
        uicontrol( hObject )
        return
    end
else
    set( handles.anchuraEdit, 'String', '' );    
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function anchuraEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to anchuraEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function alturaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to alturaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of alturaEdit as text
%        str2double(get(hObject,'String')) returns contents of alturaEdit as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = (inputString == ',' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.alturaEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Altura incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.alturaEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Altura incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.alturaEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Altura incorrecta', 'modal' )
        uicontrol( hObject )
        return
    end
else
    set( handles.alturaEdit, 'String', '' );    
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function alturaEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to alturaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function diametroEdit_Callback(hObject, eventdata, handles)
% hObject    handle to diametroEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of diametroEdit as text
%        str2double(get(hObject,'String')) returns contents of diametroEdit as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = (inputString == ',' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.diametroEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Diámetro incorrecto', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.diametroEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Diámetro incorrecto', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.diametroEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Diámetro incorrecto', 'modal' )
        uicontrol( hObject )
        return
    end
else
    set( handles.diametroEdit, 'String', '' );
end

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function diametroEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to diametroEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function densidadEdit_Callback(hObject, eventdata, handles)
% hObject    handle to densidadEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of densidadEdit as text
%        str2double(get(hObject,'String')) returns contents of densidadEdit as a double

inhabilitarSalida( handles );
set( handles.popUpMaterial, 'Value', 3 );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = (inputString == ',' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.densidadEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Densidad incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.densidadEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Densidad incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.densidadEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Densidad incorrecta', 'modal' )
        uicontrol( hObject )
        return    
    end
else
    set( handles.densidadEdit, 'String', '' );    
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function densidadEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to densidadEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function eEdit_Callback(hObject, eventdata, handles)
% hObject    handle to eEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of eEdit as text
%        str2double(get(hObject,'String')) returns contents of eEdit as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = (inputString == ',' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.eEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Módulo de elasticidad incorrecto', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.eEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Módulo de elasticidad incorrecto', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.eEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Módulo de elasticidad incorrecto', 'modal' )
        uicontrol( hObject )
        return    
    end
else
    set( handles.eEdit, 'String', '' );    
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function eEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to eEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function areaSeccionEdit_Callback(hObject, eventdata, handles)
% hObject    handle to areaSeccionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of areaSeccionEdit as text
%        str2double(get(hObject,'String')) returns contents of areaSeccionEdit as a double

% handles.areaTransversal = str2double( get( hObject, 'String' ) );
% guidata( hObject, handles );

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = (inputString == ',' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.areaSeccionEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Sección incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.areaSeccionEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Sección incorrecta', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.areaSeccionEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Sección incorrecta', 'modal' )
        uicontrol( hObject )
        return
    end
else
    set( handles.areaSeccionEdit, 'String', '' );
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function areaSeccionEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to areaSeccionEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function momentoIEdit_Callback(hObject, eventdata, handles)
% hObject    handle to momentoIEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of momentoIEdit as text
%        str2double(get(hObject,'String')) returns contents of momentoIEdit as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = (inputString == ',' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0
        set( handles.momentoIEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: formato decimal incorrecto. Introduce "." en vez de ",".', ...
            inputString), 'Momento de inercia incorrecto', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.momentoIEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Momento de inercia incorrecto', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.momentoIEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Momento de inercia incorrecto', 'modal' )
        uicontrol( hObject )
        return    
    end
else
    set( handles.momentoIEdit, 'String', '' );    
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function momentoIEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to momentoIEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end



function nElementosFinitosEdit_Callback(hObject, eventdata, handles)
% hObject    handle to nElementosFinitosEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nElementosFinitosEdit as text
%        str2double(get(hObject,'String')) returns contents of nElementosFinitosEdit as a double

inhabilitarSalida( handles );
inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
inputStringC = ( inputString == ',' );
inputStringP = ( inputString == '.' );

if stringVacio == 0
    if sum( inputStringC ) ~= 0 || sum( inputStringP ) ~= 0
        set( handles.nElementosFinitosEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número entero.', ...
            inputString), 'Número de elementos finitos incorrecto', 'modal' )
        uicontrol( hObject )
        return
    elseif isnan( input )
        set( handles.nElementosFinitosEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un valor numérico.', ...
            inputString), 'Número de elementos finitos incorrecto', 'modal' )
        uicontrol( hObject )
        return
    elseif input <= 0
        set( handles.nElementosFinitosEdit, 'String', '' );
        errordlg( sprintf(...
            '%s: valor incorrecto. Introduce un número positivo.', ...
            inputString), 'Número de elementos finitos incorrecto', 'modal' )
        uicontrol( hObject )
        return    
    end
else
    set( handles.nElementosFinitosEdit, 'String', '' );    
end

guidata( hObject, handles );

% --- Executes during object creation, after setting all properties.
function nElementosFinitosEdit_CreateFcn(hObject, eventdata, handles)
% hObject    handle to nElementosFinitosEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: edit controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in masaPuntualCheckbox.
function masaPuntualCheckbox_Callback(hObject, eventdata, handles)
% hObject    handle to masaPuntualCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: get(hObject,'Value') returns toggle state of masaPuntualCheckbox

inhabilitarSalida( handles );
existeMasaPuntual = get( hObject, 'Value' );

if existeMasaPuntual == 1
    set( handles.masaPuntualEstatic, 'ForegroundColor', [0 0 0] );
    set( handles.masaPuntualEdit, 'BackgroundColor', [1 1 1], ...
        'Enable', 'on' );
    set( handles.xMasaPuntualEstatic, 'ForegroundColor', [0 0 0] );
    set( handles.xMasaPuntualEdit, 'BackgroundColor', [1 1 1], ...
        'Enable', 'on');
    
    if not( isempty( get( handles.xMasaPuntualEdit, 'String' ) ) )
        xMPAuxiliar = str2double( get( handles.xMasaPuntualEdit, 'String' ) );
        lAuxiliar = str2double( get( handles.longitudViga, 'String' ) );
        xMPAuxiliarString = num2str( xMPAuxiliar );
        if lAuxiliar < xMPAuxiliar
            set( handles.xMasaPuntualEdit, 'String', '' );
            errordlg( sprintf(...
                '%s: valor incorrecto. Posición de la masa puntual superior\n a la longitud de la viga.', ...
                xMPAuxiliarString), 'Posición de la masa puntual incorrecta', 'modal' )
            uicontrol( hObject )
            return
        end
    end
else
    set( handles.masaPuntualEstatic, 'ForegroundColor', [0.8 0.8 0.8] );
    set( handles.masaPuntualEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
        'Enable', 'inactive' );
    set( handles.xMasaPuntualEstatic, 'ForegroundColor', [0.8 0.8 0.8] );
    set( handles.xMasaPuntualEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
        'Enable', 'inactive');
end

guidata( hObject, handles );


% --- Executes when selected object is changed in seccionPanel.
function seccionPanel_SelectionChangeFcn(hObject, eventdata, handles)
% hObject    handle to the selected object in seccionPanel 
% eventdata  structure with the following fields (see UIBUTTONGROUP)
%	EventName: string 'SelectionChanged' (read only)
%	OldValue: handle of the previously selected object or empty if none was selected
%	NewValue: handle of the currently selected object
% handles    structure with handles and user data (see GUIDATA)

inhabilitarSalida( handles );
seleccion = get( hObject, 'String' );

switch seleccion
    case 'Rectangular'
        
        set( handles.anchuraEstatico, 'ForegroundColor', [0 0 0] );
        set( handles.anchuraEdit, 'BackgroundColor', [1 1 1], ...
            'Enable', 'on' );
        set( handles.alturaEstatico, 'ForegroundColor', [0 0 0] );
        set( handles.alturaEdit, 'BackgroundColor', [1 1 1], ...
            'Enable', 'on');
        
        set( handles.diametroEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.diametroEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive' );
        set( handles.areaSeccionStatic, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.areaSeccionEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive');
        
        set( handles.areaSeccionStatic, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.areaSeccionEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive' );
        set( handles.momentoIStatic, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.momentoIEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive');
        
    case 'Cilíndrica'
        
        set( handles.anchuraEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.anchuraEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive' );
        set( handles.alturaEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.alturaEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive');
        
        set( handles.diametroEstatico, 'ForegroundColor', [0 0 0] );
        set( handles.diametroEdit, 'BackgroundColor', [1 1 1], ...
            'Enable', 'on' );
        set( handles.areaSeccionStatic, 'ForegroundColor', [0 0 0] );
        set( handles.areaSeccionEdit, 'BackgroundColor', [1 1 1], ...
            'Enable', 'on');
        
        set( handles.areaSeccionStatic, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.areaSeccionEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive' );
        set( handles.momentoIStatic, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.momentoIEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive'); 
        
    case 'Otra'
        
        set( handles.anchuraEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.anchuraEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive' );
        set( handles.alturaEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.alturaEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive');
        
        set( handles.diametroEstatico, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.diametroEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive' );
        set( handles.areaSeccionStatic, 'ForegroundColor', [0.8 0.8 0.8] );
        set( handles.areaSeccionEdit, 'BackgroundColor', [0.8 0.8 0.8], ...
            'Enable', 'inactive');
        
        set( handles.areaSeccionStatic, 'ForegroundColor', [0 0 0] );
        set( handles.areaSeccionEdit, 'BackgroundColor', [1 1 1], ...
            'Enable', 'on' );
        set( handles.momentoIStatic, 'ForegroundColor', [0 0 0] );
        set( handles.momentoIEdit, 'BackgroundColor', [1 1 1], ...
            'Enable', 'on');

end
        
guidata( hObject, handles );


% --- Executes on button press in calcularBoton.
function calcularBoton_Callback(hObject, eventdata, handles)
% hObject    handle to calcularBoton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

errorSalida = '';
seleccionCCString = ...
        get( get( handles.condicionesContornoPanel, 'SelectedObject' ), 'String' );
seleccionSeccionString = ...
        get( get(handles.seccionPanel,'SelectedObject'), 'String' );


if not( strcmp( seleccionCCString, 'Libre - Libre' )  || ...
        strcmp( seleccionCCString, 'Empotrada - Libre' )  || ...
        strcmp( seleccionCCString, 'Empotrada - Empotrada' )  || ...
        strcmp( seleccionCCString, 'Empotrada - Apoyada' )  || ...
        strcmp( seleccionCCString, 'Apoyada - Apoyada' ) )
    errorCadena = 'Variable "Condición de contorno" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];    
end

if isempty( get( handles.longitudViga, 'String' ) )    
    errorCadena = 'Variable "Longitud de viga" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end

if not( strcmp( seleccionSeccionString, 'Rectangular' ) || ...
        strcmp( seleccionSeccionString, 'Cilíndrica' ) || ...
        strcmp( seleccionSeccionString, 'Otra' ) )
    errorCadena = 'Variable "Tipo de sección de viga" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];    
end    

if isempty( get( handles.anchuraEdit, 'String' ) ) && ...
        strcmp( seleccionSeccionString, 'Rectangular' )
    errorCadena = 'Variable "Anchura" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end

if isempty( get( handles.alturaEdit, 'String' ) ) && ...
        strcmp( seleccionSeccionString, 'Rectangular' )
    errorCadena = 'Variable "Altura" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end

if isempty( get( handles.diametroEdit, 'String' ) ) && ...
        strcmp( seleccionSeccionString, 'Cilíndrica' )
    errorCadena = 'Variable "Diámetro" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end
    
if isempty( get( handles.areaSeccionEdit, 'String' ) ) && ...
        strcmp( seleccionSeccionString, 'Otra' )
    errorCadena = 'Variable "Área transversal" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end

if isempty( get( handles.momentoIEdit, 'String' ) ) && ...
        strcmp( seleccionSeccionString, 'Otra' )
    errorCadena = 'Variable "Momento de inercia" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end

if isempty( get( handles.densidadEdit, 'String' ) )
    errorCadena = 'Variable "Densidad" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end    

if isempty( get( handles.eEdit, 'String' ) )   
    errorCadena = 'Variable "Módulo de elasticidad" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end    

if isempty( get( handles.masaPuntualEdit, 'String' ) ) && ...
        get( handles.masaPuntualCheckbox, 'Value' ) == 1
    errorCadena = 'Variable "Masa puntual" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end

if isempty( get( handles.xMasaPuntualEdit, 'String' ) ) && ...
        get( handles.masaPuntualCheckbox, 'Value' ) == 1
    errorCadena = 'Variable "Localización de la masa puntual" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end
    
if isempty( get( handles.nElementosFinitosEdit, 'String' ) ) 
    errorCadena = 'Variable "Número de elementos finitos" no introducida.\n';
    errorSalida = [ errorSalida, errorCadena ];
end

if strcmp( errorSalida, '' )
    [ viga, masaPuntualViga, elementosFinitos ] = entrada_datos( handles );

    [ kLocal ] = matriz_rigidez_local( viga, elementosFinitos );

    [ mLocal ] = matriz_masa_local( viga, elementosFinitos );

    [ matrizRigidez, matrizMasa, elementosFinitos ] = generar_matrices( ...
        kLocal, mLocal, elementosFinitos, masaPuntualViga );

    [ vibraciones ] = auto_val_vec( matrizRigidez, matrizMasa, ...
        elementosFinitos );
    
    % Representación de las frecuencias naturales en formato tabla y 
    % activación de botón de guardado de frecuencias.
    set( handles.tablaFN, 'data', vibraciones.frecuenciaNatural );
    set( handles.guardarFrecuenciasNaturales, 'Enable', 'on', ...
            'ForegroundColor', [ 0 0 0 ] );
    
    
    % Activación de masBoton, menosBoton, nGraficaEdit, botonGuardarMP y
    % botonGuardarGrafica.
    set( handles.masBoton, 'Enable', 'on', 'ForegroundColor', [ 0 0 0 ] );
    set( handles.menosBoton, 'Enable', 'on', 'ForegroundColor', [ 0 0 0 ] );
    set( handles.nGraficaEdit, 'Enable', 'on', ...
            'BackgroundColor', [1 1 1] );
    set( handles.botonGuardarMP, 'Enable', 'on', ...
        'ForegroundColor', [ 0 0 0 ] );
    set( handles.botonGuardarGrafica, 'Enable', 'on', ...
        'ForegroundColor', [ 0 0 0 ] );
        
    % Representación de los modos propios.
    valor = get( handles.nGraficaEdit, 'String');

    if isempty( valor )
        n = 1;
    else 
        n = str2double( valor );
    end
    
    [ posicionNodos, modoPropioNormaGrafica ] = ...
        grafica_modo_propio( n, vibraciones, elementosFinitos );

    set(handles.nGraficaEdit, 'String', num2str( n ));

    % Guardado de las estructuras viga, vibraciones y elementosFinitos
    % en la estructura handles.
    handles.viga = viga;
    handles.vibraciones = vibraciones;
    handles.elementosFinitos = elementosFinitos;
    handles.matrizRigidez = matrizRigidez;
    handles.matrizMasa = matrizMasa;
    
    % Guardado de posicionNodos y modoPropioNormaGrafica en handles.
    handles.posicionNodos = posicionNodos;
    handles.modoPropioNormaGrafica = modoPropioNormaGrafica;

    % Actualización de la handles.
    guidata( hObject, handles );
else
    errordlg( sprintf( strcat( errorSalida ) ), 'Error', 'modal' );
end


% --- Executes on key press with focus on longitudViga and none of its controls.
function longitudViga_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to longitudViga (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- If Enable == 'on', executes on mouse press in 5 pixel border.
% --- Otherwise, executes on mouse press in 5 pixel border or over longitudViga.
function longitudViga_ButtonDownFcn(hObject, eventdata, handles)
% hObject    handle to longitudViga (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% input = str2double( get( hObject, 'string' ) );
% 
% if isnan( input )
%     errordlg( 'Valor incorrecto. Introduce un valor numérico.', ...
%         'Longitud incorrecta', 'modal' )
%     uicontrol( hObject )
%     return
% else
%     handles.longitud = str2double( get( hObject, 'String' ) );
% end
% 
% guidata( hObject, handles );


% --- Executes when selected cell(s) is changed in tablaFN.
function tablaFN_CellSelectionCallback(hObject, eventdata, handles)
% hObject    handle to tablaFN (see GCBO)
% eventdata  structure with the following fields (see UITABLE)
%	Indices: row and column indices of the cell(s) currently selecteds
% handles    structure with handles and user data (see GUIDATA)

% seleccion = event.Indices;
% disp(evt);


% --- Executes on button press in menosBoton.
function menosBoton_Callback(hObject, eventdata, handles)
% hObject    handle to menosBoton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

modoPropioAnterior = str2double( get( handles.nGraficaEdit, 'String' ) );
modoPropioPosterior = modoPropioAnterior - 1;

if modoPropioPosterior >= 1
    set( handles.nGraficaEdit, 'String', num2str( modoPropioPosterior ) );
    
    vibraciones = handles.vibraciones;
    elementosFinitos = handles.elementosFinitos;

    [ posicionNodos, modoPropioNormaGrafica ] = ...
        grafica_modo_propio( modoPropioPosterior, vibraciones, ...
        elementosFinitos );
end

handles.posicionNodos = posicionNodos;
handles.modoPropioNormaGrafica = modoPropioNormaGrafica;

guidata( hObject, handles );


% --- Executes on button press in masBoton.
function masBoton_Callback(hObject, eventdata, handles)
% hObject    handle to masBoton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

vibraciones = handles.vibraciones;
elementosFinitos = handles.elementosFinitos;

modoPropioAnterior = str2double( get( handles.nGraficaEdit, 'String' ) );
modoPropioPosterior = modoPropioAnterior + 1;
maxFN = max( size( vibraciones.frecuenciaNatural ) );

if modoPropioPosterior <= maxFN
    set( handles.nGraficaEdit, 'String', num2str( modoPropioPosterior ) );
	[ posicionNodos, modoPropioNormaGrafica ] = ...
        grafica_modo_propio( modoPropioPosterior, vibraciones, ...
        elementosFinitos );
end

handles.posicionNodos = posicionNodos;
handles.modoPropioNormaGrafica = modoPropioNormaGrafica;

guidata( hObject, handles );


function nGraficaEdit_Callback(hObject, eventdata, handles)
% hObject    handle to nGraficaEdit (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: get(hObject,'String') returns contents of nGraficaEdit as text
%        str2double(get(hObject,'String')) returns contents of nGraficaEdit as a double

inputString = get( hObject, 'String' );
input = str2double( get( hObject, 'String' ) );
stringVacio = isempty( get( hObject, 'String' ) );
vibraciones = handles.vibraciones;
elementosFinitos = handles.elementosFinitos;
maxFN = max( size( vibraciones.frecuenciaNatural ) );
maxFNString = num2str( maxFN );
inputStringC = ( inputString == ',' );
inputStringP = ( inputString == '.' );

if ( sum( inputStringC ) ~= 0 || sum( inputStringP ) ~= 0 ) && stringVacio == 0        
    set( handles.nGraficaEdit, 'String', '' );
    errordlg( sprintf(...
        '%s: valor incorrecto. Introduce un número entero.', ...
        inputString), 'Error', 'modal' )
    uicontrol( hObject )
    return
elseif isnan( input ) && stringVacio == 0
    set( handles.nGraficaEdit, 'String', '' );
    errordlg( sprintf(...
        '%s: valor incorrecto. Introduce un valor numérico.', ...
        inputString), 'Error', 'modal' )
    uicontrol( hObject )
    return
elseif input < 1 && stringVacio == 0
    set( handles.nGraficaEdit, 'String', '' );
    errordlg( sprintf(...
        '%s: valor incorrecto. Introduce un número positivo.', ...
        inputString), 'Error', 'modal' )
    uicontrol( hObject )
    return
elseif input > maxFN && stringVacio == 0
    set( handles.nGraficaEdit, 'String', '' );
    errordlg( sprintf(...
        [ '%s: valor incorrecto.\nIntroduce un modo propio '...
        'inferior o igual a %s.' ], ...
        inputString, maxFNString), 'Error', 'modal' )
    uicontrol( hObject )
    return
elseif stringVacio ~= 0
    set( handles.nGraficaEdit, 'String', '' );
    errordlg( sprintf( [ 'El campo de modo propio no puede estar vacío.\n'...
        'Introduce un modo propio a representar.' ] ), 'Error', 'modal' );
    uicontrol( hObject )
    return
else
    [ posicionNodos, modoPropioNormaGrafica ] = ...
        grafica_modo_propio( input, vibraciones, elementosFinitos );        
end

handles.posicionNodos = posicionNodos;
handles.modoPropioNormaGrafica = modoPropioNormaGrafica;

guidata( hObject, handles );


% --- Executes on key press with focus on densidadEdit and none of its controls.
function densidadEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to densidadEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on eEdit and none of its controls.
function eEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to eEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on masaPuntualEdit and none of its controls.
function masaPuntualEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to masaPuntualEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on xMasaPuntualEdit and none of its controls.
function xMasaPuntualEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to xMasaPuntualEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on nElementosFinitosEdit and none of its controls.
function nElementosFinitosEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to nElementosFinitosEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on anchuraEdit and none of its controls.
function anchuraEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to anchuraEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on alturaEdit and none of its controls.
function alturaEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to alturaEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on diametroEdit and none of its controls.
function diametroEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to diametroEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on areaSeccionEdit and none of its controls.
function areaSeccionEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to areaSeccionEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes on key press with focus on momentoIEdit and none of its controls.
function momentoIEdit_KeyPressFcn(hObject, eventdata, handles)
% hObject    handle to momentoIEdit (see GCBO)
% eventdata  structure with the following fields (see UICONTROL)
%	Key: name of the key that was pressed, in lower case
%	Character: character interpretation of the key(s) that was pressed
%	Modifier: name(s) of the modifier key(s) (i.e., control, shift) pressed
% handles    structure with handles and user data (see GUIDATA)

figure(gcbf);
drawnow;


% --- Executes when user attempts to close AMVI.
function vigaGUI_CloseRequestFcn(hObject, eventdata, handles)
% hObject    handle to AMVI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hint: delete(hObject) closes the figure
delete(hObject);


% --- Executes during object creation, after setting all properties.
function vigaGUI_CreateFcn(hObject, eventdata, handles)
% hObject    handle to AMVI (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function masaPuntualPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to masaPuntualPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function masaPuntualCheckbox_CreateFcn(hObject, eventdata, handles)
% hObject    handle to masaPuntualCheckbox (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes during object creation, after setting all properties.
function geometriaVigaPanel_CreateFcn(hObject, eventdata, handles)
% hObject    handle to geometriaVigaPanel (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called


% --- Executes on selection change in popUpMaterial.
function popUpMaterial_Callback(hObject, eventdata, handles)
% hObject    handle to popUpMaterial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% Hints: contents = cellstr(get(hObject,'String')) returns popUpMaterial contents as cell array
%        contents{get(hObject,'Value')} returns selected item from popUpMaterial

seleccion = get( hObject, 'Value' );

if handles.materialAnterior ~= seleccion
    inhabilitarSalida( handles );
    handles.materialAnterior = seleccion;
	switch seleccion
		case 1
			set( handles.densidadEdit, 'Enable', 'inactive' );
			set( handles.eEdit, 'Enable', 'inactive' );
		    set( handles.densidadEdit, 'String', '7850' );
		    set( handles.eEdit, 'String', '210e9' );
		case 2
			set( handles.densidadEdit, 'Enable', 'inactive' );
			set( handles.eEdit, 'Enable', 'inactive' );
		    set( handles.densidadEdit, 'String', '2698.4' );
		    set( handles.eEdit, 'String', '69.e9' );
		case 3
			set( handles.densidadEdit, 'Enable', 'on' );
			set( handles.eEdit, 'Enable', 'on' );
		    set( handles.densidadEdit, 'String', '' );
		    set( handles.eEdit, 'String', '' );
	end
end

guidata( hObject, handles );


% --- Executes during object creation, after setting all properties.
function popUpMaterial_CreateFcn(hObject, eventdata, handles)
% hObject    handle to popUpMaterial (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    empty - handles not created until after all CreateFcns called

% Hint: popupmenu controls usually have a white background on Windows.
%       See ISPC and COMPUTER.
if ispc && isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor','white');
end


% --- Executes on button press in botonGuardarGrafica.
function botonGuardarGrafica_Callback(hObject, eventdata, handles)
% hObject    handle to botonGuardarGrafica (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

% clear nombreArchivo rutaDirectorio;
% [nombreArchivo, rutaDirectorio] = uiputfile( '*.png', ...
%     'Guardar gráfica de modo propio' );
% 
% if nombreArchivo == 0
%     nombreArchivo = num2str( nombreArchivo );
%     rutaDirectorio = num2str( rutaDirectorio );
% end
% 
% if not( strcmp( nombreArchivo, '0' ) )
%     rutaArchivo = strcat( rutaDirectorio, nombreArchivo );
%     F = getframe( handles.axes2 );
%     image( F.cdata );
%     imwrite( F.cdata, rutaArchivo );
%     cd( rutaDirectorio );
% end

vibraciones = handles.vibraciones;
elementosFinitos = handles.elementosFinitos;
valor = get( handles.nGraficaEdit, 'String');

if not( isempty( valor ) )
    n = str2double( valor );
    figure();
    grafica_modo_propio( n, vibraciones, elementosFinitos );
end






% --- Executes on button press in guardarFrecuenciasNaturales.
function guardarFrecuenciasNaturales_Callback(hObject, eventdata, handles)
% hObject    handle to guardarFrecuenciasNaturales (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear nombreArchivo rutaDirectorio;

vibracionesEstructura = handles.vibraciones;
frecuenciaNatural = vibracionesEstructura.frecuenciaNatural;
N = ( 1 : max( size( frecuenciaNatural ) ) );
matrizSalidaNFN = [ N; frecuenciaNatural' ];
[nombreArchivo, rutaDirectorio] = uiputfile( '*.txt', ...
    'Guardar frecuencias naturales' );

if nombreArchivo == 0
    nombreArchivo = num2str( nombreArchivo );
    rutaDirectorio = num2str( rutaDirectorio );
end

if not( strcmp( nombreArchivo, '0' ) )
    rutaArchivo = strcat( rutaDirectorio, nombreArchivo );
    fileID = fopen( rutaArchivo, 'w' );
    fprintf( fileID, '%6s %30s\r\n', 'N', 'Frecuencias Naturales (Hz)' );
    fprintf( fileID, '%6s %30s\r\n', '', '' );
    fprintf( fileID, '%6d %30.8g\r\n', matrizSalidaNFN );
    fclose(fileID);
    cd( rutaDirectorio )
end


% --- Executes on button press in debugBoton.
function debugBoton_Callback(hObject, eventdata, handles)
% hObject    handle to debugBoton (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

keyboard


% --- Executes on button press in botonGuardarMP.
function botonGuardarMP_Callback(hObject, eventdata, handles)
% hObject    handle to botonGuardarMP (see GCBO)
% eventdata  reserved - to be defined in a future version of MATLAB
% handles    structure with handles and user data (see GUIDATA)

clear nombreArchivo rutaDirectorio;

posicionNodos = handles.posicionNodos;
modoPropioNormaGrafica = handles.modoPropioNormaGrafica;
matrizSalidaPMP = [ posicionNodos; modoPropioNormaGrafica ];

[nombreArchivo, rutaDirectorio] = uiputfile( '*.txt', ...
    'Guardar modo propio' );

if nombreArchivo == 0
    nombreArchivo = num2str( nombreArchivo );
    rutaDirectorio = num2str( rutaDirectorio );
end

if not( strcmp( nombreArchivo, '0' ) )
    rutaArchivo = strcat( rutaDirectorio, nombreArchivo );
    fileID = fopen( rutaArchivo, 'w' );
    fprintf( fileID, '%15s %30s\r\n', 'x (m)', 'Modo propio' );
    fprintf( fileID, '%15s %30s\r\n', '', '' );
    fprintf( fileID, '%15.8g %30.8g\r\n', matrizSalidaPMP );
    fclose(fileID);
    cd( rutaDirectorio )
end
