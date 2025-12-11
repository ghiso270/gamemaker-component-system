/// @desc Subcoponent that offers a way to contain multiple items while minimizing the allocation of new memory

function PoolingSubcomponent() : Subcomponent() constructor {
	add_class("::PoolingSubcomponent");
	
	/// @desc adds the specified item to the internal structure, returning the ID to access it later
	/// @arg {Any}	item	item to add
	/// @returns {Real}
	static add_item = function(item){
		
		// if there's free space
		if(array_length(__.free_indexes) > 0){
			
			// get the first available index and remove it from its array
			var i = __.free_indexes[0];
			array_swap_and_pop(__.free_indexes, 0);
			
			__.items[i] = item;
			return i;
		}
		
		// if there's no free space, double the
		array_push(__.items, item);
	}
	
	/// @desc resizes the item container as much as possible without moving nor deleting any item, returning the new size of the container
	/// @returns {Real}
	static shrink = function(){
		var current_size = array_length(__.items);
		var free_size = array_length(__.free_indexes);
		array_sort(__.free_indexes, true);
		
		// if the biggest free index isn't the last index, resizing isn't possible
		if(__.free_indexes[free_size-1] != current_size-1)
			return current_size;
		
		// loop from the last to the first free index
		for(var i = free_size-1; i > 0; --i) {
			var smaller_idx = __.free_indexes[i-1];
			var current_idx = __.free_indexes[i];
			
			// if there's at least 1 occupied space between 2 free ones, that's the shrink limit
			if(current_idx - smaller_idx > 1){
				
				// resize both the item array and the index array
				array_resize(__.items, current_idx);
				array_resize(__.free_indexes, i);
				
				return current_idx;
			}
		}
		
		// if the smallest free index is 0 (first index), both arrays can be emptied completely
		// if it is not 0, then that's the shrink limit
		// either way, the size of items[] will be the smallest free index, and the size of free_indexes[] will be 0
		var size = __.free_indexes[0];
		array_resize(__.items, __.free_indexes[0]);
		array_resize(__.free_indexes, 0);
				
		return size;
	}
	
	with(__){
		self.items = [];
		
		// holds a list of indexes to empty cells in the array of items
		// this way the subcomponent knows if there's free space or if it has to allocate new memory
		self.free_indexes = [];
	}
}