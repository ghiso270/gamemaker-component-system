man.execute();

if(keyboard_check_pressed(vk_space)){
	show_debug_message(json_stringify(man, false, function(k,v){
		if(is_struct(v) && struct_exists(v, "name")){
			return v.name;
		}else return v;
	}));
}

if(keyboard_check_pressed(ord("1")))
	m1.deactivate();
if(keyboard_check_pressed(ord("2")))
	m2.deactivate();
if(keyboard_check_pressed(ord("3")))
	m3.deactivate();


if(keyboard_check_pressed(ord("Z")))
	m1.activate();
if(keyboard_check_pressed(ord("X")))
	m2.activate();
if(keyboard_check_pressed(ord("C")))
	m3.activate();

