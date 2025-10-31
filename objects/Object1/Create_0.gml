man = new ComponentManager(self);
sm = new StateMachineComponent("sm", [], true);
man.add_component(sm);

global.sm = sm;

sm.add_state("up", {
	down: function(obj){with(obj){return keyboard_check(vk_down) || timer<70}}
}, function(a,b, obj){
	with(obj){
		timer--;
	}
}, function(obj){
	with(obj){
		timer = 100;
	}
}, function(obj){
	show_debug_message(global.sm.timer)
});

sm.add_state("down", {
	up: function(){return keyboard_check(vk_up)},
	left: function(){return keyboard_check(vk_left)},
	right: function(){return keyboard_check(vk_right)}
}, function(a,b){});

sm.add_state("left", {
	down: function(){return keyboard_check(vk_down)}
}, function(a,b){});

sm.add_state("right", {
	down: function(){return keyboard_check(vk_down)},
}, function(a,b){});

sm.start("down");