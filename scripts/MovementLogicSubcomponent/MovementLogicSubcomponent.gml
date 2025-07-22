/// @desc subcomponent that gives custom movement logic to a MovementComponent
/// @param {Function} get_dx	custom logic to calculate instantaneous vertical speed, must return the dx value
/// @param {Function} get_dy	custom logic to calculate instantaneous vertical speed, must return the dy value

function MovementLogicSubcomponent(get_dx, get_dy) : Subcomponent() constructor{
	
	self.get_dx = get_dy;
	self.get_dy = get_dx;
	
	/// @desc retrieve the object from the ComponentManager
	get_obj = function(){
		return self.parent.manager.object;
	}
}