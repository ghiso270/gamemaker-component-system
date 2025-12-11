/// @desc subcomponent that works as a keyboard input interface. Subclasses can be created to draw from other input sources, such as mice, gamepads and virtual keys
/// @arg {Constant.VirtualKey,Real,String}	key				keyboard trigger (vk, ord or string). set to undefined to disable input
/// @arg {Struct.TimeComponent}				time_manager	TimeComponent to rely on for accurate time elaboration. Can belong to the same ComponentManager or be external. set to undefined to disable time elaboration
/// @arg {Real}								buffering_time	Determines the amount of time (in milliseconds) an input will be buffered for. Defaults to 0 (no buffering)

function InputSubcomponent(key, time_manager, buffering_time = 0) : Subcomponent() constructor {
	add_class("::InputSubcomponent");
	
	// format the variable correctly if it isn't already
	self.key	= is_string(key) ? ord(key) : key;
	
	// contains [check, pressed, released] buffered inputs
	self.buffers = [false, false, false]
	
	/// @desc performs different checks based on the 'type' given
	/// @arg {Constant.InputMethods}	type	ID of the method to use (either CHECK, PRESSED or RELEASED)
	/// @arg {Bool}						buffer	If set to true (and the checked input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static evaluate = function(type, buffer = false){
		
		// choose the input evalutation function base on the 'type' given
		var eval_function;
		switch(type){
			case InputMethods.CHECK:
				eval_function = keyboard_check;
				break;
			case InputMethods.PRESSED:
				eval_function = keyboard_check_pressed;
				break;
			case InputMethods.RELEASED:
				eval_function = keyboard_check_released;
				break;
			default:
				show_debug_message($"ERROR in InputSubcomponent.evaluate(): Type {type} unknown. Use values from the enum InputMethods")
		}
		
		// check for input
		var check = (!is_undefined(key) && (eval_function(key)));
		
		// delete buffer if the agument is false or if the timer has ended
		// TODO add timer check
		if(!buffer){
			buffers[type] = false;
			return check;
		}
		
		// set input buffer and start timer
		if(check){
			buffers[type] = true;
			// TODO start timer
		}
		
		return check || buffers[type];
	}
	
	/// @desc checks if the key is being held down
	/// @arg {Bool}	buffer	If set to true (and the checked input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static check = function(buffer = false){
		evaluate(InputMethods.CHECK, buffer);
	}
	
	/// @desc checks if the key has just been pressed
	/// @arg {Bool}	buffer	If set to true (and the checked input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static pressed = function(buffer = false){
		evaluate(InputMethods.PRESSED, buffer);
	}
	
	/// @desc checks if the key has just been released
	/// @arg {Bool}	buffer	If set to true (and the checked input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static released = function(buffer = false){
		evaluate(InputMethods.RELEASED, buffer);
	}
}

// TODO
// add TimerComponent & input buffering management
// add inertia