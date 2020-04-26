#
# Private utilities
#

# Utility for setting compilation flags.
function(
    _set_compiler_flags
    TARGET_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        INCLUDE_PATHS
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    target_compile_options(
        ${TARGET_NAME}
        PRIVATE -g
                -O3
                -Wno-deprecated
                -Werror
    )

    target_compile_features(
        ${TARGET_NAME}
        PRIVATE cxx_std_17
    )

    target_include_directories(
        ${TARGET_NAME}
        PRIVATE $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>
                ${args_INCLUDE_PATHS}
    )

endfunction() # _set_compiler_include_flags

# Utility function for deploying public headers.
function(
    _install_public_headers
    LIBRARY_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        PUBLIC_HEADERS
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    file(
        COPY ${args_PUBLIC_HEADERS}
        DESTINATION ${CMAKE_BINARY_DIR}/include/${LIBRARY_NAME}
    )
    install(
        FILES ${args_PUBLIC_HEADERS}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/include/${LIBRARY_NAME}
    )

endfunction() # _install_public_headers

function(
    _finalize_cpp_library
    LIBRARY_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
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

    # Apply common compiler flags, and include path flags.
    _set_compiler_flags(
        ${LIBRARY_NAME}
        INCLUDE_PATHS
        ${args_INCLUDE_PATHS}
    )

    # Link to libraries.
    target_link_libraries(
        ${LIBRARY_NAME}
        PRIVATE ${args_LIBRARIES}
    )

    # Install the built library.
    install(
        TARGETS ${LIBRARY_NAME}
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )
endfunction() # _cpp_library_postlude
