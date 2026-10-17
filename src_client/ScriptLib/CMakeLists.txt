project(ScriptLib LANGUAGES CXX)

file(GLOB_RECURSE SCRIPTLIB_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE SCRIPTLIB_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(ScriptLib STATIC
  ${SCRIPTLIB_SOURCES}
  ${SCRIPTLIB_HEADERS}
)

target_link_libraries(ScriptLib PUBLIC third_party)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(ScriptLib PRIVATE NANOBEGIN= NANOEND=)
endif()

target_include_directories(ScriptLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(ScriptLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
