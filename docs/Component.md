# Description:
An abstract class that serves as a template for subclasses of Components.
The [execute()](#execute-override) method is for the main behavior that gets executed during each of the specified events. Other methods are used to [activate](#activate)/[deactivate](#deactivate) the Component.
Supplementary methods or Subcomponents can be added to include more functionalities.

> Note: This class only exists for inheritance. It should only be used to create custom Components.

---
# Dependencies:
## Mandatory
- [ComponentManager](ComponentManager.md)
- [ArraySwapAndPop](ArraySwapAndPop.md)
## Recommended
- [Subcomponent](Subcomponent.md)
---
# Methods:

---
## Constructor
This function creates a struct of the Component class.
``` gml
new Component(name, tags, events);
```

> Note: This Constructor should not be used directly as it is an abstract class.
> It only exists for the purpose of inheritance.

| Argument | Type                        | Description                                                                                                                                                                                                                                                 |
| -------- | --------------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name     | String                      | The name of the Component. It must be unique inside of its ComponentManager.                                                                                                                                                                                |
| tags     | Array\<String\>             | The tags of the Component. Duplicates and "\*" tags will be removed.                                                                                                                                                                                        |
| events   | Array\<\[Real,Real,Real\]\> | The array of events in which the Component should execute. It is structured like this:<br>\[ \[event_type, event_number, priority\], ... \].<br>The priority defaults to 1 if it isn't found.<br>Note that the priority is per-event and not per-Component. |

Example:
``` gml
function DummyComponent(name) : Component(name, []) {}
```
The above code creates a Constructor for the DummyComponent class, inheriting from the Component constructor. No event is specified for execution.

---
## Execute (Override)
This function doesn't do anything in the Component class, but it can be implemented in subclasses. The behavior depends on the purpose of the subclass implementing it.
``` gml
execute(ev_type, ev_num);
```

| Argument    | Type                 | Description                               |
| ----------- | -------------------- | ----------------------------------------- |
| \[ev_type\] | Constant.EventType   | The type of event to perform.             |
| \[ev_num\]  | Constant.EventNumber | The constant for the of event to perform. |
Returns: `N/A`

Example:
``` gml
function PrintComponent(name) : Component(name, [[ev_step, ev_step_normal]]) {
	execute = function(ev_type, ev_num){
		show_debug_message("Hello World!");
	}
}
```
The above code defines a subclass called PrintComponent that correctly implements the execute function, which simply prints "Hello World!" in the console during the Step Event.

---
## Destroy (Override)
This function doesn't do anything in the Component class, but it can be implemented in subclasses. The behavior depends on the purpose of the subclass implementing it.
``` gml
destroy();
```

Returns: `N/A`

> Note: This method is designed to run when the ComponentManager terminates by default.
> It shouldn't be used anywhere else unless specified otherwise.

---
## Attach (Private)
This function stores the reference of the ComponentManager for internal behavior
``` gml
attach(manager);
```

| Argument | Type                    | Description                                                 |
| -------- | ----------------------- | ----------------------------------------------------------- |
| manager  | Struct.ComponentManager | The ComponentManager inside which this Component is stored. |
Returns: `N/A`

> Note: It is highly recommended not to use this method as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Detach (Private)
This function removes the reference of the ComponentManager.
``` gml
detach();
```

Returns: `N/A`

> Note: It is highly recommended not to use this method as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Deactivate
This function prevents the Component from executing by replacing the *execute()* method with an empty function, while storing a backup as *deactivated_execute()* to allow reactivation later. This method gets skipped if the component is already inactive.
``` gml
deactivate();
```

Returns: `N/A`

Example:
``` gml
movement_component.deactivate();
play_cutscene("character standing still");
```
The above code deactivates *movement_component* to avoid movement during the cutscene.

---
## Activate
This function allows the Component to [execute](#execute-override). Every Component is active by default, unless specified otherwise, so this method should be used after the [deactivate()](#deactivate) method. This method gets skipped if the component is already active.
``` gml
activate();
```

Returns: `N/A`

Example:
``` gml
movement_component.deactivate();
play_cutscene("character standing still");
movement_component.activate();
```
The above code deactivates *movement_component* to avoid movement during the cutscene.
After that, the Component gets reactivated and so the character can move again.
This avoids removing and recreating Components, simplifying the process and improving performance.

---
## Deactivated Execute
This function is a backup copy of *execute()*, stored for the *activate()*/*deactivate()* methods.
It is updated during the *deactivate()* method.
``` gml
deactivated_execute();
```

Returns: `N/A`

> Note: This method is designed for internal behavior (as a backup copy), but it can be used to run a Component regardless of active state, which can be useful in some cases.

Example:
``` gml
// Step Event

if(keyboard_check(vk_space)){
	movement_component.deactivate();
}

if(++frames % 5 == 0 && !movement_component.is_active){
	frames %= 5;
	movement_component.deactivated_execute();
}
```
The above code deactivates *movement_component* when space is pressed, and executes the Component once every 5 frames (instead of every frame) only if it's inactive, so that the movement slows down to 0.2x.

---
## Has Tag
This function checks if the Component has a specific tag.
``` gml
has_tag(tag);
```

| Argument | Type   | Description           |
| -------- | ------ | --------------------- |
| tag      | String | The tag to search for |
Returns: `Bool`

Example:
``` gml
if(!movement_component.has_tag("movement")){
	show_debug_message("the movement_component isn't tagged correctly");
}
```
The above code checks if *movement_component* is tagged as "movement" and prints a message if it isn't.

---
## Get Tags
This function returns an array containing all the tags of this Component. It can either return a copy (default) or the array itself (unsafe).
``` gml
get_tags([safe]);
```

| Argument | Type | Description                                                                                                       |
| -------- | ---- | ----------------------------------------------------------------------------------------------------------------- |
| \[safe\] | Bool | If true (default), the function will return a copy of the array. False should only be used for read-only purposes |
Returns: `Array<String>`

Example:
``` gml
var arr = movement_component.get_tags();
var len = array_length(arr);

for(var i=0; i<len; i++){
	show_debug_message(string(i+1) + " - " + arr[i]);
}
```
The above code prints all the tags of *movement_component* as a numbered list. The output might look something like this:
```
 1 - movement
 2 - jump
 3 - player-exclusive
```

---
## Add Tag
This function adds the specified tag to the Component's internal structure and updates the ComponentManager, if it exists.
``` gml
add_tag(tag);
```

> Note: using the wildcard tag "\*" or an already existing tag will cause the function to skip, printing a warning message.

| Argument | Type   | Description    |
| -------- | ------ | -------------- |
| tag      | String | The tag to add |
Returns: `N/A`

Example:
``` gml
if(!movement_component.has_tag("movement")){
	movement_component.add_tag("movement");
}
```
The above code checks if *movement_component* is tagged as "movement" and if it isn't, the tag is added.

---
## Remove Tag
This function removes the specified tag from the Component's internal structure and updates the ComponentManager, if it exists.
``` gml
remove_tag(tag);
```

> Note: using the wildcard tag "\*" or an non-existent tag will cause the function to skip, printing a warning message.

| Argument | Type   | Description       |
| -------- | ------ | ----------------- |
| tag      | String | The tag to remove |
Returns: `N/A`

Example:
``` gml
if(movement_component.has_tag("movement")){
	movement_component.remove_tag("movement");
}
```
The above code checks if *movement_component* is tagged as "movement" and if it is, the tag is removed.

---
## Replace Tag
This function replaces a specified tag with another one, changing the Component's internal structure and updating the ComponentManager if it exists.
``` gml
replace_tag(old_tag, new_tag);
```

> Note: the function will skip with a warning message if the *old_tag* doesn't exist, if the *new_tag* already exists or if either of them is the wildcard tag "\*"

| Argument | Type   | Description                           |
| -------- | ------ | ------------------------------------- |
| old_tag  | String | The tag to replace                    |
| new_tag  | String | The tag to replace the other tag with |
Returns: `N/A`

Example:
``` gml
if(movement_component.has_tag("movement")){
	movement_component.replace_tag("movement", "move");
}
```
The above code checks if *movement_component* is tagged as "movement" and if it is, the tag is replaced with "move".

---
# Fields

---
## Manager (Read-Only)
This variable stores the ComponentManager passed in the *attach()* method.
``` gml
manager;
```

Returns: `Struct.ComponentManager`

> Note: It is highly recommended not to manually edit this field as it is designed for read-only use.

Example:
``` gml
if(movement_component.manager.has_component("dummy")){
	show_debug_message("the manager has a Component named 'dummy'");
}else{
	show_debug_message("the manager doesn't have a Component named 'dummy'");
}
```
The above code performs a check on the contents of the ComponentManager

---
## Is Active (Read-Only)
This variable stores the active state of the Component, being true if active and false otherwise.
``` gml
is_active;
```

Returns: `Bool`

> Note: It is highly recommended not to manually edit this field as it is designed for read-only use.

Example:
``` gml
if(movement_component.is_active){
	show_debug_message("the Component is active");
}else{
	show_debug_message("the Component is inactive");
}
```
The above code performs a check on the current state of the Component and prints the result.

---
## Name (Read-Only)
This variable stores the name of the Component, it must be unique inside of the ComponentManager because it's needed for Component identification.
``` gml
name;
```

Returns: `String`

> Note: It is highly recommended not to manually edit this field as it is designed for read-only use.

Example:
``` gml
show_debug_message("the Component name is " + movement_component.name);
```
The above code prints the name of the *movement_component* variable.

---
## Events (Private)
This variable stores the array of events in which the component will execute.
It is structured like this: \[ \[event_type, event_number, priority\], ... \]
``` gml
events;
```

Returns: `Array<[Real,Real,Real]>`

> Note: It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Tags (Private)
This variable stores the tags for this Component.
``` gml
tags;
```

Returns: `Array<String>`

> Note: It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly. You should use *get_tags()* instead