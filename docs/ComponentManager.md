# Description:
A class that holds and manages all the [Component](Component.md)s of an Object asset in GameMaker.
The [execute()](#execute) method should be called in every event in which Components are expected to execute.
Utility methods are also provided, to easily add, manage and remove Components.
Finally, the [destroy()](#destroy) method must be used once the ComponentManager isn't necessary anymore, this will allow all of the Components to correctly terminate and ensure 100% functionality.

---
# Dependencies:
## Mandatory
- GameMaker Object
- [ArraySwapAndPop](ArraySwapAndPop.md)
## Recommended
- [Component](Component.md)

---
# Methods:

---
## Constructor
This function creates a struct of the ComponentManager class.
``` gml
new ComponentManager(obj, [components]);
```

| Argument       | Type                    | Description                                                                                    |
| -------------- | ----------------------- | ---------------------------------------------------------------------------------------------- |
| obj            | Id.Instance             | The GameMaker Object asset containing this ComponentManager                                    |
| \[components\] | Array<Struct.Component> | The array of initial components to manage (can be added later). defaults to \[ ] (empty array) |

Example:
``` gml
// Create Event in obj_player:

manager = new ComponentManager(self, [new DummyComponent("dummy")]);
```
The above code creates a ComponentManager and assigns it to a variable of *obj_player*, specifying the executing object (self = *obj_player*) and the initial components.
In this case, it's a single DummyComponent named "dummy".

---
## Execute
This function runs the *execute()* method of all the appropriate Components for the specified event (or the current one), sorted by descending priority (order of attachment is used to sort Components with equal priority).
This method should be called in all the events of an Object asset for all the Components to work properly. Also, this method will skip if the ComponentManager was stopped with *pause()*.
``` gml
execute([ev_type], [ev_num]);
```

> Note: Async Events are currently not supported.

| Argument    | Type                 | Description                                                                          |
| ----------- | -------------------- | ------------------------------------------------------------------------------------ |
| \[ev_type\] | Constant.EventType   | The type of event to perform. Defaults to the event_type built-in constant           |
| \[ev_num\]  | Constant.EventNumber | The constant for the of event to perform. Defaults to event_number built-in constant |

Returns: `N/A`

Example:
``` gml
// Step Event in obj_player:

manager = new ComponentManager(self);
manager.execute();
```
The above code runs the *execute()* method in the Step Event of obj_player.

---
## Has Component
This function checks if a Component exists and returns true if it does, returning false otherwise.
``` gml
has_component(name);
```

| Argument | Type   | Description                        |
| -------- | ------ | ---------------------------------- |
| name     | String | The name of the Component to check |
Returns: `Bool`

Example:
``` gml
check = manager.has_component("dummy");
if(check){
	show_debug_message("the component 'dummy' exists!");
}else{
	show_debug_message("the component 'dummy' doesn't exist!");
}
```
The above code checks if a Component named "dummy" exists inside *manager* and prints text accordingly

---
## Get Component
This function returns the Component with the specified name. It's best to check with *has_component()* beforehand to avoid null pointer errors.
``` gml
get_component(name);
```

| Argument | Type   | Description                      |
| -------- | ------ | -------------------------------- |
| name     | String | The name of the Component to get |
Returns: `Struct.Component`

Example:
``` gml
check = manager.has_component("dummy");
if(check){
	show_debug_message(string(manager.get_component("dummy")));
}else{
	show_debug_message("the component 'dummy' doesn't exist!");
}
```
The above code checks if a Component named "dummy" exists inside *manager*.
If so, it prints the Component, showing an error message otherwise.

---
## Add Component
This function sets the specified Component to be managed by the ComponentManager.
If a Component with the same name already exist, a warning message will be printed and the method will return without adding the new Component.
``` gml
add_component(component);
```

| Argument  | Type             | Description          |
| --------- | ---------------- | -------------------- |
| component | Struct.Component | The Component to add |
Returns: `N/A`

Example:
``` gml
check = manager.has_component("dummy");
if(check){
	show_debug_message(string(manager.get_component("dummy")));
}else{
	manager.add_component(new DummyComponent("dummy"));
}
```
The above code checks if a Component named "dummy" exists inside *manager*.
If so, it prints the Component. Otherwise it creates one and adds it.

---
## Remove Component
This function removes the specified Component from the ComponentManager. If the Component isn't found it will just print a warning message.
``` gml
remove_component(name, [to_destroy])
```

| Argument       | Type   | Description                                                         |
| -------------- | ------ | ------------------------------------------------------------------- |
| name           | String | The name of the Component to remove                                 |
| \[to_destroy\] | Bool   | If true (default), the destroy method of the component will execute |
Returns: `N/A`

Example:
``` gml
check = manager.has_component("dummy");
if(check){
	manager.remove_component("dummy");
}
```
The above code removes from *manager* a Component called "dummy" only if it exists.

---
## Tag Count
This function returns the number of Components that share the specified tag (-1 if the tag doesn't exist).
``` gml
tag_count(tag);
```

> Note: the wildcard tag "\*" is used to count all the components regardless of tags.

| Argument | Type   | Description           |
| -------- | ------ | --------------------- |
| tag      | String | The tag to search for |
Returns: `Real`

Example:
``` gml
comp_num = manager.tag_count("important");
if(comp_num > 0){
	show_debug_message($"there are {comp_num} important components");
}else{
	show_debug_message("there are no important components");
}
```
The above code counts the number of Components tagged "important" and prints text accordingly.

---
## Tag Exists
This function is a wrapper for tag_count(tag) > 0, returning true if the specified tag exists AND has at least one Component, returning false otherwise.
``` gml
tag_exists(tag);
```

> Note: the wildcard tag "\*" is used to check if the total number of components is greater than 0.

| Argument | Type   | Description           |
| -------- | ------ | --------------------- |
| tag      | String | The tag to search for |
Returns: `Bool`

Example:
``` gml
if(manager.tag_exists("important")){
	show_debug_message("there are important components");
}else{
	show_debug_message("there are no important components");
}
```
The above code checks the tag "important" and prints text accordingly.

---
## Tag Get Components
This function returns an array containing all the Components that share the specified tag, cloning it by default to make it safe to write.
``` gml
tag_get_components(tag, [safe]);
```

> Note: the wildcard tag "\*" is used to get an array containing all Components.

| Argument | Type   | Description                                                                                  |
| -------- | ------ | -------------------------------------------------------------------------------------------- |
| tag      | String | The tag to search for                                                                        |
| \[safe\] | Bool   | Whether or not to clone the array (only use false for read-only purposes). defaults to true. |
Returns: `Array<Component>`

Example:
``` gml
var arr = manager.tag_get_components("score-manager");
var highscore = arr[0].score;
for(var i=1; i < array_length(arr); i++){
	if(arr[i].score > highscore){
		highscore = arr[i].score;
	}
}
```
The above code loops through all the Components tagged "score-manager" to find the highest score.

---
## Tag Remove Components
This function removes all the Components with the specified tag, destroying the Components by default.
``` gml
tag_remove_components(tag, [to_destroy], [remove_tag]);
```

> Note: the wildcard tag "\*" is used to remove all Components.

| Argument       | Type   | Description                                                                                              |
| -------------- | ------ | -------------------------------------------------------------------------------------------------------- |
| tag            | String | The tag to search for                                                                                    |
| \[to_destroy\] | Bool   | If true (default), the *destroy()* method of the component will execute                                  |
| \[remove_tag\] | Bool   | If set to true, the tag itself will be removed from the manager's internal structure. defaults to false. |
Returns: `N/A`

Example:
``` gml
manager.tag_remove_components("temporary", true, true);
```
The above code removes and destroys all the Components tagged "temporary", while also removing the tag.

---
## Tag Foreach
This function executes a function on all the Components that share the specified tag.
``` gml
tag_foreach(tag, func);
```

> Note: the wildcard tag "\*" is used to execute the function on all Components.

| Argument | Type     | Description                                                                             |
| -------- | -------- | --------------------------------------------------------------------------------------- |
| tag      | String   | The tag to search for                                                                   |
| func     | Function | The function called on each component. Takes 1 argument (component) and returns nothing |

Returns: `N/A`

Example:
``` gml
var reset_score = function(comp){
	comp.score = 0;
}
manager.tag_foreach("score-manager", reset_score);
```
The above code defines a *reset_score()* function, which is then executed on all Components tagged "score-manager".

---
## Pause
This function pauses this ComponentManager, preventing the *execute()* from executing.
``` gml
pause();
```

> Note: this is NOT the same as using the *deactivate()* method on all Components, as this method only stops the Manager's execution, not the Components'.

Returns: `N/A`

Example:
``` gml
if(global.game_pause){
	manager.pause();
}
```
The above code pauses the manager when the game is paused.

---
## Resume
This function resumes this ComponentManager, meaning the *execute()* method will run normally until paused again.
``` gml
resume();
```

> Note: this is NOT the same as using the *activate()* method on all Components, as this method only resumes the Manager's execution, not the Components'.

Returns: `N/A`

Example:
``` gml
if(!global.game_pause){
	manager.resume();
}
```
The above code resumes the manager when the game is not paused.

---
## Destroy
This function executes the [destroy()](Component.md#destroy-override) method for all the Components managed, then removes all references to free memory and ensure proper cleanup.
``` gml
destroy();
```

Returns: `N/A`

Example:
``` gml
// Game End Event

manager.destroy();
```
The above code resets *manager* when the game ends.

---
## List Components
This function returns a string containing a human-readable list of Components, useful for debugging. The result string is structured as N lines (where N is the number of Components), where each line is structured as "n - Component", n starting from 1.
You can configure which Components to show and how they are shown.
``` gml
list_components([active_only], [expand_criteria], [hide_substructs]);
```

| Argument            | Type     | Description                                                                                                                                                                            |
| ------------------- | -------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| \[active_only\]     | Bool     | If true, only active Components will be shown. Defaults to false                                                                                                                       |
| \[expand_criteria\] | Function | The function called on each component. Takes 1 argument (component) and returns a bool (true: show 1-line JSON, false: only show the name). The default function always returns false. |
| \[hide_substructs\] | Bool     | If true, structs inside components (like subcomponents) will be hidden (manager is always hidden). Defaults to false                                                                   |

Returns: `String`

Example:
``` gml
if(global.debug_mode){
	show_debug_message("list of components:\n" +
	manager.list_components(,function(component){return true;}));
}
```
The above code checks if debug mode is enabled and, if so, prints the full list of components, expanding everything but hiding substructs. The output might look like this:
```
list of components:
1 - {"manager":"...","is_active":true,"name":"dummy1","events":[],"tags":["a"]}
2 - {"manager":"...","is_active":true,"name":"dummy2","events":[],"tags":["b"]}
3 - {"manager":"...","is_active":true,"name":"dummy3","events":[],"tags":["c"]}
```

---
# Fields

---
## Object (Read-Only)
This variable stores a reference to the GameMaker Object instance specified in the constructor.
``` gml
object;
```

Returns: Id.Instance

> Note: It is highly recommended not to manually edit this field as it is designed for read-only use.

---
## Is Paused (Read-Only)
This variable stores the current pause state, it is used in the *execute()* method to choose whether or not to skip execution. It is updated by the *pause()* and *resume()* methods.
``` gml
is_paused;
```

Returns: `Bool`

> Note: It is highly recommended not to manually edit this field as it is designed for read-only use.

---
## Components (Private)
This variable stores all the Components managed by this ComponentManager as an array.
``` gml
components;
```

Returns: `Array<Struct.Component>`

> Note: It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Components by Name (Private)
This variable stores all the Components in a struct (map-like) that matches a name to a Component. 
``` gml
components_by_name;
```

Returns: `Struct`

> Note: It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Components by Tag (Private)
This variable stores all the Components in a struct (map-like) that matches a tag to an array of Components.
``` gml
components_by_tag;
```

Returns: `Struct`

> Note: It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Components by Event (Private)
This variable stores all the Components in a 3-dimensional array to make them easily accessible by event. Specify the event_type as the first index and the event_number as the second index, and you get an array of structs containing Components and their priority in the event.
The structs containing Component and Priority are sorted by descending priority, and use the order of attachment of the Components to sort structs with equal priority.
``` gml
components_by_event;
```

Returns: `Array<Struct<Array<Struct>>>`
`(array [event_type] -> struct [$ event_number] -> array of {component, priority})`

> Note: It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.