A support script that just executes *array_push()* and returns the resulting array.
``` gml
array_push_and_return(arr, item)
```

| Argument | Type  | Description                                         |
| -------- | ----- | --------------------------------------------------- |
| arr      | Array | The array from which you want to remove the element |
| item     | Any   | The item you want to add to the array               |

Returns: `Array`

Example:
``` gml
CustomComponent(name, tags, events) : Component(name, array_push_and_return(tags, "::CustomComponent"), events)
```
The above code defines a *CustomComponent* class that passes every parameter to the constructor of the superclass, but adding the class tag.