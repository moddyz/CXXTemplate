set(LIBRARY_NAME exampleStaticLibrary)

cpp_library(${LIBRARY_NAME}
    TYPE STATIC
    CPPFILES
        add.cpp
    PUBLIC_HEADERS
        add.h
)

if(BUILD_TESTING)
    add_subdirectory(tests)
endif()
