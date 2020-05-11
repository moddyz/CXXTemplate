# CMakeTemplate

Basic template which can be used as a starting point for a new CMake-based C++ project.

This project also serves as an aggregation of useful CMake functionality.

## Usage

A find and replace of "CMakeTemplate" with your project name will update relevant tokens to be specific to a project, ie:
```
find . -name ".git" -prune -o -type f -exec sed -i "s/CMakeTemplate/YourProjectName/g" {} +
```

A convenience build script is also provided, for building all targets, and optionally installing to a location:
```
./build.sh <OPTIONAL_INSTALL_LOCATION>
```

## Convience functions & macros

Convenience functions and macros are available to build libraries, documentation, programs, tests, or export the project:
- [cpp_library](examples/exampleSharedLibrary/CMakeLists.txt)
- [cpp_program](examples/exampleProgram/CMakeLists.txt)
- [cpp_test_program](examples/exampleSharedLibrary/tests/CMakeLists.txt)
- [export_project](CMakeLists.txt)

See [cmake/macros/Public.cmake](cmake/macros/Public.cmake) for the full listing.
