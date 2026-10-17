project(EterPythonLib LANGUAGES CXX)

file(GLOB_RECURSE ETERPYTHON_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE ETERPYTHON_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(EterPythonLib STATIC
  ${ETERPYTHON_SOURCES}
  ${ETERPYTHON_HEADERS}
)

target_link_libraries(EterPythonLib PUBLIC third_party)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>")


target_include_directories(EterPythonLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(EterPythonLib PROPERTIES
	FOLDER ""
  ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>"
)
