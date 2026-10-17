project(PRTerrainLib LANGUAGES CXX)

file(GLOB_RECURSE PRTERRAIN_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE PRTERRAIN_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(PRTerrainLib STATIC
  ${PRTERRAIN_SOURCES}
  ${PRTERRAIN_HEADERS}
)

target_link_libraries(PRTerrainLib PUBLIC third_party)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>")

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(PRTerrainLib PRIVATE NANOBEGIN= NANOEND=)
endif()

target_include_directories(PRTerrainLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(PRTerrainLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
