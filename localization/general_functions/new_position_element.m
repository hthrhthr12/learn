function new_position=new_position_element(last_position,distance)
new_position=last_position;
new_position(2)=last_position(2)-distance*last_position(4);
end