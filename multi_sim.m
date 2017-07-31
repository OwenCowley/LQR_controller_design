%% Run to simulate model

function varargout = multi_sim(varargin)
gui_Singleton = 1;
gui_State = struct('gui_Name',       mfilename, ...
                   'gui_Singleton',  gui_Singleton, ...
                   'gui_OpeningFcn', @multi_sim_OpeningFcn, ...
                   'gui_OutputFcn',  @multi_sim_OutputFcn, ...
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

%=============================Initialization===============================

function multi_sim_OpeningFcn(hObject, eventdata, handles, varargin)

handles.output = hObject;

global v f v_r index accelerometer gyroscope plot_length update_rate camera camera1_scale;

load_system('multi_model');

set_param('multi_model/ch1_input', 'Value', '1500');
set_param('multi_model/ch2_input', 'Value', '1500');
set_param('multi_model/ch3_input', 'Value', '1500');
set_param('multi_model/ch4_input', 'Value', '1500');
set_param('multi_model/ch5_input', 'Value', '1500');
set_param('multi_model/ch6_input', 'Value', '1000');

camera = 1;
camera1_scale = 0.1;
update_rate = 24;
plot_length = 10;
index = update_rate * plot_length;

gyroscope = zeros(4, index);
accelerometer = zeros(4, index);
axes(handles.model_plot);
axis('off');
axes(handles.gyroscope_plot);
axis('off');
axes(handles.accelerometer_plot);
axis('off');

fid = fopen('model.stl', 'r');
ftitle = fread(fid,80,'uchar=>schar');
numFaces = fread(fid,1,'int32');
T = fread(fid,inf,'uint8=>uint8');
fclose(fid);
trilist = 1:48;
ind = reshape(repmat(50*(0:(numFaces-1)),[48,1]),[1,48*numFaces])+repmat(trilist,[1,numFaces]);
Tri = reshape(typecast(T(ind),'single'),[3,4,numFaces]);
v = Tri(:,2:4,:);
v = reshape(v,[3,3*numFaces]);
v = double(v)';
f = reshape(1:3*numFaces,[3,numFaces])';
v_r = v * [1, 0, 0; 0, 1, 0; 0, 0, 1];

handles.timer = timer('ExecutionMode', 'fixedSpacing', 'Period', round(1000 / update_rate) / 1000, 'TimerFcn', {@update_data, handles});

guidata(hObject, handles);

function varargout = multi_sim_OutputFcn(hObject, eventdata, handles) 
varargout{1} = handles.output;

function ch6_pwm_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function ch5_pwm_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function ch4_pwm_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function ch3_pwm_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function ch2_pwm_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function ch1_pwm_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

function slider_scale_CreateFcn(hObject, eventdata, handles)
if isequal(get(hObject,'BackgroundColor'), get(0,'defaultUicontrolBackgroundColor'))
    set(hObject,'BackgroundColor',[.9 .9 .9]);
end

%==================================Buttons================================= 
    
function camera_1_Callback(hObject, eventdata, handles)
global camera;
camera = 1;
set(handles.camera_1, 'Enable', 'off');
set(handles.camera_2, 'Enable', 'on');
set(handles.camera_3, 'Enable', 'on');
%set(handles.start_button, 'Enable', 'off');

function camera_2_Callback(hObject, eventdata, handles)
global camera;
camera = 2;
set(handles.camera_1, 'Enable', 'on');
set(handles.camera_2, 'Enable', 'off');
set(handles.camera_3, 'Enable', 'on');

function camera_3_Callback(hObject, eventdata, handles)
global camera;
camera = 3;
set(handles.camera_1, 'Enable', 'on');
set(handles.camera_2, 'Enable', 'on');
set(handles.camera_3, 'Enable', 'off');

function slider_scale_Callback(hObject, eventdata, handles)
global camera1_scale;
camera1_scale = get(hObject,'Value');
set(handles.scale,'String', round(10*get(hObject,'Value'))/10);

function model_button_Callback(hObject, eventdata, handles)
if get(hObject,'value') ~= 1
    axes(handles.model_plot);
    cla;
    axis('off')
end

function gyroscope_button_Callback(hObject, eventdata, handles)
global update_rate plot_length gyroscope;
if get(hObject,'value') ~= 1
    gyroscope = zeros(4, update_rate * plot_length);
    axes(handles.gyroscope_plot);
    cla;
    axis('off');
end

function accelerometer_button_Callback(hObject, eventdata, handles)
global update_rate plot_length accelerometer;
if get(hObject,'value') ~= 1
    accelerometer = zeros(4, update_rate * plot_length);
    axes(handles.accelerometer_plot);
    cla;
    axis('off');
end

function measurements_button_Callback(hObject, eventdata, handles)
if get(hObject,'value') ~= 1
    set(handles.x_position,'String', '');
    set(handles.y_position,'String', '');
    set(handles.z_position,'String', '');

    set(handles.x_velocity,'String', '');
    set(handles.y_velocity,'String', '');
    set(handles.z_velocity,'String', '');

    set(handles.roll_attitude,'String', '');
    set(handles.pitch_attitude,'String', '');
    set(handles.yaw_attitude,'String', '');

    set(handles.roll_rate,'String', '');
    set(handles.pitch_rate,'String', '');
    set(handles.yaw_rate,'String', '');
    
    set(handles.out1,'String', '');
    set(handles.out2,'String', '');
    set(handles.out3,'String', '');
    set(handles.out4,'String', '');
    set(handles.out5,'String', '');
    set(handles.out6,'String', '');
    set(handles.out7,'String', '');
    set(handles.out8,'String', '');
end

function start_button_Callback(hObject, eventdata, handles)
global index gyroscope accelerometer;
set(handles.start_button, 'Enable', 'off');
set(handles.stop_button, 'Enable', 'on');
gyroscope = zeros(4, index);
accelerometer = zeros(4, index);
set_param('multi_model','SimulationCommand','Start');
start(handles.timer);

function stop_button_Callback(hObject, eventdata, handles)
set(handles.start_button, 'Enable', 'on');
set(handles.stop_button, 'Enable', 'off');
set_param('multi_model','SimulationCommand','Stop');
stop(handles.timer);

function ch6_center_Callback(hObject, eventdata, handles)
if get(hObject,'value') == 1
    set(handles.ch6_center, 'Enable', 'off');
end
set(handles.pwm6,'String', '1500');
set(handles.ch6_pwm,'Value',1500);
set_param('multi_model/ch6_input', 'Value', '1500');

function ch5_center_Callback(hObject, eventdata, handles)
if get(hObject,'value') == 1
    set(handles.ch5_center, 'Enable', 'off');
end
set(handles.pwm5,'String', '1500');
set(handles.ch5_pwm,'Value',1500);
set_param('multi_model/ch5_input', 'Value', '1500');

function ch4_center_Callback(hObject, eventdata, handles)
if get(hObject,'value') == 1
    set(handles.ch4_center, 'Enable', 'off');
end
set(handles.pwm4,'String', '1500');
set(handles.ch4_pwm,'Value',1500);
set_param('multi_model/ch4_input', 'Value', '1500');

function ch3_center_Callback(hObject, eventdata, handles)
if get(hObject,'value') == 1
    set(handles.ch3_center, 'Enable', 'off');
end
set(handles.pwm3,'String', '1500');
set(handles.ch3_pwm,'Value',1500);
set_param('multi_model/ch3_input', 'Value', '1500');

function ch2_center_Callback(hObject, eventdata, handles)
if get(hObject,'value') == 1
    set(handles.ch2_center, 'Enable', 'off');
end
set(handles.pwm2,'String', '1500');
set(handles.ch2_pwm,'Value',1500);
set_param('multi_model/ch2_input', 'Value', '1500');

function ch1_center_Callback(hObject, eventdata, handles)
if get(hObject,'value') == 1
    set(handles.ch1_center, 'Enable', 'off');
end
set(handles.pwm1,'String', '1500');
set(handles.ch1_pwm,'Value',1500);
set_param('multi_model/ch1_input', 'Value', '1500');

function ch6_pwm_Callback(hObject, eventdata, handles)
set(handles.pwm6,'String', sprintf('%f', get(hObject,'value')));
if get(hObject,'value') ~= 1500
    set(handles.ch6_center, 'Value', 0);
    set(handles.ch6_center, 'Enable', 'on');
elseif get(hObject,'value') == 1500
    set(handles.ch6_center, 'Value', 1);
    set(handles.ch6_center, 'Enable', 'off');
end
set_param('multi_model/ch6_input', 'Value', sprintf('%f', get(hObject,'value')));

function ch5_pwm_Callback(hObject, eventdata, handles)
set(handles.pwm5,'String', sprintf('%f', get(hObject,'value')));
if get(hObject,'value') ~= 1500
    set(handles.ch5_center, 'Value', 0);
    set(handles.ch5_center, 'Enable', 'on');
elseif get(hObject,'value') == 1500
    set(handles.ch5_center, 'Value', 1);
    set(handles.ch5_center, 'Enable', 'off');
end
set_param('multi_model/ch5_input', 'Value', sprintf('%f', get(hObject,'value')));

function ch4_pwm_Callback(hObject, eventdata, handles)
set(handles.pwm4,'String', sprintf('%f', get(hObject,'value')));
if get(hObject,'value') ~= 1500
    set(handles.ch4_center, 'Value', 0);
    set(handles.ch4_center, 'Enable', 'on');
elseif get(hObject,'value') == 1500
    set(handles.ch4_center, 'Value', 1);
    set(handles.ch4_center, 'Enable', 'off');
end
set_param('multi_model/ch4_input', 'Value', sprintf('%f', get(hObject,'value')));

function ch3_pwm_Callback(hObject, eventdata, handles)
set(handles.pwm3,'String', sprintf('%f', get(hObject,'value')));
if get(hObject,'value') ~= 1500
    set(handles.ch3_center, 'Value', 0);
    set(handles.ch3_center, 'Enable', 'on');
elseif get(hObject,'value') == 1500
    set(handles.ch3_center, 'Value', 1);
    set(handles.ch3_center, 'Enable', 'off');
end
set_param('multi_model/ch3_input', 'Value', sprintf('%f', get(hObject,'value')));

function ch2_pwm_Callback(hObject, eventdata, handles)
set(handles.pwm2,'String', sprintf('%f', get(hObject,'value')));
if get(hObject,'value') ~= 1500
    set(handles.ch2_center, 'Value', 0);
    set(handles.ch2_center, 'Enable', 'on');
elseif get(hObject,'value') == 1500
    set(handles.ch2_center, 'Value', 1);
    set(handles.ch2_center, 'Enable', 'off');
end
set_param('multi_model/ch2_input', 'Value', sprintf('%f', get(hObject,'value')));

function ch1_pwm_Callback(hObject, eventdata, handles)
set(handles.pwm1,'String', sprintf('%f', get(hObject,'value')));
if get(hObject,'value') ~= 1500
    set(handles.ch1_center, 'Value', 0);
    set(handles.ch1_center, 'Enable', 'on');
elseif get(hObject,'value') == 1500
    set(handles.ch1_center, 'Value', 1);
    set(handles.ch1_center, 'Enable', 'off');
end
set_param('multi_model/ch1_input', 'Value', sprintf('%f', get(hObject,'value')));

%==================================Graphics================================

function update_data(hObject, eventdata, handles)
tic;

global v f v_r index accelerometer gyroscope plot_length camera camera1_scale;

camera2_scale = camera1_scale * 1;
camera3_scale = camera1_scale * 1;

simulation_data = get_param('multi_model/dynamic_model/simulation_data', 'RuntimeObject');
simulation_time = simulation_data.InputPort(19).Data;

%------------------------------Plot Gyroscope------------------------------
if get(handles.gyroscope_button, 'Value') == 1
    gyroscope = circshift(gyroscope, [4 -1]);
    axes(handles.gyroscope_plot);
    gyroscope(1, index) = simulation_data.InputPort(16).Data;
    gyroscope(2, index) = simulation_data.InputPort(17).Data;
    gyroscope(3, index) = simulation_data.InputPort(18).Data;
    gyroscope(4, index) = simulation_time;
    plot(gyroscope(4,:), gyroscope(1,:), gyroscope(4,:), gyroscope(2,:), gyroscope(4,:), gyroscope(3,:));
    ylim('auto');
    if simulation_time < plot_length
        xlim([0 plot_length]);
    else
        xlim([simulation_time - plot_length simulation_time]);
    end
end

%----------------------------Plot Accelerometer----------------------------
if get(handles.accelerometer_button, 'Value') == 1
    accelerometer = circshift(accelerometer, [4 -1]);
    axes(handles.accelerometer_plot);
    accelerometer(1, index) = simulation_data.InputPort(13).Data;
    accelerometer(2, index) = simulation_data.InputPort(14).Data;
    accelerometer(3, index) = -simulation_data.InputPort(15).Data;
    accelerometer(4, index) = simulation_time;
    plot(accelerometer(4,:), accelerometer(1,:), accelerometer(4,:), accelerometer(2,:), accelerometer(4,:), accelerometer(3,:));
    ylim('auto');
    if simulation_time < plot_length
        xlim([0 plot_length]);
    else
        xlim([simulation_time - plot_length simulation_time]);
    end
end

%-------------------------------Update Data--------------------------------
if get(handles.measurements_button, 'Value') == 1    
    set(handles.x_position,'String', sprintf('%f', simulation_data.InputPort(4).Data));
    set(handles.y_position,'String', sprintf('%f', simulation_data.InputPort(5).Data));
    set(handles.z_position,'String', sprintf('%f', -simulation_data.InputPort(6).Data));

    set(handles.x_velocity,'String', sprintf('%f', simulation_data.InputPort(1).Data));
    set(handles.y_velocity,'String', sprintf('%f', simulation_data.InputPort(2).Data));
    set(handles.z_velocity,'String', sprintf('%f', -simulation_data.InputPort(3).Data));

    set(handles.roll_attitude,'String', sprintf('%f', simulation_data.InputPort(7).Data));
    set(handles.pitch_attitude,'String', sprintf('%f', simulation_data.InputPort(8).Data));
    set(handles.yaw_attitude,'String', sprintf('%f', simulation_data.InputPort(9).Data));

    set(handles.roll_rate,'String', sprintf('%f', simulation_data.InputPort(10).Data));
    set(handles.pitch_rate,'String', sprintf('%f', simulation_data.InputPort(11).Data));
    set(handles.yaw_rate,'String', sprintf('%f', simulation_data.InputPort(12).Data));
    
    control_data = get_param('multi_model/dynamic_model/control_data', 'RuntimeObject');
    
    set(handles.out1,'String', sprintf('%f', control_data.InputPort(1).Data(1)));
    set(handles.out2,'String', sprintf('%f', control_data.InputPort(2).Data(1)));
    set(handles.out3,'String', sprintf('%f', control_data.InputPort(3).Data(1)));
    set(handles.out4,'String', sprintf('%f', control_data.InputPort(4).Data(1)));
    set(handles.out5,'String', sprintf('%f', control_data.InputPort(5).Data(1)));
    set(handles.out6,'String', sprintf('%f', control_data.InputPort(6).Data(1)));
    set(handles.out7,'String', sprintf('%f', control_data.InputPort(7).Data(1)));
    set(handles.out8,'String', sprintf('%f', control_data.InputPort(8).Data(1)));
end

%-------------------------------Update Model-------------------------------
if get(handles.model_button, 'Value') == 1      
    roll_attitude = -simulation_data.InputPort(7).Data;
    pitch_attitude = -simulation_data.InputPort(8).Data;
    yaw_attitude = simulation_data.InputPort(9).Data;
    
    pitch_matrix = [1 0 0; 0 cosd(pitch_attitude) -sind(pitch_attitude); 0 sind(pitch_attitude) cosd(pitch_attitude)];
    roll_matrix = [cosd(roll_attitude) 0 sind(roll_attitude); 0 1 0; -sind(roll_attitude) 0 cosd(roll_attitude)];
    yaw_matrix = [cosd(yaw_attitude) -sind(yaw_attitude) 0; sind(yaw_attitude) cosd(yaw_attitude) 0; 0 0 1];

    v = v_r * pitch_matrix * roll_matrix * yaw_matrix;

    axes(handles.model_plot);
    cla(handles.model_plot);
    patch('Faces',f,'Vertices',v, 'FaceColor', [0.5 0.5 0.5], 'EdgeColor', 'none', 'FaceLighting', 'gouraud', 'AmbientStrength', 0.01);
    camlight('headlight');
    material('dull');
    axis('off');
    
    if camera == 1
        xlim([-camera1_scale camera1_scale]);
        ylim([-camera1_scale camera1_scale]);
        zlim([-camera1_scale camera1_scale]);
        camproj('perspective');
        view([0 15]);
        
    elseif camera == 2       
        y_focus = -simulation_data.InputPort(4).Data;
        x_focus = -simulation_data.InputPort(5).Data;
        z_focus = simulation_data.InputPort(6).Data;
        ylim([y_focus-camera2_scale y_focus+camera2_scale]);
        xlim([x_focus-camera2_scale x_focus+camera2_scale]);
        zlim([z_focus-camera2_scale z_focus+camera2_scale]);
        camproj('perspective');
        view([0, -1, 0.5]);
        
    elseif camera == 3
        y_focus = -simulation_data.InputPort(4).Data;
        x_focus = -simulation_data.InputPort(5).Data;
        z_focus = simulation_data.InputPort(6).Data;
        ylim([y_focus-camera3_scale y_focus+camera3_scale]);
        xlim([x_focus-camera3_scale x_focus+camera3_scale]);
        zlim([z_focus-camera3_scale z_focus+camera3_scale]);
        camproj('perspective');
        view([0, 0, camera3_scale]);
    end
    
end

drawnow;
cycles = 1 / toc;
if camera == 1
    set(handles.update_rate,'String', ['1 - Fixed [' num2str(round(cycles)) ' fps]']);
elseif camera == 2
    set(handles.update_rate,'String', ['2 - Rear [' num2str(round(cycles)) ' fps]']);
elseif camera == 3
    set(handles.update_rate,'String', ['3 - Top [' num2str(round(cycles)) ' fps]']);
end
