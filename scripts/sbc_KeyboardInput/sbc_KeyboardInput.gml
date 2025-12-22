/// @desc subcomponent that works as a keyboard input interface
/// @arg {Constant.VirtualKey,Real,String}	key				keyboard trigger (vk, ord or string). set to undefined to disable input
/// @arg {Struct.cmp_Time}					time_manager	a working cmp_Time to rely on for accurate time elaboration. if left undefined (default) inputs won't be buffered
/// @arg {Real}								buffering_time	determines the amount of time (in milliseconds) inputs will be buffered for. Defaults to 0 (no buffering)

function sbc_KeyboardInput(key, time_manager = undefined, buffering_time = 0) : sbc_Input(time_manager, buffering_time) constructor {
	add_class("::sbc_KeyboardInput");
	
	/// @desc checks if the key is held down. Ignores any buffers
	/// @returns {Bool}
	static raw_check = function(){
		return keyboard_check(__.key);
	}
	
	/// @desc checks if the key has just been pressed. Ignores any buffers
	/// @returns {Bool}
	static raw_pressed = function(){
		return keyboard_check_pressed(__.key);
	}
	
	/// @desc checks if the key has just been released. Ignores any buffers
	/// @returns {Bool}
	static raw_released = function(){
		return keyboard_check_released(__.key);
	}
	
	// private
	with(__){
		
		// format the variable correctly if it isn't already
		self.key	= is_string(key) ? ord(string_upper(key)) : key;
	}
}
