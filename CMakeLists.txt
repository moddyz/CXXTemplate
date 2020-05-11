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

# Discover macros.
list(INSERT CMAKE_MODULE_PATH 0 "${CMAKE_SOURCE_DIR}/cmake/macros")
include(Public)

# Testing.
if(BUILD_TESTING)
    enable_testing()
    list(APPEND CMAKE_CTEST_ARGUMENTS "--output-on-failure")
endif()

# Build targets.
add_subdirectory(thirdparty)
add_subdirectory(examples)

# Install exported targets.
export_project(${CMAKE_SOURCE_DIR}/cmake/Config.cmake.in)
