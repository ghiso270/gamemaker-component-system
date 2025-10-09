# Private Data
This library adopts the following standard to mark private fields and methods:
each struct with private data will have a field named '\_\_' (double underscore), which will contain all private fields and methods. It is highly recommended not to manually edit private fields because it may cause malfunctioning, and only read them using the appropriate getter methods.

# Reserved tags
This library allows any valid string as tag except "" (Empty String) and "\*" (Wildcard Tag).
Furthermore, some prefix should be reserved to determine classes of Components: GameMaker by itself has no way of telling the class of a struct, so we have to keep track of that because it might be useful in some cases (example: deactivating all movement-related Components for a cutscene, without having to manually tag them all as "movement"). For these reason any tag with the prefix "::" (like "::Movement") should be consider reserved even if it isn't explicitly forbidden. If you want to create a custom Component you should ensure your class tag is different from any other class tag.