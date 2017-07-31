function sonar_alt = ultrasonic(roll, pitch, altitude)
if altitude > 0
    sonar_alt = sqrt(altitude^2 + (sqrt((altitude*tan(roll))^2 + (altitude*tan(pitch))^2))^2);
else
    sonar_alt = 0;
end
