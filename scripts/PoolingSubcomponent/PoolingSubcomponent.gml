/// @desc Subcoponent that offers a way to contain multiple items while minimizing the allocation of new memory. Should be used when dealing with items that are frequently added/removed

function PoolingSubcomponent() : Subcomponent() constructor {
	add_class("::PoolingSubcomponent");
	
	/// @desc adds the specified item to the internal structure, returning the ID to access it later
	/// @arg {Any}	item	item to add. Adding 'undefined' might cause unintended behavior
	/// @returns {Real}
	static add_item = function(item){
		
		// if there's no free space, simply add the item to the back, increasing the size by 1
		if(array_length(__.free_indexes) == 0){
			array_push(__.items, item);
			return array_length(__.items)-1;
		}
		
		// otherwise, put the item in the first available index
		var i = __.free_indexes[0];
		array_swap_and_pop(__.free_indexes, 0);
			
		__.items[i] = item;
		return i;
	}
	
	
	/// @desc checks if the specified item ID exists within the internal structure
	/// @arg {Real}	item_id		ID to check. If invalid the function will return false
	/// @returns {Bool}
	static item_exists = function(item_id){
		return (item_id >= 0 && item_id < array_length(__.items) && !is_undefined(__.items[item_id]));
	}
	
	/// @desc returns the specified item from the internal structure
	/// @arg {Real}	item_id		ID of the item to remove. If invalid the function will return undefined
	/// @returns {Any}
	static get_item = function(item_id){
		if(!item_exists(item_id))
			return undefined;
		return __.items[item_id];
	}
	
	/// @desc replaces an item from the internal structure with another one, returning the old item
	/// @arg {Real}	item_id		ID of the item to replace. Using an invalid ID will return undefined
	/// @arg {Any}	new_item	item to replace the old one with. Replacing with 'undefined' might cause unintended behavior
	/// @returns {Any}
	static replace_item = function(item_id, new_item){
		if(!item_exists(item_id))
			return undefined;
		var old_item = __.items[item_id]
		__.items[item_id] = new_item;
		
		return old_item;
	}
	
	/// @desc removes the specified item from the internal structure, returning it
	/// @arg {Real}	item_id		ID of the item to replace. Using an invalid ID will return undefined
	/// @returns {Any}
	static remove_item = function(item_id){
		if(!item_exists(item_id))
			return undefined;
		var item = __.items[item_id]
		__.items[item_id] = undefined;
		array_push(__.free_indexes, item_id);
		
		return item;
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