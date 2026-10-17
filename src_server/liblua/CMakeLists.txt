cmake_minimum_required(VERSION 3.20)
project(lua50 LANGUAGES C)

# Lua 5.0 jest C (historycznie ANSI C). Dajemy bezpieczne minimum.
set(CMAKE_C_STANDARD 90)
set(CMAKE_C_STANDARD_REQUIRED ON)

option(LUA_BUILD_SHARED "Build shared libraries (.so)" OFF)
option(LUA_BUILD_BINARIES "Build lua and luac executables" OFF)
option(LUA_USE_DLOPEN "Enable dynamic module loading (USE_DLOPEN)" ON)
option(LUA_USE_POPEN "Enable popen/pclose (USE_POPEN)" ON)
option(LUA_USE_TMPNAME "Enable tmpnam (USE_TMPNAME)" OFF)
option(LUA_USE_DEGREES "Use degrees in math library (USE_DEGREES)" OFF)

# Źródła (dostosowane do struktury Lua 5.0: src/*.c i src/lib/*.c)
file(GLOB LUA_CORE_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/src/*.c"
)

file(GLOB LUA_LIB_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/src/lib/*.c"
)

# Jeżeli w src są programy (lua/luac) jako osobne pliki, zwykle są w src/lua i src/luac
file(GLOB LUA_INTERP_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/src/lua/*.c"
)

file(GLOB LUAC_SOURCES
  "${CMAKE_CURRENT_SOURCE_DIR}/src/luac/*.c"
)

if(LUA_BUILD_SHARED)
  add_library(lua SHARED ${LUA_CORE_SOURCES})
  add_library(lualib SHARED ${LUA_LIB_SOURCES})
else()
  add_library(lua STATIC ${LUA_CORE_SOURCES})
  add_library(lualib STATIC ${LUA_LIB_SOURCES})
endif()

target_include_directories(lua PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

target_include_directories(lualib PUBLIC
  "${CMAKE_CURRENT_SOURCE_DIR}/include"
)

# Definicje jak w Twoim config
if(LUA_USE_DLOPEN)
  target_compile_definitions(lualib PRIVATE USE_DLOPEN=1)
endif()

if(LUA_USE_POPEN)
  target_compile_definitions(lualib PRIVATE USE_POPEN=1)
else()
  target_compile_definitions(lualib PRIVATE USE_POPEN=0)
endif()

if(LUA_USE_TMPNAME)
  target_compile_definitions(lualib PRIVATE USE_TMPNAME=1)
else()
  target_compile_definitions(lualib PRIVATE USE_TMPNAME=0)
endif()

if(LUA_USE_DEGREES)
  target_compile_definitions(lualib PRIVATE USE_DEGREES=1)
endif()

target_compile_options(lua PRIVATE
  -O2
  -Wno-switch
)

target_compile_options(lualib PRIVATE
  -O2
)


# FreeBSD / Unix: math zwykle wymaga -lm
# Uwaga: na FreeBSD dlopen jest w libc, więc -ldl zwykle NIE jest potrzebne.
target_link_libraries(lualib PRIVATE m)

# Współdzielone biblioteki wymagają PIC
if(LUA_BUILD_SHARED)
  set_target_properties(lua PROPERTIES POSITION_INDEPENDENT_CODE ON)
  set_target_properties(lualib PROPERTIES POSITION_INDEPENDENT_CODE ON)
endif()

# Opcjonalnie: binarki lua/luac
if(LUA_BUILD_BINARIES)
  add_executable(lua_bin ${LUA_INTERP_SOURCES})
  target_link_libraries(lua_bin PRIVATE lua lualib m)
  target_include_directories(lua_bin PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
  set_target_properties(lua_bin PROPERTIES OUTPUT_NAME lua)

  add_executable(luac_bin ${LUAC_SOURCES})
  target_link_libraries(luac_bin PRIVATE lua lualib m)
  target_include_directories(luac_bin PRIVATE "${CMAKE_CURRENT_SOURCE_DIR}/include")
  set_target_properties(luac_bin PROPERTIES OUTPUT_NAME luac)
endif()

# Instalacja (opcjonalnie)
include(GNUInstallDirs)
install(TARGETS lua lualib
  ARCHIVE DESTINATION ${CMAKE_INSTALL_LIBDIR}
  LIBRARY DESTINATION ${CMAKE_INSTALL_LIBDIR}
  RUNTIME DESTINATION ${CMAKE_INSTALL_BINDIR}
)
install(DIRECTORY "${CMAKE_CURRENT_SOURCE_DIR}/include/"
  DESTINATION ${CMAKE_INSTALL_INCLUDEDIR}
  FILES_MATCHING PATTERN "*.h"
)
