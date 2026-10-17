project(EterImageLib LANGUAGES CXX)

file(GLOB_RECURSE ETERIMAGE_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE ETERIMAGE_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(EterImageLib STATIC
  ${ETERIMAGE_SOURCES}
  ${ETERIMAGE_HEADERS}
)
target_link_libraries(EterImageLib PUBLIC third_party)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>")

target_include_directories(EterImageLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(EterImageLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
