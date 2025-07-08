x = 0;
y = 0;

global.game_speed = 1;
global.game_pause = false;

man = new ComponentManager(self);

var input_src = new MovementInputSubcomponent("W","A","S","D");
var mov = new MovementComponent(100, 100, input_src);

man.add_component(mov)

show_debug_message(string(man));

man.execute();