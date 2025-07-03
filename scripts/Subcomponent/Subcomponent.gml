/// @desc  Constructor for an abstract subcomponent class, which provides additional functions usable by a component. Subclasses should be used instead
/// @param {String} class descriptive name of the subclass, eg InputSubcomponent -> class="input"	

function Subcomponent(class) constructor{
	
	// custom methods should be added in subclasses
	
	#region initialize
	
	self.class = class;
	
	// assigned when attached to a component
	self.parent = undefined;
	self.id = undefined;
	
	#endregion
	
	#region utility methods
	
	/// @arg {Struct.Component} parent	component that will have access to this subcomponent
	/// @arg {Real}				id		identifier of this subcomponent
	attach = function(parent, id){
		self.parent = parent;
		self.id = id;
	}
	
	detach = function(){
		self.parent = undefined;
		self.id = undefined;
	}
	
	#endregion
}