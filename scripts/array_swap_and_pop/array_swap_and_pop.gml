/// @desc a faster way to remove an element from an unsorted array, compared to array_delete
/// @arg {Array} arr	the array from which the element will be removed
/// @arg {Real} i		the index of the element that will be removed
function array_swap_and_pop(arr, i){
	var last_idx = array_length(arr) - 1;
	
	// partial swap
	// the other element doesn't need to be swapped because it'll be deleted
	if (i != last_idx)
	    arr[i] = arr[last_idx];
	
	// pop
	array_resize(arr, last_idx);
	
	return;
}