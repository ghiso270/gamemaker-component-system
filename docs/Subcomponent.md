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
## Set Parent (PRIVATE)
This function assigns a Component to be this Subcomponent's parent.
``` gml
set_parent(parent);
```

> Note: this should only be used for Components internal behavior as it might cause errors.

| Argument | Type             | Description                        |
| -------- | ---------------- | ---------------------------------- |
| parent   | Struct.Component | The component to assign as parent. |
Returns: `N/A`

---
## Get Classes
This function returns all the classes of the Subcomponent;
``` gml
get_classes();
```

Returns: `Array<String>`

Example:
``` gml
show_debug_message(string(input_subcomponent.get_classes()));
```
The above prints the classes of *input_subcomponent*.

Possible output:
```
["::Subcomponent", "::InputSubcomponent"];
```

---
## Has Class
This function returns whether or not the Subcomponent is of the specified class or a subclass of it.
``` gml
has_class(class);
```

| Argument | Type   | Description                                    |
| -------- | ------ | ---------------------------------------------- |
| class    | String | The class name to check (must start with "::") |
Returns: `Bool`

Example:
``` gml
if(subcomponent.has_class("::InputSubcomponent")){
	show_debug_message("the subcomponent is useful for detecting inputs");
}else{
	show_debug_message("the subcomponent can't detect inputs");
}
```
The above code checks if the Subcomponent is an InputSubcomponent or a subclass of it, and prints text accordingly.

---
## Add Class (PROTECTED)
This function allows to add the specified class to the Subcomponent.
``` gml
add_class(class);
```

> Note: this should only be used in the initialization of Subcomponents

| Argument | Type   | Description                                  |
| -------- | ------ | -------------------------------------------- |
| class    | String | The class name to add (must start with "::") |
Returns: `Bool`

Example:
``` gml
function CustomSubcomponent() : Subcomponent() constructor {
	add_class("::CustomSubcomponent");
}
```
The above code adds the class "::CustomSubcomponent" to assure the subcomponent is identified correctly.

---
# Fields (PRIVATE)

---
## Parent
This variable holds a reference to the parent of this Subcomponent.
``` gml
parent;
```

Returns: `Struct.Component`

---
## Classes
This variable holds a list of all the classes of the Subcomponent in a set-like struct.
Each class name is a key always mapped to a 'true' value
``` gml
classes;
```

Returns: `Struct`