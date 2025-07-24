man.execute();

if(keyboard_check_pressed(vk_control)){
	man.remove_component("move");
	man.add_component(new DummyComponent("move"));
}
if(keyboard_check_pressed(vk_alt)){
	man.remove_component("move");
	var input = new MovementInputSubcomponent("W", "A", "S", "D");
	man.add_component(new MovementComponent("move", 50, 25, input));
}
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