project(SphereLib LANGUAGES CXX)

file(GLOB_RECURSE SPHERELIB_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE SPHERELIB_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(SphereLib STATIC
  ${SPHERELIB_SOURCES}
  ${SPHERELIB_HEADERS}
)

target_link_libraries(SphereLib PUBLIC third_party)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(SphereLib PRIVATE NANOBEGIN= NANOEND=)
endif()

target_include_directories(SphereLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(SphereLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
