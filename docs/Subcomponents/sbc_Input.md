# Description
An abstract class that serves as a template for input-related subcomponents.
There are 3 main methods: *check*, *pressed* and *released*, which also allow input buffering. These methods work based on their raw counterparts: *raw_check*, *raw_pressed* and *raw_released*, these are the functions that should be overridden in subclasses.

> Note: This class only exists for inheritance. It should only be used to create custom Subcomponents: the subclasses should only override methods with the raw_\* prefix

---
# Dependencies
## Inheritance
- [Subcomponent](Subcomponent.md)
## Recommended
- [KeyInputSubcomponent](KeyInputSubcomponent.md)
---
# Methods

---
## Constructor
This function creates a struct of the sbc_Input class.
``` gml
new sbc_Input([time_manager], [buffering_time]);
```

> Note: This Constructor should not be used directly as it is an abstract class.
> It only exists for the purpose of inheritance.

| Argument           | Type                 | Description                                                                                                             |
| ------------------ | -------------------- | ----------------------------------------------------------------------------------------------------------------------- |
| \[time_manager\]   | Struct.cmp_Time | A working cmp_Time to rely on for accurate time elaboration. if left undefined (default) inputs won't be buffered. |
| \[buffering_time\] | Real                 | Determines the amount of time (in milliseconds) inputs will be buffered for. Defaults to 0 (no buffering).              |

Example:
``` gml
function MyInputSubcomponent() : sbc_Input() {}
```
The above code creates a Constructor for a class called MyInputSubcomponent, inheriting from the sbc_Input constructor with default arguments, meaning there won't be any buffering.

---
## Raw Check (Override)
This function always returns false in this class, so it should be overridden when creating subclasses.
It's supposed to return true or false depending on the current input state (true = there's input, false = no input). Example: button held down = true, button not touched = false.
``` gml
raw_check();
```

Returns: `Bool`

Example:
``` gml
function MyInputSubcomponent() : sbc_Input() {
	raw_check(){
		return global.my_input;
	}
}
```
The above code defines a subclass called MyInputSubcomponent and overrides raw_check(). The function will now read the global variable *my_input* and return its value.

---
## Raw Pressed (Override)
This function always returns false in this class, so it should be overridden when creating subclasses.
It's supposed to return true or false depending on whether or not the input has just started. For a more accurate explanation see the *keyboard_check_pressed()* method in the [GameMaker Manual](https://manual.gamemaker.io/monthly/en/#t=GameMaker_Language%2FGML_Reference%2FGame_Input%2FKeyboard_Input%2Fkeyboard_check_pressed.htm).
``` gml
raw_pressed();
```

Returns: `Bool`

Example:
``` gml
function MyInputSubcomponent() : sbc_Input() {
	raw_pressed(){
		return global.my_input_just_pressed;
	}
}
```
The above code defines a subclass called MyInputSubcomponent and overrides raw_pressed(). The function will now read the global variable *my_input_just_pressed* and return its value.

---
## Raw Released (Override)
This function always returns false in this class, so it should be overridden when creating subclasses.
It's supposed to return true or false depending on whether or not the input has just started. For a more accurate explanation see the *keyboard_check_released()* method in the [GameMaker Manual](https://manual.gamemaker.io/monthly/en/#t=GameMaker_Language%2FGML_Reference%2FGame_Input%2FKeyboard_Input%2Fkeyboard_check_released.htm).
``` gml
raw_released();
```

Returns: `Bool`

Example:
``` gml
function MyInputSubcomponent() : sbc_Input() {
	raw_released(){
		return global.my_input_just_released;
	}
}
```
The above code defines a subclass called MyInputSubcomponent and overrides raw_released(). The function will now read the global variable *my_input_just_released* and return its value.

---
## Check
This function works the same as raw_check(), but it supports input buffering, so when raw_check() would return true, this function saves the result and returns true for some time, regardless of input. Buffers can be deleted at any time by calling the function with buffer=false.
``` gml
check([buffer]);
```

> Note: The functions check(), pressed() and released() have separate, independent buffers.

| Argument   | Type | Description                                                                                                                                                                                            |
| ---------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| \[buffer\] | Bool | If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false. |
Returns: `Bool`

Example:
``` gml
// TODO
```
The above code // TODO.

---
## Pressed
This function works the same as raw_pressed(), but it supports input buffering, so when raw_pressed() would return true, this function saves the result and returns true for some time, regardless of input. Buffers can be deleted at any time by calling the function with buffer=false.
``` gml
pressed([buffer]);
```

> Note: The functions check(), pressed() and released() have separate, independent buffers.

| Argument   | Type | Description                                                                                                                                                                                            |
| ---------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| \[buffer\] | Bool | If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false. |
Returns: `Bool`

Example:
``` gml
// TODO
```
The above code // TODO.

---
## Released
This function works the same as raw_released(), but it supports input buffering, so when raw_released() would return true, this function saves the result and returns true for some time, regardless of input. Buffers can be deleted at any time by calling the function with buffer=false.
``` gml
released([buffer]);
```

> Note: The functions check(), pressed() and released() have separate, independent buffers.

| Argument   | Type | Description                                                                                                                                                                                            |
| ---------- | ---- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| \[buffer\] | Bool | If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false. |
Returns: `Bool`

Example:
``` gml
// TODO
```
The above code // TODO.

---
## Evaluate
This function works as a generic way to call check(), pressed() and released(), depending on the arguments.
``` gml
evaluate(type, buffer);
```

| Argument   | Type                  | Description                                                                                                                                                                                            |
| ---------- | --------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------ |
| type       | Constant.InputMethods | ID of the method to use, from the InputMethods enum:<br>CHECK will call check(),<br>PRESSED will call pressed(),<br>RELEASED will call released().                                                     |
| \[buffer\] | Bool                  | If set to true (and the input is true), the function will return true for some time regardless of input. If set to false, any buffer associated with this function will be deleted. Defaults to false. |
Returns: `Bool`

Example:
``` gml
var input = new KeyInputSubcomponent("A");
var type;
switch(irandom(2)){
	case 0:
		type = InputMethods.CHECK;
		break;
	case 1:
		type = InputMethods.PRESSED;
		break;
	case 2:
		type = InputMethods.RELEASED;
		break;
}
show_debug_message($"random input: {input.evaluate(type)}");
```
The above code chooses a random type each with 1/3 chance, then calls evaluate() with the chosen type.

---
# Fields (PRIVATE)

---
## Buffers
This variable stores buffered inputs in an array of size 3, structured like this:
\[check, pressed, released\]
``` gml
buffers;
```

Returns: `Array<Bool>`

---
## Timers
This variable stores timer IDs in an array of size 3, structured like this:
\[check, pressed, released\]
``` gml
timers;
```

Returns: `Array<Real>`

---
## Raw Input
This variable stores raw_\* function references in an array of size 3, structured like this:
\[check, pressed, released\]. This makes it easier for evaluate() to distinguish the 3 functions.
``` gml
raw_input;
```

Returns: `Array<Function>`

---
## Buffer Time
This variable stores the value of the buffering_time argument from the Constructor.
``` gml
buffer_time;
```

Returns: `Real`

---
## Time Manager
This variable stores the value of the time_manager argument from the Constructor.
``` gml
time_manager;
```

Returns: `Struct.cmp_Time`