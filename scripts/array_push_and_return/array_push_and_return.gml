/// @desc the same as array_push, but it returns the array
/// @arg {Array} arr	the array to which the element will be added
/// @arg {Any} item		the index of the element that will be removed
function array_push_and_return(arr, item){
	array_push(arr, item);	
	return arr;
}