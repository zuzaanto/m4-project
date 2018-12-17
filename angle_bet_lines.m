function [ angle_deg ] = angle_bet_lines( l1,l2 )
l1_ang = atan(((-(l1(1)*1000 + l1(3)) / l1(2)) + ((l1(3)) / l1(2)))/(1000));
l2_ang = atan(((-(l2(1)*1000 + l2(3)) / l2(2)) +((l2(3)) / l2(2)))/(1000));
angle_deg = abs((l1_ang - l2_ang)* 180/pi);
end

