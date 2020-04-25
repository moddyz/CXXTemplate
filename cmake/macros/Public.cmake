#
# Convenience macros for building libraries and executable programs.
#

include(
    Private
)

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

    # Library.
    add_library(
        ${PREFIXED_LIBRARY}
        SHARED
        ${args_CPPFILES}
    )

    _set_compiler_flags(
        ${PREFIXED_LIBRARY}
        INCLUDE_PATHS
        ${args_INCLUDE_PATHS}
    )

    target_link_libraries(
        ${PREFIXED_LIBRARY}
        PRIVATE ${args_LIBRARIES}
    )

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
        PRIVATE ${args_LIBRARIES}
    )

    # Install
    install(
        TARGETS ${PROGRAM_NAME}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    )

endfunction() # CMakeTemplate_program
