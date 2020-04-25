#
# Convenience macros for building libraries and executable programs.
#

include(
    Private
)

# List all the sub-directories, under PARENT_DIRECTORY, and store
# into SUBDIRS.
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
    CMakeTemplate_library
    PACKAGE_PREFIX
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

    # Each library has a prefix which serves as the top-level organizing
    # structure.  This could be the project, or organization name.
    set(PREFIXED_LIBRARY
        ${PACKAGE_PREFIX}_${LIBRARY_NAME}
    )

    # Install public headers for build and distribution.
    _install_public_headers(
        ${PACKAGE_PREFIX}
        ${LIBRARY_NAME}
        PUBLIC_HEADERS
        ${args_PUBLIC_HEADERS}
    )

    # Add a new shared library target.
    add_library(
        ${PREFIXED_LIBRARY}
        SHARED
        ${args_CPPFILES}
    )

    # Apply common compiler flags, and include path flags.
    _set_compiler_flags(
        ${PREFIXED_LIBRARY}
        INCLUDE_PATHS
        ${args_INCLUDE_PATHS}
    )

    # Link to libraries.
    target_link_libraries(
        ${PREFIXED_LIBRARY}
        PRIVATE ${args_LIBRARIES}
    )

    # Install the built library.
    install(
        TARGETS ${PREFIXED_LIBRARY}
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )

endfunction() # CMakeTemplate_library

# Builds a new executable program.
function(
    CMakeTemplate_program
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
        PRIVATE
            ${args_LIBRARIES}
    )

    # Install built executable.
    install(
        TARGETS ${PROGRAM_NAME}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    )

endfunction() # CMakeTemplate_program

# A specialised executable program, for tests.
function(
    CMakeTemplate_test_program
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
    CMakeTemplate_program(
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

endfunction() # CMakeTemplate_test_program
