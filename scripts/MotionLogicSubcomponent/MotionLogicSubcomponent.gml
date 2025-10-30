/// @desc subcomponent that gives custom movement logic to a MotionComponent
/// @param {Function} get_dx	custom logic to calculate instantaneous vertical speed, must return the dx value
/// @param {Function} get_dy	custom logic to calculate instantaneous vertical speed, must return the dy value

function MotionLogicSubcomponent(get_dx, get_dy) : Subcomponent() constructor {
	add_class("::MotionLogicSubcomponent");
	
	self.get_dx = get_dx;
	self.get_dy = get_dy;
	
	/// @desc retrieve the object from the ComponentManager
	get_obj = function(){
		return self.parent.manager.object;
	}
}