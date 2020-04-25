# CMakeTemplate

Basic template for starting out a new CMake-based project.

## Usage

This template can be used as a starting point for a new CMake-based C++ project.

A find and replace of "CMakeTemplate" with your project name will update relevant tokens to be specific to a project, ie:
```
find . -name ".git" -prune -o -type f -exec sed -i "s/CMakeTemplate/YourProjectName/g" {} +
```

## Macros

Convenience macros are available to build and deploy a library or a program.

Examples:
- [exampleLibrary](exampleProgram/CMakeLists.txt)
- [exampleProgram](exampleProgram/CMakeLists.txt)
