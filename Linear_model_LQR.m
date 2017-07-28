% LQR-controller-design-
% Run script to store in workspace for non-linear model

Ixx= 0.0042;
Iyy= 0.0035;
Izz= 0.00606;

m= 1.045; %kg
rollrate  = 0 ;%-1.1277e-04    %% mean(roll_rate)
pitchrate = 0 ;%-1.1253e-04    %% mean(pitch_rate)
yawrate   = 0 ;% 0.0087        %% mean(yaw_rate)
altituderate = 0;
% rollrate  =  mean(roll_rate)
% pitchrate =  mean(pitch_rate)
% yawrate   =  mean(yaw_rate)
% altituderate = mean(Altitude_rate)

% rollrate  =     0.3027
% pitchrate =     0.3528
% yawrate   =     1.0713
% altituderate = -0.3673

% A=[ 0 0 0 1 0 0;
%     0 0 0 0 1 0;
%     0 0 0 0 0 1;
%     0 0 0 0 (yawrate*(Iyy-Izz))/(2*Ixx)    (pitchrate*(Iyy-Izz))/(2*Ixx);
%     0 0 0 (yawrate*(Izz-Ixx))/(2*Iyy) 0 (rollrate*(Izz-Ixx))/(2*Iyy);
%     0 0 0 (pitchrate*(Ixx-Iyy))/(2*Izz) (rollrate*(Ixx-Iyy))/(2*Izz) 0];

A=[ 0 0 0 1 0 0;
    0 0 0 0 1 0;
    0 0 0 0 0 1;
    0 0 0 0 0 0;
    0 0 0 0 0 0;
    0 0 0 0 0 0];
    
%     
%     0 0 0 0 (yawrate*(Iyy-Izz))/(2*Ixx)    (pitchrate*(Iyy-Izz))/(2*Ixx) 0;
%     0 0 0 (yawrate*(Izz-Ixx))/(2*Iyy) 0 (rollrate*(Izz-Ixx))/(2*Iyy) 0;
%     0 0 0 (pitchrate*(Ixx-Iyy))/(2*Izz) (rollrate*(Ixx-Iyy))/(2*Izz) 0 0;


B=[ 0 0 0;
    0 0 0;
    0 0 0;
    1/Ixx 0 0;
    0 1/Iyy 0;
    0 0 1/Izz];


% Co = ctrb(A,B);

% C=eye(6);
% % D=[ones(2,4); zeros(4,4); -ones(2,4)];
% 
% D=[zeros(6,3)];

% R=eye(4)
R=[2    0   0  ;
   0    2   0   ;
   0    0   0.005];

% R=eye(3)
Q=eye(6)

[K,S,e] = lqr(A,B,Q,R,[])

% sys=ss(A,B,C,D);
% % Cc=eye(4,6);
% Cl=(A-B*K); 
% % Cc=Cl(3:6,:);

Cc=[eye(3) zeros(3,3)] ;
% Cc=Cl(:,3:6); %collumns


Nbar= -inv(Cc*inv(A-B*K)*B);
G=Nbar;
