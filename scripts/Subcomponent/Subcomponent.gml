/// @desc Constructor for an abstract subcomponent class, which provides additional functions usable by a component. Subclasses should be used instead

function Subcomponent() constructor{
	
	// custom methods should be added in subclasses
	
	#region utility methods
	
	/// @arg {Struct.Component} parent	component that will have access to this subcomponent
	set_parent = function(parent){
		self.parent = parent;
	}
	
	get_parent = function(){
		return self.parent;
	}
	
	#endregion
}