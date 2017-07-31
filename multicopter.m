function [forces, moments] = multicopter(omega, DCM, velocity, density, rotors)

%================================Constants=================================

coefficient_drag = 15;              % coefficient of drag
rotor_inertia = 5.16128e-06;          % rotor inertia                         (kg m^2)
prop_diameter = 0.1016;             % diameter of the propellor             (meters)                                 
aircraft_mass = 1.045;               % aircraft mass                         (kg)                                        
aircraft_diameter = 0.22;           % motor to motor distance               (meters)                                      

%==============================Actuator Mixer==============================

% [x(roll), y(pitch), z(yaw)]


MIX = [  1   1  -1   ;      % QUAD [X]
        -1   1   1   ;
        -1  -1  -1   ;
         1  -1   1   ;
         0   0   0   ;
         0   0   0   ;
         0   0   0   ;
         0   0   0   ];

% MIX = [  0   1  -1   ;      % QUAD [+]
%         -1   0   1   ;
%          0  -1  -1   ;
%          1   0   1   ;
%          0   0   0   ;
%          0   0   0   ;
%          0   0   0   ;
%          0   0   0   ];

% MIX = [  1   1  -1   ;      % HEX [X]
%         -1   1   1   ;
%         -1   0  -1   ;
%         -1  -1   1   ;
%          1  -1  -1   ;
%          1   0   1   ;
%          0   0   0   ;
%          0   0   0   ];

%==================================Forces================================== 

a = [   aircraft_diameter^2 / 10                        ;...                % body cross sectional area (X)
        aircraft_diameter^2 / 10                        ;...                % body cross sectional area (Y)
        sum(abs(MIX(:, 3))) * pi/4 * prop_diameter^2    ];                  % body cross sectional area (Z)
    
gravity = aircraft_mass .* (DCM * [0; 0; 9.81]);                            % gravitational force
drag = -velocity .* coefficient_drag .* density .* a;                       % drag force

%--------------------------------Thrust Model------------------------------
thrust = abs(MIX(:, 3)) .* (1*1E-3) .* rotors  ;                              % rotor thrust <==     
%--------------------------------------------------------------------------

forces = gravity + drag;
forces(3) = forces(3) - sum(thrust);

%==================================Moments=================================

mx = thrust .* MIX(:,1) .* (aircraft_diameter / 2)*sind(45);                % x moment
my = thrust .* MIX(:,2) .* (aircraft_diameter / 2)*sind(45);                % y moment

momentum_x = sum(abs(MIX(:, 3)) .* rotor_inertia .* rotors) * omega(1);     % x rotor momentum
momentum_y = sum(abs(MIX(:, 3)) .* rotor_inertia .* rotors) * omega(2);     % y rotor momentum
momentum_z = sum(MIX(:, 3) .* rotor_inertia .* rotors) * omega(3);          % z rotor momentum

%--------------------------------Torque Model------------------------------
mz = MIX(:,3) .* (1.7E-5) .* rotors;                                        % rotor torque <==
%--------------------------------------------------------------------------

moments = [sum(mx); sum(my); sum(mz)] - [momentum_x; momentum_y; momentum_z];
