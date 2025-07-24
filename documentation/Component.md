# Description:
An abstract class that serves as a template for subclasses of Components.
The [execute()](#execute-override) method is for the main behavior that gets executed during each of the specified events. Other methods are used to [activate](#activate)/[deactivate](#deactivate) the Component.
Supplementary methods or Subcomponents can be added to include more functionalities.

> Note: This class only exists for inheritance. It should only be used to create custom Components.

---
# Dependencies:
## Mandatory
- [ComponentManager](ComponentManager.md)
## Recommended
- [ClassComponentManager](ClassComponentManager.md)
- [Subcomponent](Subcomponent.md)
---
# Methods:

---
## Constructor
This function creates a struct of the Component class.
``` gml
new Component(name, events);
```

> Note: This Constructor should not be used directly as this is an abstract class.
> It only exists for the purpose of inheritance.

| Argument            | Type                | Description                                                                                                                                                                      |
| ------------------- | ------------------- | -------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| [name](#name)     | String              | The name of the Component. It must be unique inside of the same ComponentManager.<br>If multiple Components of the same type are needed, a ClassComponentManager should be used. |
| [events](#events) | Array<\[Real,Real]> | The array of events in which the Component should execute. It is structured like this:<br>\[ \[event_type, event_number], \[ev_type, ev_num], ... ]                              |

Example:
``` gml
function DummyComponent(name) : Component(name, []) {}
```
The above code creates a Constructor for the DummyComponent class, inheriting from the Component constructor. No event is specified for execution.

---
## Execute (Override)
This function doesn't do anything in the Component class, but it can be implemented in subclasses. The behavior depends on the purpose of the subclass implementing it.
``` gml
execute();
```

Returns: `N/A`

Example:
``` gml
function PrintComponent(name) : Component(name, [[ev_step, ev_step_normal]]) {
	execute = function(){
		show_debug_message("Hello World!");
	}
}
```
The above code defined a subclass called PrintComponent that correctly implements the execute function, which simply prints "Hello World!" in the console during the Step Event.

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
## Deactivate
This function prevents the Component from executing by replacing the [execute()](#execute-override) method with an empty function, while storing a backup as [deactivated_execute()](#deactivated-execute) to allow reactivation later. This method gets skipped if the component is already inactive.
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
This function is a backup copy of [execute()](#execute-override), stored for the [activate](#activate)/[deactivate](#deactivate) methods.
It is updated during the [deactivate()](#deactivate) method.
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
The above code deactivates *movement_component* when space is pressed, and executes the Component once every 5 frames (instead of every frame) only if it's inactive, so that the movement slows down to 0.2x

---
## Attach
This function stores the reference of the ComponentManager for internal behavior
``` gml
attach(manager);
```

| Argument              | Type                    | Description                                                 |
| --------------------- | ----------------------- | ----------------------------------------------------------- |
| [manager](#manager) | Struct.ComponentManager | The ComponentManager inside which this Component is stored. |
Returns: `N/A`

> Note: It is highly recommended not to use this method as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
## Detach
This function removes the reference of the ComponentManager.
``` gml
detach();
```

Returns: `N/A`

> Note: It is highly recommended not to use this method as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.

---
# Fields

---
## Is Active
This variable stores the active state of the Component, being true if active and false otherwise.
``` gml
is_active;
```

Returns: `Bool`

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
## Manager
This variable stores the ComponentManager passed in the [attach()](#attach) method.
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
## Name
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
## Events
This variable stores the array of events in which the component will execute.
It is structured like this: \[ \[event_type, event_number], \[ev_type, ev_num], ... ]
``` gml
events;
```

Returns: `Array<[Real,Real]>`

> Note: It is highly recommended not to use this field as it is only necessary for internal behavior and can cause malfunctioning if used incorrectly.
