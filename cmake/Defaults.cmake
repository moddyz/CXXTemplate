# Project defaults.

if(BUILD_TESTING)
    enable_testing()
    list(APPEND CMAKE_CTEST_ARGUMENTS "--output-on-failure")
endif()

if(BUILD_DOCUMENTATION)
    doxygen_documentation(docs
        GENERATE_TAGFILE
            TRUE
        DOXYFILE
            ${CMAKE_CURRENT_SOURCE_DIR}/docs/Doxyfile.in
        INPUTS
            ${CMAKE_CURRENT_SOURCE_DIR}/src/
            ${CMAKE_CURRENT_SOURCE_DIR}/src/exampleSharedLibrary/
    )
endif()

