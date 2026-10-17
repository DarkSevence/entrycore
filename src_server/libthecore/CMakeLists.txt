cmake_minimum_required(VERSION 3.20)

project(thecore LANGUAGES CXX ASM)

set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)

file(GLOB THECORE_SRC
  "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
)

file(GLOB THECORE_HDR
  "${CMAKE_CURRENT_SOURCE_DIR}/include/*.h"
)

add_library(thecore STATIC
  ${THECORE_SRC}
  ${THECORE_HDR}
)


# Klucz: traktuj .c jako C++ (bo masz LPBUFFER& itd.)
set_source_files_properties(${THECORE_SRC} PROPERTIES LANGUAGE CXX)

target_include_directories(thecore PRIVATE
  "${CMAKE_CURRENT_SOURCE_DIR}/src"
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_compile_options(thecore PRIVATE
  -Wall
  -O2
    -Wno-invalid-source-encoding
    -Wno-format-security
    -Wno-deprecated-volatile
    -Wno-uninitialized  
)

# Jeśli Twój kod ma własne memcpy i kompilator robi builtin, bywa potrzebne:
# target_compile_options(thecore PRIVATE -fno-builtin-memcpy)

target_link_libraries(thecore PRIVATE m)

find_package(Threads REQUIRED)
target_link_libraries(thecore PUBLIC m Threads::Threads)
