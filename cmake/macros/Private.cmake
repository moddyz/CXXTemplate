#
# Private build utilities.
#

# Utility for setting common compilation properties, along with include paths.
function(
    _set_compile_properties
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

    target_compile_options(${TARGET_NAME}
        PRIVATE -g      # Include debug symbols.
                -O3     # Highest degree of code optimisation.
                -Wall   # Enable _all_ warnings.
                -Werror # Error on compilation for warnings.
    )

    target_compile_features(${TARGET_NAME}
        PRIVATE cxx_std_17
    )

    # Set-up include paths.
    target_include_directories(${TARGET_NAME}
        PUBLIC
            $<INSTALL_INTERFACE:include>
        PRIVATE
            $<BUILD_INTERFACE:${CMAKE_BINARY_DIR}/include>
            ${args_INCLUDE_PATHS}
    )

endfunction() # _set_compile_properties

function(
    _set_link_properties
    TARGET_NAME
)
    target_link_options(
        ${TARGET_NAME}
        PRIVATE
            -Wl,--no-undefined # Link error if there are undefined symbol(s) in output object.
    )
endfunction() # _set_link_properties

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

    # Apply common compiler properties, and include path properties.
    _set_compile_properties(
        ${LIBRARY_NAME}
        INCLUDE_PATHS
        ${args_INCLUDE_PATHS}
    )

    _set_link_properties(
        ${LIBRARY_NAME}
    )

    # Link to libraries.
    target_link_libraries(
        ${LIBRARY_NAME}
        PRIVATE
            ${args_LIBRARIES}
    )

    # Install the built library.
    install(
        TARGETS ${LIBRARY_NAME}
        EXPORT ${CMAKE_PROJECT_NAME}-targets
        LIBRARY DESTINATION lib
        ARCHIVE DESTINATION lib
    )
endfunction() # _cpp_library_postlude
