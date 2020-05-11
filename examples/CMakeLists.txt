list_subdirectories(
    SUBDIRS
    ${CMAKE_CURRENT_SOURCE_DIR}
)

foreach(
    subdir
    ${SUBDIRS}
)
    message(STATUS "Found experiment: ${subdir}" )
    add_subdirectory(
        ${subdir}
    )
endforeach()
