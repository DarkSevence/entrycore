project(EterLib LANGUAGES CXX)

file(GLOB_RECURSE ETERLIB_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE ETERLIB_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(EterLib STATIC
  ${ETERLIB_SOURCES}
  ${ETERLIB_HEADERS}
)

target_link_libraries(EterLib PUBLIC third_party)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>")

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(EterLib PRIVATE NANOBEGIN= NANOEND=)
endif()


target_include_directories(EterLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(EterLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
