function new_position=new_position_element(last_position)
new_position=last_position;
new_position(2)=last_position(2)-1.5*last_position(4);
new_position=new_position(2);
end