# Description:
A class that holds and manages all the [Component](Component.md)s of an Object asset in GameMaker.
The [execute()](#execute) method should be called in every event in which Components are expected to execute.
Utility methods are also provided, to easily add, manage and remove Components.
Finally, the [destroy()](#destroy) method should be used once the ComponentManager isn't necessary anymore, this will allow all of the Components to correctly terminate and ensure 100% functionality.

---
# Dependencies:
## Mandatory
- GameMaker Object
- [Component](Component.md)
## Recommended
- [ClassComponentManager](ClassComponentManager.md)

---
# Methods:

---
## Constructor
This function creates a struct of the ComponentManager class.
``` gml
new ComponentManager(obj, [components]);
```

| Argument                        | Type                    | Description                                                                                    |
| ------------------------------- | ----------------------- | ---------------------------------------------------------------------------------------------- |
| [obj](#object)                | Id.Instance             | The GameMaker Object asset containing this ComponentManager                                    |
| \[[components](#components)\] | Array<Struct.Component> | The array of initial components to manage (can be added later). defaults to \[ ] (empty array) |

Example:
``` gml
// Create Event in obj_player:

manager = new ComponentManager(self, [new DummyComponent("dummy")]);
```
The above code creates a ComponentManager and assigns it to a variable of *obj_player*, specifying the executing object (self = *obj_player*) and the initial components.
In this case, it's a single DummyComponent named "dummy".

---
## Execute
This function runs the [execute()](Component.md#execute-override) method of all the appropriate Components for the current event.
This method should be called in all the events of an Object asset for all the Components to work properly.
``` gml
execute();
```

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
This function returns the Component with the specified name. It's best to check with [has_component()](#has-component) beforehand.
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
This function removes the specified Component from the ComponentManager. It will do nothing if the component isn't found.
``` gml
remove_component(name)
```

| Argument | Type   | Description                         |
| -------- | ------ | ----------------------------------- |
| name     | String | The name of the Component to remove |
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
# Fields

---
## Object
This variable stores a reference to the GameMaker Object instance specified in the [constructor](#constructor).
``` gml
object;
```

Returns: Id.Instance

> [!NOTE] Note
> It is highly recommended not to manually edit this field as it is designed for read-only use.

---
## Components
This variable stores all the Components managed by this ComponentManager as an array.
``` gml
components;
```

Returns: `Array<Struct.Component>`

> [!NOTE] Note
> It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Components by Name
This variable stores all the Components in a struct (map-like) that matches a name to a Component. This makes name lookup significantly faster.
``` gml
components_by_name;
```

Returns: `Struct`

> [!NOTE] Note
> It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Components by Event
This variable stores all the Components in a 3-dimensional array to make them easily accessible by event. Specify the event_type as the first index and the event_number as the second index, and you get an array containing all the Components that are planned to run in the specified event.
``` gml
components_by_event;
```

Returns: `Array<Array<Array<Struct.Component>>>`
`(structured like this: array [event_type] [event_number] -> array of components)`

> [!NOTE] Note
> It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.