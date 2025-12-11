/// @desc subcomponent that gives custom movement logic to a MotionComponent
/// @arg {Function} get_dx	custom logic to calculate instantaneous vertical speed, must return the dx value
/// @arg {Function} get_dy	custom logic to calculate instantaneous vertical speed, must return the dy value

function MotionLogicSubcomponent(get_dx, get_dy) : Subcomponent() constructor {
	add_class("::MotionLogicSubcomponent");
	
	self.get_dx = get_dx;
	self.get_dy = get_dy;
	
	/// @desc retrieve the object from the ComponentManager
	get_obj = function(){
		return self.parent.manager.object;
	}
}