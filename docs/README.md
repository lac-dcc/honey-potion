# Honey-Potion Documented

_This README specifies the folder structure of the project and the purpose of each of the folders. For more details on specific folders or files seek the .md with their names in this docs folder._

> _Picture may be outdated, please check folder structure or the written specification below_
![](../assets/tree.png)

## Assets
Contains the logo of Honey-Potion and other images used for documentation

## Benchmarks
Contains tools and examples for transforming C code into runnable EBPf programs. Divided into 3 folders:
### programs
Contains examples of C code that can be viewed as our "target" when using honey with an elixir project.
### libs
Contains the libraries for EBPf
### tools
Contains the tools for EBPf

## Lib/Honey
This is where the code for Honey-Potion resides. In other words, this is what does the process of turning an elixir code into a C counterpart.

### c_libraries
Contains elixir versions of EBPf, linux and C libraries that can be useful for honey potion>

## Priv
Contains code that has to be persisted in the HEX 
Contains the runtime functions that represent basic elixir operations in C

## Test
Contains files for testing Honey-Potion, WIP

## Docs
Has the documentation of the Honey-Potion project as an overview. Specifics of code should be handled inside each code file with intuitive naming or comments.