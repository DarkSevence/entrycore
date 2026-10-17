project(EterPack LANGUAGES CXX)

file(GLOB_RECURSE ETERPACK_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE ETERPACK_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(EterPack STATIC
  ${ETERPACK_SOURCES}
  ${ETERPACK_HEADERS}
)

target_link_libraries(EterPack PUBLIC third_party)


target_include_directories(EterPack PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(EterPack PROPERTIES
	FOLDER ""
)
