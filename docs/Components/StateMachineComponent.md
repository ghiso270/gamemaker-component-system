# Description
A class that manages states. Multiple can be used if the use case requires it, for example if you have two independent sets of states.
States can easily be added with the *add state()* method.
The *execute()* method executes the state behavior.
Other methods can be used to retrieve specific data or to forcefully change state.
The State Machine won't start executing until the *start()* method is run, which initializes a state.

---
# Dependencies
## Mandatory
- [Component](Component.md)
## Recommended
- [MotionComponent](MotionComponent.md)

---
# Methods/Functions

---
## Constructor
This function creates a struct of the StateMachineComponent class.
``` gml
new StateMachineComponent(name, tags, [debug], [events]);
```

| Argument   | Type                        | Description                                                                                                                                             |
| ---------- | --------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name       | String                      | The name of the Component. It must be unique inside of its ComponentManager                                                                             |
| tags       | Array\<String\>             | The tags of the Component. Duplicates and "\*" tags will be removed                                                                                     |
| \[debug\]  | Bool                        | Whether or not to activate debug mode, which will perform more checks and log most functions. Defaults to false                                         |
| \[events\] | Array\<\[Real,Real,Real\]\> | \[ \[event_type, event_number, priority\], ... \].<br>The priority defaults to 1 if it isn't found.<br>Defaults to \[ \[ev_step, ev_step_normal, 1\] \] |
Example:
``` gml
sm = new StateMachineComponent("state-machine", [], true);
```
The above code creates a StateMachineComponent called "state-machine" in debug mode, with no tags. 

---
## Execute
This function updates the current state and then executes its step() function.
``` gml
execute([ev_type], [ev_num]);
```

> Note: this function will be automatically executed by the ComponentManager it is attached to.

| Argument    | Type                 | Description                                                        |
| ----------- | -------------------- | ------------------------------------------------------------------ |
| \[ev_type\] | Constant.EventType   | The type of event to perform. defaults to the current one          |
| \[ev_num\]  | Constant.EventNumber | The number of the event in execution. defaults to the current one. |
Returns: `N/A`

---
## Add State
This function lets you add a state with various parameters.
``` gml
add_state(name, next_states, step, [on_enter], [on_exit]);
```

| Argument     | Type     | Description                                                                                                                                                                                                                                                                                                                                                                                                                  |
| ------------ | -------- | ---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| name         | String   | The state name (must be unique)                                                                                                                                                                                                                                                                                                                                                                                              |
| next_states  | Struct   | A map\[new_state\] -> condition, the condition must be a function that takes in input 1 argument (scope) and returns either true (change state to new_state) or false. Keep in mind that the function should be executed within the input scope, so it's highly recommended that the function consist of a with() block. Also, only the first true condition found will be considered, so only one should be true at a time. |
| step         | Function | The action of the state, that is executed during every event specified in the State Machine. Takes in input 3 arguments (ev_type, ev_num, scope)                                                                                                                                                                                                                                                                             |
| \[on_enter\] | Function | The function executed only when the state changes from another state to this. Takes in input 1 argument (scope)                                                                                                                                                                                                                                                                                                              |
| \[on_exit\]  | Function | The function executed only when the state changes from this to another state. Takes in input 1 argument (scope)                                                                                                                                                                                                                                                                                                              |
Returns: `N/A`

Example:
``` gml
state_machine.add_state("down", {
	up: function(scope){return keyboard_check(vk_up)}
}, function(ev_type, ev_num, scope){});

state_machine.add_state("up", {
	down: function(scope){with(scope){return keyboard_check(vk_down) || timer<0}}
}, function(ev_type, ev_num, scope){
	with(scope){timer--;}
}, function(scope){
	with(scope){timer = 30;}
}, function(scope){
	with(scope){show_debug_message(timer)};
});
```
The above code defines a StateMachineComponent with 2 states, "up" and "down". They can be interchanged freely using arrow keys, but when "up" is the current state, a timer starts as 30 but goes down every frame until it reaches 0, then the state is changed to "down" again.

---
## Start
This function initializes the StateMachineComponent with an initial state. 
``` gml
start(init_state);
```

> Note: This method should only be used once.

| Argument   | Type   | Description                       |
| ---------- | ------ | --------------------------------- |
| init_state | String | The name of the state to start in |
Returns: `N/A`

Example:
``` gml
state_machine.add_state("existing", {},
function(ev_type, ev_num, scope){show_debug_message("i think, therefore i am")});

state_machine.start("existing");
```
The above code starts a simple State Machine with only one state: "existing".

---
## Get State
This function returns the name of the current state of the StateMachineComponent.
``` gml
get_state();
```

> Note: if called before *start()*, this function will return undefined.

Returns: `String`

Example:
``` gml
state_machine.add_state("existing", {},
function(ev_type, ev_num, scope){show_debug_message("i think, therefore i am")});

state_machine.start("existing");
show_debug_message(state_machine.get_state());
```
The above code prints the current state of the *state_machine*, after it's started.

Output:
```
existing
```

---
## Get State Data
This function returns the data of the specified state.
The returned data will be a struct containing {next_states, step, on_enter, on_exit} exactly the same as the arguments provided in *add_state()*.
``` gml
get_state_data(state);
```

| Argument | Type   | Description                              |
| -------- | ------ | ---------------------------------------- |
| state    | String | The name of the state to get the data of |
Returns: `Struct`

Example:
``` gml
state_machine.add_state("existing", {},
function(ev_type, ev_num, scope){show_debug_message("i think, therefore i am")});

var data = state_machine.get_state_data("existing");
show_debug_message(string(struct_names_count(data.next_states)));
```
The above code prints the amount of states after "existing", in this case 0.

---
## Change State
This function manually changes the current state to the specified one, even if its condition isn't met. This method should be used carefully only in specific cases, like setting the state from "running" to "idle" right after pausing.
``` gml
change_state(new_state);
```

| Argument         | Type   | Description                         |
| ---------------- | ------ | ----------------------------------- |
| new_state        | String | The name of the state to change to  |
Returns: `N/A`

Example:
``` gml
if(global.pause){
	state_machine.change_state("idle");
}
```
The above code forces the state on "idle" when the game is paused.

---
# Fields (PRIVATE)

---
## Debug
This variable holds the value provided in the Constructor, determining whether or not the State Machine is in debug mode.
``` gml
debug;
```

Returns: `Bool`

---
## State
This variable holds the current state name.
``` gml
state;
```

Returns: `String`

---
## Step
This variable holds the current state's step function. This is just a way to avoid retrieving the value inside *state_data* every frame.
``` gml
step;
```

Returns: `Function`

---
## State Data
This variable holds all information regarding a state.
It maps state name to a struct containing {next_states, step, on_enter, on_exit} exactly the same as the arguments provided in *add_state()*.
``` gml
state_data;
```

Returns: `Struct`