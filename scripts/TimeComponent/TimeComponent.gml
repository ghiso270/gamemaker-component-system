/// @desc a Component that handles timers, chronometers, current time and delta-time
/// @arg {String}			name				name of the component
/// @arg {Array<String>}	tags				tags of the component ("*" is reserved, so it must not be included)
/// @arg {Array<Real>}		event				single event (including priority) in which the component has to be executed. defaults to [ev_step, ev_step_normal, 1]

function TimeComponent(name, tags, event = [ev_step, ev_step_normal, 1]) : Component(name, array_push_and_return(tags, "::TimeComponent"), [event]) constructor{
	
	/// @desc updates delta time and makes time pass for all timers and chronometers
	/// @arg {Constant.EventType}	ev_type		type of the event in execution
	/// @arg {Constant.EventNumber} ev_num		number of the event in execution
	static execute = function(ev_type = event_type, ev_num = event_number){
		
		// update delta time
		__.dt = delta_time * __.game_speed / 1000;
		
		// run timers
		__.timers.foreach(function(timer,t_id){
			timer.time -= __.dt;
			if(timer.time <= 0){
				
				// execute its function
				if(!is_undefined(timer.callback))
					timer.callback();
					
				// destroy the item or disable its callback to prevent it being executed every next frame
				if(timer.destroy)
					__.timers.remove_item(t_id);
				else timer.callback = undefined;
			}
		});
		
		// run chronometers
		__.chronometers.foreach(function(chronometer,c_id){
			chronometer.time += __.dt;
		});
	}
	/// @desc returns delta time in milliseconds, applying the game speed multiplier
	static get_delta_time = function(){
		return __.dt;
	}
	
	/// @desc sets the current game speed multiplier. 1 is the default value
	static change_game_speed = function(new_speed = 1){
		__.game_speed = new_speed;
	}
	
	/// @desc returns the current time as a struct containing year, month, day, hour, minute, second, weekday and game_time (ms since game start)
	/// @arg {Bool}	month_name		if set to true, month number will be converted to its name (January, February...) otherwise (default) it will be left as a number from 1 (January) to 12 (February)
	/// @arg {Bool}	weekday_name	if set to true, weekday number will be converted to its name (Monday, Tuesday...) otherwise (default) it will be left as a number from 0 (Sunday) to 6 (Saturday)
	static get_current_time = function(month_name = false, weekday_name = false){
		
		// set lookup arrays once
		static month_names = ["January","February","March","April","May","June","July","August","September","October","November","December"];
		static wday_names = ["Sunday","Monday","Tuesday","Wednesday","Thursday","Friday","Saturday"];
		
		// convert to strings if requested (month index has [mm-1] because mm starts from 1)
		var mm = current_month, wd = current_weekday;
		if(month_name)	 mm = month_names[mm-1];
		if(weekday_name) wd = wday_names[wd];
		
		return {
			year:		current_year,
			month:		mm,
			day:		current_day,
			hour:		current_hour,
			minute:		current_minute,
			second:		current_second,
			weekday:	wd,
			game_time:	current_time,
		}
	}
	
	#region timers
	
	/// @desc adds a timer, returning an ID to access it later
	/// @arg {Real}		ms			how much time to set this timer for (in milliseconds)
	/// @arg {Function}	callback	function to execute when the timer ends
	/// @arg {Bool}		destroy		if set to true (default) the timer will be removed immediately after it ends
	/// @returns {Real}
	static add_timer = function(ms, callback = undefined, destroy = true){
		var timer = {};
		
		// only set the function if correctly set as a method, otherwise leave it undefined
		timer.callback = is_method(callback) ? callback : undefined;
		
		timer.time = ms;
		timer.destroy = destroy;
		
		return __.timers.add_item(timer);
	}
	
	/// @desc changes the time set for the specified timer
	/// @arg {Real}	timer_id		ID of the timer to change
	/// @arg {Real}	ms				how much time to set this timer for (in milliseconds)
	static change_timer = function(timer_id, ms){
		__.timers.get_item(timer_id).time = ms;
	}
	
	/// @desc returns the time left for the specified timer (in milliseconds)
	/// @arg {Real}	timer_id		ID of the timer to check
	/// @returns {Real}
	static check_timer = function(timer_id){
		return __.timers.get_item(timer_id).time;
	}
	
	/// @desc removes the specified timer even if it hasn't finished, returning it
	/// @arg {Real}	timer_id		ID of the timer to remove
	/// @returns {Real}
	static remove_timer = function(timer_id){
		return __.timers.remove_item(timer_id);
	}
	
	#endregion
	
	#region chronometers
	
	/// @desc adds a chronometer, returning an ID to access it later
	/// @returns {Real}
	static add_chronometer = function(){
		return __.chronometers.add_item({time: 0})
	}
	
	/// @desc returns the amount of time the specified chronometer has been running for (in milliseconds)
	/// @arg {Real}	chronometer_id		ID of the chronometer to check
	/// @returns {Real}
	static check_chronometer = function(chronometer_id){
		return __.chronometers.get_item(chronometer_id).time;
	}
	
	/// @desc removes the specified chronometer, returning it
	/// @arg {Real}	chronometer_id		ID of the chronometer to remove
	/// @returns {Real}
	static remove_chronometer = function(chronometer_id){
		return __.chronometers.remove_item(chronometer_id);
	}
	
	#endregion
	
	// private data
	with(__){
		
		self.dt = delta_time * __.game_speed / 1000;
		
		// speed multiplier (makes the timers go faster/slower)
		self.game_speed = 1;
		
		// holds a list of indexes in the array of timers that don't contain a timer, to minimize the allocation of new memory
		self.timers = new PoolingSubcomponent();
		self.chronometers = new PoolingSubcomponent();
	}
}