file(GLOB CPPFILES *.cpp)
foreach(CPPFILE ${CPPFILES})
    get_filename_component(TEST_PROGRAM ${CPPFILE} NAME_WE)
    cpp_test_program(${TEST_PROGRAM}
        CPPFILES
            ${CPPFILE}
        LIBRARIES
            examplePrefix_exampleLibrary
    )
endforeach(CPPFILE)
