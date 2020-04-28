cmake_minimum_required(VERSION 3.17)

# Project Name
project(
  CMakeTemplate
  VERSION 0.0
  DESCRIPTION "Basic template for starting out a new CMake-based project."
  LANGUAGES CXX
)

# Cross-platform compatibility.
if(UNIX AND NOT APPLE)
  set(LINUX TRUE)
endif()

# Discover modules.
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_SOURCE_DIR}/cmake/modules")
# find_package(DEPENDENCY_NAME REQUIRED)

# Discover macros.
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_SOURCE_DIR}/cmake/macros")
include(Public)

# Compiler options.
string(APPEND CMAKE_SHARED_LINKER_FLAGS " -Wl,--no-undefined")

# Testing.
if(BUILD_TESTING)
    enable_testing()
    list(APPEND CMAKE_CTEST_ARGUMENTS "--output-on-failure")
endif()

# Build targets.
add_subdirectory(thirdparty)
add_subdirectory(exampleProgram)
add_subdirectory(exampleSharedLibrary)
add_subdirectory(exampleStaticLibrary)
