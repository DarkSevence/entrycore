project(EterGrnLib LANGUAGES CXX)

set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/lib/$<CONFIG>")

file(GLOB_RECURSE ETERGRN_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE ETERGRN_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(EterGrnLib STATIC
  ${ETERGRN_SOURCES}
  ${ETERGRN_HEADERS}
)
target_link_libraries(EterGrnLib PUBLIC third_party)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(EterGrnLib PRIVATE NANOBEGIN= NANOEND=)
endif()

target_include_directories(EterGrnLib PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
)

set_target_properties(EterGrnLib PROPERTIES
	FOLDER ""
)
