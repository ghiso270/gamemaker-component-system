/// @desc subcomponent that works as a keyboard input interface. Subclasses can be created to draw from other input sources, such as mice, gamepads and virtual keys
/// @arg {Constant.VirtualKey,Real,String}	key				keyboard trigger (vk, ord or string). set to undefined to disable input
/// @arg {Struct.TimeComponent}				time_manager	a working TimeComponent to rely on for accurate time elaboration. if left undefined (default) inputs won't be buffered
/// @arg {Real}								buffering_time	determines the amount of time (in milliseconds) an input will be buffered for. Defaults to 0 (no buffering)

function InputSubcomponent(key, time_manager = undefined, buffering_time = 0) : Subcomponent() constructor {
	add_class("::InputSubcomponent");
	
	/// @desc performs different checks based on the 'type' given
	/// @arg {Constant.InputMethods}	type	ID of the method to use (either CHECK, PRESSED or RELEASED)
	/// @arg {Bool}						buffer	If set to true (and the checked input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with the specified type will be deleted. Defaults to false
	/// @returns {Bool}
	static evaluate = function(type, buffer = false){
		
		// convert all input functions to methods only once to improve performance
		static input_functions = [
			method(undefined, keyboard_check),
			method(undefined, keyboard_check_pressed),
			method(undefined, keyboard_check_released)
		];
		
		// choose the input evalutation function base on the 'type' given
		var input = input_functions[type];
		
		// check for input
		var check = (!is_undefined(__.key) && (input(__.key)));
		
		// if time elaboration is disabled ignore buffers
		if(is_undefined(__.time_manager))
			return check;
			
		// delete buffer if the argument is false
		if(!buffer){
			__.time_manager.remove_timer(__.timers[type]);
			__.timers[type] = undefined;
			__.buffers[type] = false;
			return check;
		}
		
		// set input buffer and start timer
		if(check){
			// if there's no buffer create it
			if(!__.buffers[type]){
				__.buffers[type] = true;
			
				// add type as private variable because callback functions can't use local functions declared outside
				__.timers[type] = __.time_manager.add_timer(__.buffer_time, function(data){__.buffers[data.type] = false});
				__.time_manager.get_timer_data(__.timers[type]).type = type;
			}
			// if a buffer already exists for this type, restart it
			else __.time_manager.change_timer(__.timers[type], __.buffer_time);
			
			// the check is already true, so no need for further checks
			return true;
		}
		
		return check || __.buffers[type];
	}
	
	/// @desc checks if the key is being held down
	/// @arg {Bool}	buffer	If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static check = function(buffer = false){
		return evaluate(InputMethods.CHECK, buffer);
	}
	
	/// @desc checks if the key has just been pressed
	/// @arg {Bool}	buffer	If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static pressed = function(buffer = false){
		return evaluate(InputMethods.PRESSED, buffer);
	}
	
	/// @desc checks if the key has just been released
	/// @arg {Bool}	buffer	If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static released = function(buffer = false){
		return evaluate(InputMethods.RELEASED, buffer);
	}
	
	// private
	with(__){
		
		// format the variable correctly if it isn't already
		self.key	= is_string(key) ? ord(string_upper(key)) : key;
	
		// contains [check, pressed, released] buffered inputs and timer IDs
		self.buffers = [false, false, false];
		self.timers = [undefined, undefined, undefined];
		
		self.buffer_time = buffering_time;
		self.time_manager = time_manager;
	}
}
