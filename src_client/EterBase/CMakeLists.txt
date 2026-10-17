project(eterBase LANGUAGES CXX)

# --- output layout ---
set(ENTRYCORE_OUT_DIR "${CMAKE_BINARY_DIR}/lib")   

# Wszystkie biblioteki statyczne .lib/.a
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${ENTRYCORE_OUT_DIR}/$<CONFIG>")

# Jeśli kiedyś będziesz miał .dll/.exe (nie musisz teraz)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${ENTRYCORE_CLIENT_RUNTIME_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${ENTRYCORE_CLIENT_RUNTIME_DIR}")

file(GLOB_RECURSE ETERBASE_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE ETERBASE_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(eterBase STATIC
  ${ETERBASE_SOURCES}
  ${ETERBASE_HEADERS}
)

target_link_libraries(eterBase PUBLIC third_party)

target_compile_definitions(eterBase PRIVATE
  "$<$<OR:$<CONFIG:Debug>,$<BOOL:${ENTRYCORE_DIAGNOSTIC_CONSOLE}>>:ENTRYCORE_DIAGNOSTIC_CONSOLE>"
)

if(CMAKE_SIZEOF_VOID_P EQUAL 8)
  target_compile_definitions(eterBase PRIVATE NANOBEGIN= NANOEND=)
endif()

target_include_directories(eterBase PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})

set_target_properties(eterBase PROPERTIES
	FOLDER ""
)
