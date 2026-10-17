project(SpeedTreeLib LANGUAGES CXX)

file(GLOB_RECURSE SPEEDTREELIB_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE SPEEDTREELIB_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(SpeedTreeLib STATIC
  ${SPEEDTREELIB_SOURCES}
  ${SPEEDTREELIB_HEADERS}
)

target_link_libraries(SpeedTreeLib PUBLIC third_party SpeedTreeRT)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(SpeedTreeLib PRIVATE NANOBEGIN= NANOEND=)
endif()

target_include_directories(SpeedTreeLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(SpeedTreeLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
