cmake_minimum_required(VERSION 3.20)

set(DB_SRC_DIR "${CMAKE_CURRENT_SOURCE_DIR}/src")

file(GLOB DB_CPP CONFIGURE_DEPENDS "${DB_SRC_DIR}/*.cpp")
file(GLOB DB_C   CONFIGURE_DEPENDS "${DB_SRC_DIR}/*.c")

add_executable(db_srv
  ${DB_CPP}
  ${DB_C}
)

target_include_directories(db_srv PRIVATE
  "${DB_SRC_DIR}"
  "${CMAKE_SOURCE_DIR}/Extern/include"
  "${CMAKE_SOURCE_DIR}/Extern/include/boost"
  "${ENTRYCORE_MYSQL_INCLUDE_DIR}"
  "/usr/local/include"
)

target_compile_options(db_srv PRIVATE -Wall -O2 -g3 -pipe -fexceptions)
target_compile_definitions(db_srv PRIVATE _THREAD_SAFE DNDEBUG)
target_link_options(db_srv PRIVATE $<$<CONFIG:Release>:LINKER:-s>)

set(ENTRYCORE_LIBDIR "${CMAKE_BINARY_DIR}/lib")

target_link_libraries(db_srv PRIVATE
  "${ENTRYCORE_LIBDIR}/libthecore.a"
  "${ENTRYCORE_LIBDIR}/libgame.a"
  "${ENTRYCORE_LIBDIR}/libpoly.a"
  "${ENTRYCORE_LIBDIR}/liblua.a"
  "${ENTRYCORE_LIBDIR}/liblualib.a"
  "${ENTRYCORE_LIBDIR}/libsql.a"

  "${ENTRYCORE_MYSQL_CLIENT_LIBRARY}"
  ssl crypto z

  # system
  pthread m md
)

# Output do build/bin
set_target_properties(db_srv PROPERTIES
  RUNTIME_OUTPUT_DIRECTORY "${ENTRYCORE_RUNTIME_DIR}"
  OUTPUT_NAME "db"
)
