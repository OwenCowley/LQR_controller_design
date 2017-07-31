function [M1, M2, M3, M4, M5, M6, M7, M8] = motor_mixer(Roll, Pitch, Yaw, Thrust)

idle_PWM = 1000;

% Quad X
M1 = ((Roll + Pitch - Yaw) / 2 * Thrust + Thrust) * 1000 + idle_PWM;
M2 = ((-Roll + Pitch + Yaw) / 2 * Thrust + Thrust) * 1000 + idle_PWM;
M3 = ((-Roll - Pitch - Yaw) / 2 * Thrust + Thrust) * 1000 + idle_PWM;
M4 = ((Roll - Pitch + Yaw) / 2 * Thrust + Thrust) * 1000 + idle_PWM;
M5 = 1000;
M6 = 1000;
M7 = 1000;
M8 = 1000;
