# CMakeTemplate

Basic template which can be used as a starting point for a new CMake-based C++ project.

This project also serves as an aggregation of useful CMake functionality.

## Table of Contents

- [Convenience functions & macros](#convenience-functions-and-macros)
- [Documentation](#documentation)
- [Building](#building)
- [Build Status](#build-status)

## Convenience functions and macros

Convenience functions and macros are available to build libraries, documentation, programs, tests, or export the project:
- [cpp_library](src/exampleSharedLibrary/CMakeLists.txt)
- [cpp_program](src/exampleProgram/CMakeLists.txt)
- [cpp_test_program](src/exampleSharedLibrary/tests/CMakeLists.txt)
- [export_project](CMakeLists.txt)

See [cmake/macros/Public.cmake](cmake/macros/Public.cmake) for the full listing.

## Documentation

Documentation based on the latest state of master, [hosted by GitHub Pages](https://moddyz.github.io/CMakeTemplate/).

## Building

A convenience build script is also provided, for building all targets, and optionally installing to a location:
```
./build.sh <OPTIONAL_INSTALL_LOCATION>
```

### Requirements

- `>= CMake-3.17`
- `>= C++17`

## Build Status

|       | master | 
| ----- | ------ | 
| macOS-10.14 | [![Build Status](https://travis-ci.com/moddyz/CMakeTemplate.svg?branch=master)](https://travis-ci.com/moddyz/CMakeTemplate) |

