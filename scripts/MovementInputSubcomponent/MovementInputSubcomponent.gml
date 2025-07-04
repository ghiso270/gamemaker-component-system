/// @desc subcomponent that gives input to a MovementComponent
/// @param {any} up		input trigger (vk, ord or string) to go up. set to undefined to disable
/// @param {any} down	input trigger (vk, ord or string) to go down. set to undefined to disable
/// @param {any} left	input trigger (vk, ord or string) to go left. set to undefined to disable
/// @param {any} right	input trigger (vk, ord or string) to go right. set to undefined to disable

function MovementInputSubcomponent(up, down, left, right) : Subcomponent("move-input") constructor{
	
	// format the variable correctly if it isn't already
	self.up		= is_string(up)	   ? ord(up)    : up;
	self.down	= is_string(down)  ? ord(down)  : down;
	self.left	= is_string(left)  ? ord(left)  : left;
	self.right	= is_string(right) ? ord(right) : right;
	
	static check_up = function(){
		return (up!=undefined && keyboard_check(up));
	}
	static check_down = function(){
		return (down!=undefined && keyboard_check(down));
	}
	static check_left = function(){
		return (left!=undefined && keyboard_check(left));
	}
	static check_right = function(){
		return (right!=undefined && keyboard_check(right));
	}
}