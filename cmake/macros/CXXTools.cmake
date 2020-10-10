#
# Functions & macros for building C++ libraries and programs.
#

# Builds a new C++ library.
#
# Single value Arguments:
#   TYPE
#       The type of library, STATIC or SHARED.
#   HEADERS_INSTALL_PREFIX
#       Optional installation prefix of the header files.  By default, the library name is used.
#
# Multi-value Arguments:
#   CPPFILES
#       C++ source files.
#   PUBLIC_HEADERS
#       Header files, which will be deployed for external usage.
#   INCLUDE_PATHS
#       Include paths for compiling the source files.
#   LIBRARIES
#       Library dependencies used for linking, but also inheriting INTERFACE properties.
#   DEFINES
#       Custom preprocessor defines to set.
#
function(
    cpp_library
    LIBRARY_NAME
)
    set(options)
    set(oneValueArgs
        TYPE
        HEADERS_INSTALL_PREFIX
    )
    set(multiValueArgs
        CPPFILES
        PUBLIC_HEADERS
        INCLUDE_PATHS
        LIBRARIES
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Install public headers for build and distribution.
    if (NOT args_HEADERS_INSTALL_PREFIX)
        _install_public_headers(
            ${LIBRARY_NAME}
            PUBLIC_HEADERS
                ${args_PUBLIC_HEADERS}
        )
    else()
        _install_public_headers(
            ${args_HEADERS_INSTALL_PREFIX}
            PUBLIC_HEADERS
                ${args_PUBLIC_HEADERS}
        )
    endif()

    # Default to STATIC library if TYPE is not specified.
    if (NOT args_TYPE)
        set(LIBRARY_TYPE "STATIC")
    else()
        set(LIBRARY_TYPE ${args_TYPE})
    endif()

    # Add a new shared library target.
    add_library(
        ${LIBRARY_NAME}
        ${args_TYPE}
        ${args_CPPFILES}
        ${args_PUBLIC_HEADERS}
    )

    # Apply common compiler properties, and include path properties.
    _set_compile_properties(${LIBRARY_NAME}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        DEFINES
            ${args_DEFINES}
    )

    _set_link_properties(${LIBRARY_NAME})

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

endfunction() # cpp_library

# Builds a new C++ executable program.
#
# Multi-value Arguments:
#   CPPFILES
#       C++ source files.
#   INCLUDE_PATHS
#       Include paths for compiling the source files.
#   LIBRARIES
#       Library dependencies used for linking, but also inheriting INTERFACE properties.
#   DEFINES
#       Custom preprocessor defines to set.
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
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    _cpp_program(${PROGRAM_NAME}
        CPPFILES
            ${args_CPPFILES}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        LIBRARIES
            ${args_LIBRARIES}
        DEFINES
            ${args_DEFINES}
    )

    # Install built executable.
    install(
        TARGETS ${PROGRAM_NAME}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/bin
    )

endfunction() # cpp_program

# Build C++ test executable program.
# The assumed test framework is Catch2, and will be provided as a library dependency.
#
# Multi-value Arguments:
#   CPPFILES
#       C++ source files.
#   INCLUDE_PATHS
#       Include paths for compiling the source files.
#   LIBRARIES
#       Library dependencies used for linking, but also inheriting INTERFACE properties.
#   DEFINES
#       Custom preprocessor defines to set.
function(
    cpp_test_program
    TEST_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        CPPFILES
        INCLUDE_PATHS
        LIBRARIES
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    _cpp_program(${TEST_NAME}
        CPPFILES
            ${args_CPPFILES}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        LIBRARIES
            catch2
            ${args_LIBRARIES}
        DEFINES
            ${args_DEFINES}
    )

    # Install built executable.
    install(
        TARGETS ${TEST_NAME}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/tests
    )

    # Add TEST_NAME to be executed when running the "test" target.
    add_test(
        NAME ${TEST_NAME}
        COMMAND $<TARGET_FILE:${TEST_NAME}>
    )

endfunction() # cpp_test_program

# Export this project for external usage.
# Targets will be exported, and the supplied Config cmake file will configured & deployed.
#
# Arguments:
#   INPUT_CONFIG
#       Path to a Config.cmake.in which will be configured with CMake variables.
function(
    export_project
    INPUT_CONFIG
)
    # Install exported targets (libraries).
    install(
        EXPORT ${CMAKE_PROJECT_NAME}-targets
        FILE
            ${CMAKE_PROJECT_NAME}Targets.cmake
        DESTINATION
            ${CMAKE_INSTALL_PREFIX}/cmake
    )

    # Configure & install <Project>Config.cmake
    set(OUTPUT_CONFIG ${CMAKE_BINARY_DIR}/${CMAKE_PROJECT_NAME}Config.cmake)
    configure_file(${INPUT_CONFIG} ${OUTPUT_CONFIG} @ONLY)
    install(
        FILES ${OUTPUT_CONFIG}
        DESTINATION ${CMAKE_INSTALL_PREFIX}
    )
endfunction()

# Convenience macro for adding the current source directory as a header only library.
#
# Positional arguments:
#   LIBRARY: The target name of this header only library.
function(
    add_header_only_library
    LIBRARY
)
    # Add a new library target.
    add_library(
        ${LIBRARY}
        IMPORTED  # TODO: Figure out what this keyword does, precisely.
        INTERFACE # This library target does not provide source files.  (Header only!)
        GLOBAL    # Make this library target available in directories above this one.
    )

    # Any target which links against the library will inherit
    # the current source directory as an include path.
    target_include_directories(
        ${LIBRARY}
        INTERFACE ${CMAKE_CURRENT_SOURCE_DIR}
    )
endfunction()

# Utility for setting common compilation properties, along with include paths.
function(
    _set_compile_properties
    TARGET_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        INCLUDE_PATHS
        DEFINES
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
                -fno-omit-frame-pointer # Preserve frame pointer register.
    )

    target_compile_definitions(${TARGET_NAME}
        PRIVATE
            ${args_DEFINES}
    )

    target_compile_features(${TARGET_NAME}
        PRIVATE cxx_std_11
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
    if (CMAKE_CXX_COMPILER_ID MATCHES "Clang")
        target_link_options(
            ${TARGET_NAME}
            PRIVATE
                -Wl,-undefined,error # Link error if there are undefined symbol(s) in output object.
        )
    else()
        target_link_options(
            ${TARGET_NAME}
            PRIVATE
                -Wl,--no-undefined # Link error if there are undefined symbol(s) in output object.
        )
    endif()
endfunction() # _set_link_properties

# Utility function for deploying public headers.
function(
    _install_public_headers
    HEADER_INSTALL_PREFIX
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
        DESTINATION ${CMAKE_BINARY_DIR}/include/${HEADER_INSTALL_PREFIX}
    )

    install(
        FILES ${args_PUBLIC_HEADERS}
        DESTINATION ${CMAKE_INSTALL_PREFIX}/include/${HEADER_INSTALL_PREFIX}
    )
endfunction() # _install_public_headers

# Internal function for a cpp program.
# This is so cpp_program and cpp_test program can install
# to different locations.
function(
    _cpp_program
    PROGRAM_NAME
)
    set(options)
    set(oneValueArgs)
    set(multiValueArgs
        CPPFILES
        INCLUDE_PATHS
        LIBRARIES
        DEFINES
    )

    cmake_parse_arguments(
        args
        "${options}"
        "${oneValueArgs}"
        "${multiValueArgs}"
        ${ARGN}
    )

    # Add a new executable target.
    add_executable(${PROGRAM_NAME}
        ${args_CPPFILES}
    )

    _set_compile_properties(${PROGRAM_NAME}
        INCLUDE_PATHS
            ${args_INCLUDE_PATHS}
        DEFINES
            ${args_DEFINES}
    )

    _set_link_properties(${PROGRAM_NAME})

    target_link_libraries(${PROGRAM_NAME}
        PRIVATE
            ${args_LIBRARIES}
    )
endfunction()
