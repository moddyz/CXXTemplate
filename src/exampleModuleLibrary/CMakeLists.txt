set(LIBRARY_NAME exampleModuleLibrary)

cpp_module_library(${LIBRARY_NAME}
    CPPFILES
        add.cpp
    PUBLIC_HEADERS
        add.h
        api.h
)
