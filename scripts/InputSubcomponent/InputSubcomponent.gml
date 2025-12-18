/// @desc an abstract component class. works as a generic input interface. Subclasses should be created to use actual input sources, such as keyboards, mice, gamepads and virtual keys
/// @arg {Struct.TimeComponent}				time_manager	a working TimeComponent to rely on for accurate time elaboration. if left undefined (default) inputs won't be buffered
/// @arg {Real}								buffering_time	determines the amount of time (in milliseconds) inputs will be buffered for. Defaults to 0 (no buffering)

function InputSubcomponent(time_manager = undefined, buffering_time = 0) : Subcomponent() constructor {
	add_class("::InputSubcomponent");
	
	/// @desc performs different checks based on the 'type' given
	/// @arg {Constant.InputMethods}	type	ID of the method to use (either CHECK, PRESSED or RELEASED)
	/// @arg {Bool}						buffer	If set to true (and the checked input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with the specified type will be deleted. Defaults to false
	/// @returns {Bool}
	static evaluate = function(type, buffer = false){
		
		// choose the input evalutation function base on the 'type' given
		var input = __.raw_input[type];
		
		// check for input
		var check = input();
		
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
	
	#region checks
	
	/// @desc this function works like raw_check, but it interacts with buffers
	/// @arg {Bool}	buffer	If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static check = function(buffer = false){
		return evaluate(InputMethods.CHECK, buffer);
	}
	
	/// @desc this function works like raw_pressed, but it interacts with buffers
	/// @arg {Bool}	buffer	If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static pressed = function(buffer = false){
		return evaluate(InputMethods.PRESSED, buffer);
	}
	
	/// @desc this function works like raw_released, but it interacts with buffers
	/// @arg {Bool}	buffer	If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false
	/// @returns {Bool}
	static released = function(buffer = false){
		return evaluate(InputMethods.RELEASED, buffer);
	}
	
	#endregion
	
	#region raw checks
	
	/// @desc checks if there's input. Ignores any buffers
	/// @returns {Bool}
	static raw_check = function(){
		return false;
	}
	
	/// @desc checks if the input has just started. Ignores any buffers
	/// @returns {Bool}
	static raw_pressed = function(){
		return false;
	}
	
	/// @desc checks if the input has just stopped. Ignores any buffers
	/// @returns {Bool}
	static raw_released = function(){
		return false;
	}
	
	#endregion
	
	// private
	with(__){
	
		// contains [check, pressed, released] buffered inputs and timer IDs
		self.buffers = [false, false, false];
		self.timers = [undefined, undefined, undefined];
		
		self.raw_input = [
			other.raw_check,
			other.raw_pressed,
			other.raw_released,
		]
		
		self.buffer_time = buffering_time;
		self.time_manager = time_manager;
	}
}
