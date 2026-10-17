cmake_minimum_required(VERSION 3.20)

set(GAME_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")

file(GLOB GAME_CPP CONFIGURE_DEPENDS "${GAME_SRC_DIR}/*.cpp")
list(REMOVE_ITEM GAME_CPP
  "${GAME_SRC_DIR}/main.cpp"
  "${GAME_SRC_DIR}/test.cpp"
)

set(GAME_C "${GAME_SRC_DIR}/minilzo.c")

add_executable(game_srv
  ${GAME_CPP}
  ${GAME_C}
  "${GAME_SRC_DIR}/main.cpp"
)

# SVN version
execute_process(
  COMMAND svnversion -n .
  WORKING_DIRECTORY ${CMAKE_SOURCE_DIR}
  OUTPUT_VARIABLE SVN_VERSION
  OUTPUT_STRIP_TRAILING_WHITESPACE
)
if(SVN_VERSION STREQUAL "")
  set(SVN_VERSION "unknown")
endif()

set_source_files_properties("${GAME_SRC_DIR}/version.cpp" PROPERTIES
  COMPILE_DEFINITIONS
    "__USER__=\\\"$ENV{USER}\\\";__HOSTNAME__=\\\"$ENV{HOSTNAME}\\\";__PWD__=\\\"$ENV{PWD}\\\";__SVN_VERSION__=\\\"${SVN_VERSION}\\\""
)

target_include_directories(game_srv PRIVATE
  "${GAME_SRC_DIR}"
  "${CMAKE_SOURCE_DIR}/liblua/include"
  "${ENTRYCORE_CRYPTOPP_INCLUDE_DIR}"
  "${ENTRYCORE_MYSQL_INCLUDE_DIR}"
  "/usr/local/include"
)

target_compile_options(game_srv PRIVATE 
    -Wall -pipe -fexceptions
    $<$<CONFIG:Debug>:-g3 -O0 -ggdb> 
    $<$<CONFIG:Release>:-O2>
)
target_compile_definitions(game_srv PRIVATE
  _THREAD_SAFE
  CRYPTOPP_DISABLE_ASM
  CRYPTOPP_DISABLE_FASTCALL
)

# Linkowanie do archiwów z build/lib
set(ENTRYCORE_LIBDIR "${CMAKE_BINARY_DIR}/lib")
target_link_directories(game_srv PRIVATE /usr/local/lib/mysql /usr/local/lib)

target_link_libraries(game_srv PRIVATE
  "${ENTRYCORE_LIBDIR}/libthecore.a"
  "${ENTRYCORE_LIBDIR}/libpoly.a"
  "${ENTRYCORE_LIBDIR}/liblua.a"
  "${ENTRYCORE_LIBDIR}/liblualib.a"
  "${ENTRYCORE_LIBDIR}/libsql.a"
  "${ENTRYCORE_LIBDIR}/libgame.a"
  "${ENTRYCORE_MYSQL_CLIENT_LIBRARY}"
  "${ENTRYCORE_CRYPTOPP_LIBRARY}"

  # system
  pthread m md

  # DevIL
  IL
  ILU
  ssl crypto z
)

set_target_properties(game_srv PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${CMAKE_BINARY_DIR}/bin"
  RUNTIME_OUTPUT_DIRECTORY "${ENTRYCORE_RUNTIME_DIR}"
  OUTPUT_NAME "game"
)
