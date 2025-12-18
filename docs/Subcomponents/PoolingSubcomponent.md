# Description
A Subcomponent that holds items efficiently minimizing the amount of memory allocated. Should be used when there are lots of objects being created and destroyed frequently (like bullets in a bullet hell game).
It offers basic methods to add, get, replace, remove and count items, but also more advanced functions to execute a function on all items or to change the capacity of the container.

---
# Dependencies
## Inheritance
- [Subcomponent](Subcomponent.md)
## Mandatory
- [ArraySwapAndPop](ArraySwapAndPop.md)
## Recommended
- [TimeComponent](TimeComponent.md)

---
# Methods/Functions

---
## Constructor
This function creates a struct of the PoolingSubcomponent class.
``` gml
new PoolingSubcomponent([capacity]);
```

| Argument     | Type | Description                                                                                                                                                         |
| ------------ | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| \[capacity\] | Real | The initial capacity of the container. Will be automatically expanded when necessary (e.g. when adding an item and the container has no free space). defaults to 0. |
Example:
``` gml
new PoolingSubcomponent(42);
```
The above code creates a PoolingSubcomponent with initial capacity of 42.

---
## Add Item
This function updates this container by adding the specified item and increasing both size and capacity by 1 only if there isn't free space. It returns the ID for the item after it is added, this can be used to access it later using the other methods.
``` gml
add_item(item);
```

| Argument         | Type | Description                         |
| ---------------- | ---- | ----------------------------------- |
| item             | Any  | The item to add                     |
Returns: `Real`

Example:
``` gml
var pool = new PoolingSubcomponent();
pool.add_item("My item (this one) is a String!");
```
The above code adds a string to the PoolingSubcomponent.

---
## Item Exists
This function if the specified item ID is corresponds to an item in the container, checking if the item specified by the ID exists.
``` gml
item_exists(item_id);
```

| Argument | Type | Description              |
| -------- | ---- | ------------------------ |
| item_id  | Real | The item ID to check for |
Returns: `Bool`

Example:
``` gml
randomize();
var pool = new PoolingSubcomponent();
var my_id = undefined;
if(irandom(1)==0){
	my_id = pool.add_item("My item");
}
if(pool.item_exists(my_id)){
	show_debug_message("My item exists");
}
```
The above code creates a PoolingSubcomponent, then initializes *my_id* as *undefined* and assigns a new item ID to *my_id* with a 50% chance. Then it checks if the component specified by *my_id* actually exists and prints text if it does.

---
## Count
This function returns the number of items stored inside the container.
``` gml
count();
```

Returns: `Real`

Example:
``` gml
var pool = new PoolingSubcomponent(10);
pool.add_item("First item");
pool.add_item("Second item");
pool.add_item("Third item");
show_debug_message($"The item count is {pool.count()}");
```
The above code creates a PoolingSubcomponent and adds 3 items. Then it prints the size.

Output:
```
The item count is 3
```
---
## Size
This function returns the total capacity of the container, which is the sum of item count and free space. This might be useful to know how much space is actually being used, and optionally *shrink* the container.
``` gml
size();
```

Returns: `Real`

Example:
``` gml
var pool = new PoolingSubcomponent(10);
pool.add_item("First item");
pool.add_item("Second item");
pool.add_item("Third item");
show_debug_message($"Filled: {pool.count()}/{pool.size()}");
```
The above code creates a PoolingSubcomponent and adds 3 items. Then it prints the size.

Output:
```
Filled: 3/10
```
---
## Get Item
This function returns the item with the specified ID. If the ID doesn't exist, it will return *undefined*.
``` gml
get_item(item_id);
```

| Argument | Type | Description                   |
| -------- | ---- | ----------------------------- |
| item_id  | Real | The ID of the item to return. |
Returns: `Any`

Example:
``` gml
randomize();
var pool = new PoolingSubcomponent();
var my_id = undefined;
if(irandom(1)==0){
	my_id = pool.add_item("My item");
}
if(pool.item_exists(my_id)){
	show_debug_message($"This is my item: '{pool.get_item(my_id)}'");
}
```
The above code creates a PoolingSubcomponent, then initializes *my_id* as *undefined* and assigns a new item ID to *my_id* with a 50% chance. Then it checks if the component specified by *my_id* actually exists and prints the item if its ID exists.

---
## Replace Item
This function the item corresponding to the specified ID with a different item. Returns the old item after replacing it.
``` gml
replace_item(item_id, new_item);
```

| Argument | Type | Description                                                                                                    |
| -------- | ---- | -------------------------------------------------------------------------------------------------------------- |
| item_id  | Real | The ID of the item to replace. Using an invalid ID will return undefined                                       |
| new_item | Any  | The item to replace the old one with. This new item will be accessible using the same ID as the previous item. |
Returns: `Any`

Example:
``` gml
var pool = new PoolingSubcomponent();
var id1 = pool.add_item("X");
var id2 = pool.add_item("Y");
var id3 = pool.add_item("Z");
pool.replace_item(id3, {letter:"Z", rating:"awesome!!"});
```
The above code adds 3 items (the letters X,Y,Z) to *pool*. Then it replaces "Z" with a struct containing letter and rating.

---
## Remove item
This function updates this container by removing the specified item without changing, leaving 1 free space (this changes the item count but not the capacity). It returns the item just removed. If the specified ID doesn't exist, this function will fail, returning *undefined*.
``` gml
remove_item(item_id);
```

| Argument | Type | Description                  |
| -------- | ---- | ---------------------------- |
| item_id  | Real | The ID of the item to remove |
Returns: `Any`

Example:
``` gml
var pool = new PoolingSubcomponent();
pool.add_item("My item (this one) is a String!");
```
The above code adds a string to the PoolingSubcomponent.

---
## Foreach
This function executes the given function on all the items stored.
``` gml
foreach(callback);
```

> Note: the callback function will be executed on every item that exists at the time of this function's call, even if they are deleted mid-execution by the callback function.

| Argument | Type     | Description                                                |
| -------- | -------- | ---------------------------------------------------------- |
| callback | Function | The function to execute. Takes 2 arguments (item, item_id) |
Returns: `N/A`

Example:
``` gml
var langs = new PoolingSubcomponent();
global.phrase = "Examples of programming languages:";
langs.add_item("C++");
langs.add_item("Python");
langs.add_item("GML");
langs.foreach(function(item, item_id){
	global.phrase += "\n"+item;
});
show_debug_message(global.phrase);
```
The above code adds names of programming languages to a PoolingSubcomponent, then it executes a function to add all of their names to a global string, then it prints that string.

Output:
```
Examples of programming languages:
C++
Python
GML
```
---
## Shrink
This function automatically resizes the container as much as possible without changing any ID or item. It shouldn't be used every frame as it can consume a lot of resources. It should only be used after removing a large amount of items, to reduce the capacity. It returns the new capacity of the container
``` gml
shrink();
```

> Note: as shown in the example, this function doesn't necessarily remove all free space, only what is possible by not changing IDs and items.

Returns: `N/A`

Example:
``` gml
var langs = new PoolingSubcomponent();
global.phrase = "Examples of programming languages:";
var id1 = langs.add_item("C++");
var id2 = langs.add_item("Python");
var id3 = langs.add_item("GML");

langs.remove_item(id1);
langs.remove_item(id3);

var old_size = langs.size();
show_debug_message($"Size: {old_size} -> {langs.shrink()}");
```
The above code adds 3 items and removes the first and the last item. Then it shrinks the container, printing a comparison between the size before and after the shrinking. Notice how 2 items were removed but the capacity was only decreased by 1.

Output/Possible output:
```
Size: 3 -> 2
```
---
## Reset
This function resets the container to its original state, removing all items.
``` gml
reset([capacity]);
```

> Note: using this function is similar to creating a new PoolingSubcomponent using the constructor, with the exception that the constructor would allocate new memory and use a different memory address for the new PoolingSubcomponent.

| Argument     | Type | Description                                                                                                                                                 |
| ------------ | ---- | ----------------------------------------------------------------------------------------------------------------------------------------------------------- |
| \[capacity\] | Real | The capacity of the container. Will be automatically expanded when necessary (e.g. when adding an item and the container has no free space). defaults to 0. |
Returns: `N/A`

Example:
``` gml
var langs = new PoolingSubcomponent();
global.phrase = "Examples of programming languages:";
var id1 = langs.add_item("C++");
var id2 = langs.add_item("Python");
var id3 = langs.add_item("GML");

langs.remove_item(id1);
langs.remove_item(id3);

var old_size = langs.size();
var shrink_size = langs.shrink();
show_debug_message($"Size with shrink(): {old_size} -> {shrink_size}");
langs.reset();
var reset_size = langs.size();
show_debug_message($"Size with reset():  {old_size} -> {reset_size}");
```
The above code adds 3 items and removes the first and the last item. Then it shrinks the container, printing a comparison between the size before and after the shrinking. Notice how 2 items were removed but the capacity was only decreased by 1.

Output/Possible output:
```
Size with shrink(): 3 -> 2
Size with reset():  3 -> 0
```

---
# Fields (PRIVATE)

---
## Items
This variable holds an array of items. It is updated when adding/removing items.
``` gml
items;
```

Returns: `Array<Any>`

---
## Free Indexes
This variable holds an array of empty slots inside the *items* array.
``` gml
free_indexes;
```

Returns: `Array<Real>`

---
## Full Indexes
This variable holds an array of item IDs. It is complementary to *free_indexes*.
``` gml
full_indexes;
```

Returns: `Array<Real>`

---
## Index Map
This variable holds a struct (map-like), working as an inverse *full_indexes*.
``` gml
index_map;
```

Returns: `Struct`
`(struct [$ item_id] -> index to access that ID from full_indexes`