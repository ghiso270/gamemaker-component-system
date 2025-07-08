/// @desc subcomponent that gives input to a MovementComponent
/// @param {Constant.VirtualKey,Real,String} up		input trigger (vk, ord or string) to go up. set to undefined to disable
/// @param {Constant.VirtualKey,Real,String} left	input trigger (vk, ord or string) to go left. set to undefined to disable
/// @param {Constant.VirtualKey,Real,String} down	input trigger (vk, ord or string) to go down. set to undefined to disable
/// @param {Constant.VirtualKey,Real,String} right	input trigger (vk, ord or string) to go right. set to undefined to disable

function MovementInputSubcomponent(up, left, down, right) : Subcomponent() constructor{
	
	// format the variable correctly if it isn't already
	self.up		= is_string(up)	   ? ord(up)    : up;
	self.down	= is_string(down)  ? ord(down)  : down;
	self.left	= is_string(left)  ? ord(left)  : left;
	self.right	= is_string(right) ? ord(right) : right;
	
	// check for keys held down
	check_up = function(){return (up!=undefined && keyboard_check(up))}
	check_down = function(){return (down!=undefined && keyboard_check(down))}
	check_left = function(){return (left!=undefined && keyboard_check(left))}
	check_right = function(){return (right!=undefined && keyboard_check(right))}
	
	// check for keys pressed
	press_up = function(){return (up!=undefined && keyboard_check_pressed(up))}
	press_down = function(){return (down!=undefined && keyboard_check_pressed(down))}
	press_left = function(){return (left!=undefined && keyboard_check_pressed(left))}
	press_right = function(){return (right!=undefined && keyboard_check_pressed(right))}
	
	// check for keys held down
	release_up = function(){return (up!=undefined && keyboard_check_released(up))}
	release_down = function(){return (down!=undefined && keyboard_check_released(down))}
	release_left = function(){return (left!=undefined && keyboard_check_released(left))}
	release_right = function(){return (right!=undefined && keyboard_check_released(right))}
	
	/// @desc get horizontal direction
	get_hdir = function(){
		return check_right() - check_left();
	}
	/// @desc get vertical direction
	get_vdir = function(){
		return check_down() - check_up();
	}
}