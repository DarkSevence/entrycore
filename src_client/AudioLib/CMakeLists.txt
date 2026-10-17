project(AudioLib LANGUAGES CXX)

file(GLOB_RECURSE AudioLib_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE AudioLib_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(AudioLib STATIC
  ${AudioLib_SOURCES}
  ${AudioLib_HEADERS}
)

target_link_libraries(AudioLib PUBLIC third_party)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>")

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(AudioLib PRIVATE NANOBEGIN= NANOEND=)
endif()


target_include_directories(AudioLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(AudioLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
