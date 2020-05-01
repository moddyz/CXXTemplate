#
# Convenience macros for building libraries and executable programs.
#

include(
    Private
)

# Build doxygen documentation utility.
#
# Options:
#   GENERATE_TAGFILE
#       Boolean option to specify if a tagfile should be generated.
#
# Single value arguments:
#   DOXYFILE
#       Doxyfile which will be configured by CMake and used to generate documentation.
#
# Multi-value arguments:
#   INPUTS
#       Input source files to generate documentation for.
#   DEPENDENCIES
#       Target names which the documentation generation should depend on.
#
# The source DOXYFILE will be configured with visible CMake variables.
# doxygen_documentation will introduce the following variables within the scope of
# the function, based on arguments:
# - DOXYGEN_INPUTS
#       Set from INPUTS argument.
#       Please assign @DOXYGEN_INPUTS@ to the INPUTS property in the DOXYFILE.
# - DOXYGEN_TAGFILE
#       Path to the generated tagfile - if GENERATE_TAGFILE is TRUE.
#       Please assign @DOXYGEN_TAGFILE@ to the GENERATE_TAGFILE property in the DOXYFILE.
# - DOT_EXECUTABLE
#       Path to the dot executable, via find_program.
#       Please assign @DOT_EXECUTABLE@ to DOT_PATH property in the DOXYFILE.
# - DOXYGEN_OUTPUT_DIR
#       Output directory for generated documentation.
#       Please assign @DOXYGEN_OUTPUT_DIR@ to OUTPUT_DIRECTORY property in the DOXYFILE.
function(
    doxygen_documentation
    DOCUMENTATION_NAME
)
    set(options
        GENERATE_TAGFILE
    )
    set(oneValueArgs
        DOXYFILE
    )
    set(multiValueArgs
        INPUTS
        DEPENDENCIES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Find doxygen executable
    find_program(DOXYGEN_EXECUTABLE
        NAMES doxygen
    )
    if (EXISTS ${DOXYGEN_EXECUTABLE})
        message(STATUS "Found doxygen: ${DOXYGEN_EXECUTABLE}")
    else()
        message(FATAL_ERROR "doxygen not found.")
    endif()

    # Find dot executable
    find_program(DOT_EXECUTABLE
        NAMES dot
    )
    if (EXISTS ${DOT_EXECUTABLE})
        message(STATUS "Found dot: ${DOT_EXECUTABLE}")
    else()
        message(FATAL_ERROR "dot not found.")
    endif()

    # Configure Doxyfile.
    set(DOXYGEN_INPUT_DOXYFILE ${args_DOXYFILE})
    string(REPLACE ";" " \\\n" DOXYGEN_INPUTS "${args_INPUTS}")
    set(DOXYGEN_OUTPUT_DIR ${CMAKE_BINARY_DIR}/docs/${DOCUMENTATION_NAME})
    set(DOXYGEN_OUTPUT_DOXYFILE "${DOXYGEN_OUTPUT_DIR}/Doxyfile")
    set(DOXYGEN_OUTPUT_HTML_INDEX "${DOXYGEN_OUTPUT_DIR}/html/index.html")
    if (${args_GENERATE_TAGFILE})
        set(DOXYGEN_TAGFILE "${DOXYGEN_OUTPUT_DIR}/${DOCUMENTATION_NAME}.tag")
    endif()

    configure_file(
        ${DOXYGEN_INPUT_DOXYFILE}
        ${DOXYGEN_OUTPUT_DOXYFILE}
    )

    # Build documentation.
    add_custom_command(
        COMMAND ${DOXYGEN_EXECUTABLE} ${DOXYGEN_OUTPUT_DOXYFILE}
        OUTPUT ${DOXYGEN_OUTPUT_HTML_INDEX}
        WORKING_DIRECTORY ${CMAKE_BINARY_DIR}
        MAIN_DEPENDENCY ${DOXYGEN_OUTPUT_DOXYFILE} ${DOXYGEN_INPUT_DOXYFILE}
        DEPENDS ${args_DEPENDENCIES}
        COMMENT "Generating doxygen documentation."
    )

    add_custom_target(
        ${DOCUMENTATION_NAME} ALL
        DEPENDS
            ${DOXYGEN_OUTPUT_HTML_INDEX}
    )

    install(
        DIRECTORY ${DOXYGEN_OUTPUT_DIR}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/docs
    )

endfunction()

# List all the sub-directories, under PARENT_DIRECTORY, and store into SUBDIRS.
macro(
    list_subdirectories
    SUBDIRS
    PARENT_DIRECTORY
)
    # Glob all files under current directory.
    file(
        GLOB
        CHILDREN
        RELATIVE ${PARENT_DIRECTORY}
        ${PARENT_DIRECTORY}/*
    )

    set(DIRECTORY_LIST
        ""
    )

    foreach(
        CHILD
        ${CHILDREN}
    )
        if(IS_DIRECTORY
           ${PARENT_DIRECTORY}/${CHILD}
        )
            list(
                APPEND
                DIRECTORY_LIST
                ${CHILD}
            )
        endif()
    endforeach()

    set(${SUBDIRS}
        ${DIRECTORY_LIST}
    )
endmacro()

# Builds a new shared library.
function(
    cpp_shared_library
    LIBRARY_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        CPPFILES
        PUBLIC_HEADERS
        INCLUDE_PATHS
        LIBRARIES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Install public headers for build and distribution.
    _install_public_headers(
        ${LIBRARY_NAME}
        PUBLIC_HEADERS
            ${args_PUBLIC_HEADERS}
    )

    # Add a new shared library target.
    add_library(
        ${LIBRARY_NAME}
        SHARED
        ${args_CPPFILES}
        ${args_PUBLIC_HEADERS}
    )

    _finalize_cpp_library(
        ${LIBRARY_NAME}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        LIBRARIES
            ${args_LIBRARIES}
    )

endfunction() # cpp_shared_library

# Builds a new static library.
function(
    cpp_static_library
    LIBRARY_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        CPPFILES
        PUBLIC_HEADERS
        INCLUDE_PATHS
        LIBRARIES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Install public headers for build and distribution.
    _install_public_headers(
        ${LIBRARY_NAME}
        PUBLIC_HEADERS
        ${args_PUBLIC_HEADERS}
    )

    # Add a new shared library target.
    add_library(
        ${LIBRARY_NAME}
        STATIC
        ${args_CPPFILES}
        ${args_PUBLIC_HEADERS}
    )

    _finalize_cpp_library(
        ${LIBRARY_NAME}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        LIBRARIES
            ${args_LIBRARIES}
    )

endfunction() # cpp_static_library

# Builds a new executable program.
function(
    cpp_program
    PROGRAM_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        CPPFILES
        INCLUDE_PATHS
        LIBRARIES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Add a new executable target.
    add_executable(
        ${PROGRAM_NAME}
        ${args_CPPFILES}
    )

    _set_compiler_flags(
        ${PROGRAM_NAME}
        INCLUDE_PATHS
        ${args_INCLUDE_PATHS}
    )

    _set_link_flags(
        ${PROGRAM_NAME}
    )

    target_link_libraries(
        ${PROGRAM_NAME}
        PRIVATE ${args_LIBRARIES}
    )

    # Install built executable.
    install(
        TARGETS ${PROGRAM_NAME}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    )

endfunction() # cpp_program

# A specialised executable program, for tests.
function(
    cpp_test_program
    PROGRAM_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        CPPFILES
        INCLUDE_PATHS
        LIBRARIES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # A test program target is the same as a program target, except it as an
    # extra library dependency onto catch2.
    cpp_program(
        ${PROGRAM_NAME}
        CPPFILES
        ${args_CPPFILES}
        INCLUDE_PATHS
        ${args_INCLUDE_PATHS}
        LIBRARIES
        ${args_LIBRARIES}
        catch2
    )

    add_test(
        NAME ${PROGRAM_NAME}
        COMMAND $<TARGET_FILE:${PROGRAM_NAME}>
    )

endfunction() # cpp_test_program
