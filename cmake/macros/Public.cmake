#
# Convenience macros for building libraries and executable programs.
#

include(
    Private
)

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
