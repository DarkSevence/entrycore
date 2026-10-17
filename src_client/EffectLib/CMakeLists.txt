project(EffectLib LANGUAGES CXX)

# --- output layout ---
set(ENTRYCORE_OUT_DIR "${CMAKE_BINARY_DIR}/lib")   

# Wszystkie biblioteki statyczne .lib/.a
set(CMAKE_ARCHIVE_OUTPUT_DIRECTORY "${ENTRYCORE_OUT_DIR}/$<CONFIG>")

# Jeœli kiedyœ bêdziesz mia³ .dll/.exe (nie musisz teraz)
set(CMAKE_LIBRARY_OUTPUT_DIRECTORY "${ENTRYCORE_CLIENT_RUNTIME_DIR}")
set(CMAKE_RUNTIME_OUTPUT_DIRECTORY "${ENTRYCORE_CLIENT_RUNTIME_DIR}")

file(GLOB_RECURSE EFFECTLIB_SOURCES CONFIGURE_DEPENDS
  "*.cpp" "*.c"
)
file(GLOB_RECURSE EFFECTLIB_HEADERS CONFIGURE_DEPENDS
  "*.h" "*.hpp"
)

add_library(EffectLib STATIC
  ${EFFECTLIB_SOURCES}
  ${EFFECTLIB_HEADERS}
)

target_link_libraries(EffectLib PUBLIC third_party)
set_target_properties(EffectLib PROPERTIES
	FOLDER ""
)
