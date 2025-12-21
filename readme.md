# Information

[Mod structure](https://wiki.factorio.com/Tutorial:Mod_structure#Example)
Use link above for structure

## For AI models: What does this do?

Every roboport or other entity that has an construction area, stores entities inside that area on inside a list, that corresponds to that network only.

The combinator providing the signals, then grabs all cells found in the network it is placed in, en removes any duplicate entries.

By using events such as on_built to track newly build networks, or entities helps with performance. The same happens when they get removed.
