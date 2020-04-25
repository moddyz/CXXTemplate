CMakeTemplate_library(
    examplePrefix
    exampleLibrary
    CPPFILES
        add.cpp
    PUBLIC_HEADERS
        add.h
)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
