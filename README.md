![Build and test](https://github.com/moddyz/CXXTemplate/workflows/Build%20and%20test/badge.svg)

# CXXTemplate

A starting point for a new CMake-based C++ project.

## Table of Contents

- [Dependencies](#dependencies)
- [Building](#building)
- [Template usage](#template-usage)

### Dependencies

The following dependencies are required:
- `>= CMake-3.12`
- `>= C++11`

The following dependencies are optional:
- `doxygen` and `graphviz` (for documentation)

## Building

Example snippet for building this project:
```
mkdir build
cd build
cmake -DCMAKE_INSTALL_PREFIX="/apps/CXXTemplate/" ..
cmake --build  . -- VERBOSE=1 -j8 all test install
```

## Template usage

To use this template: 
1. Create a new repository using **CXXTemplate** as the selected template project.
2. Replace occurances of "CXXTemplate" with the new project name.
```bash
find . -name ".git" -prune -o -type f -exec sed -i "s/CXXTemplate/YOUR_PROJECT_NAME/g" {} +
```
3. Prune any un-wanted source directories or files (such as the example library and programs under `src/`).

Convenience functions and macros are available to build libraries, documentation, programs, tests, or export the project:
- `cpp_library` [Example usage](src/exampleSharedLibrary/CMakeLists.txt)
- `cpp_program` [Example usage](src/exampleProgram/CMakeLists.txt)
- `cpp_test_program` [Example usage](src/exampleSharedLibrary/tests/CMakeLists.txt)
- `export_project` [Example usage](CMakeLists.txt)

See [cmake/macros](cmake/macros) for available tools.
