# Description
An abstract class that serves as a template for subclasses of Subcomponents.
Its purpose is to provide helper methods and functionalities to Components.
For this reason methods widely vary depending on the purpose of the Subcomponent, this abstract class only contains getter and setter methods for the parent (reference to the Component managing the Subcomponent).

> Note: This class only exists for inheritance. It should only be used to create custom Components.

---
# Dependencies
## Mandatory
- [Component](Component.md)

---
# Methods

---
## Constructor
This function creates a struct of the Subcomponent class.
``` gml
new Subcomponent();
```

> Note: This Constructor should not be used directly as it is an abstract class.
> It only exists for the purpose of inheritance.

Example:
``` gml
function CustomSubcomponent(data) : Subcomponent() {}
```
The above code creates a Constructor for the CustomSubcomponent class, inheriting from the Subcomponent constructor.

---
## Get Parent
This function returns a direct reference (not a copy) of the Component of this Subcomponent. The parent is the Component that contains and uses this Subcomponent. 
``` gml
get_parent();
```

Returns: `Struct.Component`

Example:
``` gml
if(subcomp.get_parent().has_tag("important")){
	show_debug_message("the parent is important");
}else{
	show_debug_message("the parent is not important");
}
```
The above code performs a check on the contents of the parent Component and prints text accordingly.

---
## Set Parent
This function assigns a Component to be this Subcomponent's parent.
``` gml
set_parent(parent);
```

> Note: this should only be used for Components internal behavior as it might cause errors.

| Argument | Type             | Description                        |
| -------- | ---------------- | ---------------------------------- |
| parent   | Struct.Component | The component to assign as parent. |
Returns: `N/A`

Example:
``` gml
custom_component.set_input_subcomponent = function(subcomp){
	self.input_subcomponent = subcomp;
	subcomp.set_parent(self);
}
```
The above code defines a *set_input_subcomponent()* for a custom component, which simply marks the parent-child relationship of the input subcomponent and *custom_component*.

---
# Fields (PRIVATE)

---
## Parent
This variable holds a reference to the parent of this Subcomponent.
``` gml
parent;
```

Returns: `Struct.Component`