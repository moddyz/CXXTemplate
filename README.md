# CMakeTemplate

Basic template which can be used as a starting point for a new CMake-based C++ project.

## Usage

A find and replace of "CMakeTemplate" with your project name will update relevant tokens to be specific to a project, ie:
```
find . -name ".git" -prune -o -type f -exec sed -i "s/CMakeTemplate/YourProjectName/g" {} +
```

A convenience build script is also provided, for building all targets, and optionally installing to a location:
```
./build.sh <OPTIONAL_INSTALL_LOCATION>
```

## Macros

Convenience macros are available to build and deploy a library or a program.

Examples:
- [Building a shared library.](exampleLibrary/CMakeLists.txt)
- [Building an executable program.](exampleProgram/CMakeLists.txt)
- [Building tests.](exampleLibrary/tests/CMakeLists.txt)
