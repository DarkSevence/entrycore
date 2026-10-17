cmake_minimum_required(VERSION 3.20)

add_library(sql STATIC
  AsyncSQL.cpp
  Semaphore.cpp
  Statement.cpp
  Tellwait.cpp
)

target_compile_features(sql PUBLIC cxx_std_23)
target_compile_options(sql PRIVATE -Wall)

target_include_directories(sql PUBLIC
  ${CMAKE_CURRENT_SOURCE_DIR}
  ${ENTRYCORE_MYSQL_INCLUDE_DIR}
  /usr/local/include/mysql
  /usr/local/include
  /usr/local/include/mariadb
)

find_package(Threads REQUIRED)
target_link_libraries(sql PUBLIC Threads::Threads)

if(ENTRYCORE_MYSQL_CLIENT_LIBRARY)
  target_link_libraries(sql PUBLIC ${ENTRYCORE_MYSQL_CLIENT_LIBRARY})
else()
  find_library(MYSQL_CLIENT_LIB NAMES mariadb mysqlclient PATHS /usr/local/lib /usr/local/lib/mysql /usr/local/lib/mariadb)
  if(MYSQL_CLIENT_LIB)
    target_link_libraries(sql PUBLIC ${MYSQL_CLIENT_LIB})
  endif()
endif()
