project(GameLib LANGUAGES CXX)

file(GLOB_RECURSE GAMELIB_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE GAMELIB_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(GameLib STATIC
  ${GAMELIB_SOURCES}
  ${GAMELIB_HEADERS}
)

target_include_directories(GameLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)
target_link_libraries(GameLib PUBLIC third_party)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>")

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(GameLib PRIVATE NANOBEGIN= NANOEND=)
endif()
set_target_properties(GameLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
