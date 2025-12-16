/// @desc Subcoponent that offers a way to contain multiple items while minimizing the allocation of new memory. Should be used when dealing with items that are frequently added/removed
/// @arg {Real}	capacity	initial capacity. will be automatically expanded if necessary. defaults to 0

function PoolingSubcomponent(capacity = 0) : Subcomponent() constructor {
	add_class("::PoolingSubcomponent");
	
	/// @desc adds the specified item to the internal structure, returning the ID to access it later
	/// @arg {Any}	item	item to add
	/// @returns {Real}
	static add_item = function(item){
		
		// if there's no free space, simply add the item to the back
		if(array_length(__.free_indexes) == 0){
			var len = array_length(__.items);
			array_push(__.items, item);
			
			// update full_indexes array
			array_push(__.full_indexes, len);
			__.index_map[$ len] = array_length(__.full_indexes)-1;
			
			return len;
		}
		
		// otherwise, put the item in the first available index
		var i = __.free_indexes[0];
		array_swap_and_pop(__.free_indexes, 0);
		
		// update full_indexes array
		array_push(__.full_indexes, i);
		__.index_map[$ i] = array_length(__.full_indexes)-1;
			
		__.items[i] = item;
		return i;
	}
	
	/// @desc checks if the specified item ID exists within the internal structure
	/// @arg {Real}	item_id		ID to check
	/// @returns {Bool}
	static item_exists = function(item_id){
		return struct_exists(__.index_map, item_id);
	}
	
	/// @desc returns the number of items stored
	/// @returns {Real}
	static count = function(){
	    return array_length(__.full_indexes);
	}
	
	/// @desc returns the capacity of this container, which counts both full and empty slots
	/// @returns {Real}
	static size = function(){
	    return array_length(__.items);
	}
	
	/// @desc returns the specified item from the internal structure
	/// @arg {Real}	item_id		ID of the item to return. Using an invalid ID will return undefined
	/// @returns {Any}
	static get_item = function(item_id){
		if(!item_exists(item_id))
			return undefined;
		return __.items[item_id];
	}
	
	/// @desc replaces an item from the internal structure with another one, returning the old item
	/// @arg {Real}	item_id		ID of the item to replace. Using an invalid ID will return undefined
	/// @arg {Any}	new_item	item to replace the old one with
	/// @returns {Any}
	static replace_item = function(item_id, new_item){
		if(!item_exists(item_id))
			return undefined;
		var old_item = __.items[item_id]
		__.items[item_id] = new_item;
		
		return old_item;
	}
	
	/// @desc removes the specified item from the internal structure, returning it
	/// @arg {Real}	item_id		ID of the item to remove. Using an invalid ID will return undefined
	/// @returns {Any}
	static remove_item = function(item_id){
		if(!item_exists(item_id))
			return undefined;
		var item = __.items[item_id]
		__.items[item_id] = undefined;
		
		// add free index
		array_push(__.free_indexes, item_id);
		
		// remove 'full' index
		var idx = __.index_map[$ item_id];
		array_swap_and_pop(__.full_indexes, idx);
		struct_remove(__.index_map, item_id)
		
		// update index_map entry, because an index has been swapped using array_swap_and_pop()
		if(idx < array_length(__.full_indexes)){
			var swapped_item_id = __.full_indexes[idx];
			__.index_map[$ swapped_item_id] = idx;
		}
		
		return item;
	}
		
	/// @desc executes the given function for all items stored
	/// @arg {Function}	callback	function to execute. Takes in input 2 arguments (item, id)
	static foreach = function(callback){
		var len = array_length(__.full_indexes);
		
		// use a copy for protection against item deletion mid-loop
		var ids = []; array_copy(ids, 0, __.full_indexes, 0, len);
		
		for (var i = 0; i < len; ++i) {
			var item_id = ids[i]
			callback(__.items[item_id], item_id)
		}
	}
		
	/// @desc resizes the item container as much as possible without moving nor deleting any item, returning the new size of the container
	/// @returns {Real}
	static shrink = function(){
		var current_size = array_length(__.items);
		var items_len = array_length(__.full_indexes);
		
		// find last item index
		var last_item_idx = -1;
		for (var i = 0; i < items_len; ++i) {
			if(__.full_indexes[i] > last_item_idx)
				last_item_idx = __.full_indexes[i];
		}
		var new_size = last_item_idx + 1;
		
		// no resizing
		if(new_size == current_size)
			return current_size;

		array_resize(__.items, new_size);
		
		// delete all free indexes in the deleted segment (all after the last item's index)
		var free_len = array_length(__.free_indexes);
		for (var i = 0; i < free_len; ++i) {
		    if(__.free_indexes[i] > last_item_idx){
				array_swap_and_pop(__.free_indexes, i);
				
				// recalculate size and try again the current position because the deleted item has been replaced
				--free_len;
				--i;
			}
		}
				
		return new_size;
	}
	
	/// @desc resets the Subcomponent to its original state, deleting all items
	/// @arg {Real}	capacity	initial capacity. will be automatically expanded if necessary
	static reset = function(capacity = 0){
		
		// private
		with(__){
			self.items = array_create(capacity);
		
			// holds a list of indexes to empty cells in the array of items
			// this way the subcomponent knows if there's free space or if it has to allocate new memory
			self.free_indexes = array_create_ext(capacity, function(i){return i});
		
			// complementary to free_indexes
			self.full_indexes = [];
		
			// lookup table that returns the location of the given ID in full_indexes (returns the index where the ID is located)
			// this makes item removal faster
			self.index_map = {}
		}
	}
	
	// create private data
	reset(capacity);
}
