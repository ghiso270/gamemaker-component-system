A support script that serves as an optimized version of *array_delete()* that doesn't keep the array ordered. The way it works is that it swaps the specified element with the last one and then reduces the size of the array by one, effectively deleting the specified element.
``` gml
array_swap_and_pop(arr, i)
```

> Note: this function does NOT keep the array sorted, so it should only be used on unsorted arrays.

| Argument | Type  | Description                                         |
| -------- | ----- | --------------------------------------------------- |
| arr      | Array | The array from which you want to remove the element |
| i        | Real  | The index of the element you want to remove         |

Returns: `N/A`

Example:
``` gml
var arr1 = [1, 2, 3, 4, 5];
var arr2 = [1, 2, 3, 4, 5];

array_swap_and_pop(arr1, 1);
array_delete(arr2, 1, 1);

show_debug_message("arr1: " + string(arr1));
show_debug_message("arr2: " + string(arr2));
```
The above code prints two arrays after deleting the 2nd element, one with *array_swap_and_pop()* and the other with *array_delete()* to show the difference.

Output:
```
arr1: [ 1,5,3,4 ]
arr2: [ 1,3,4,5 ]
```