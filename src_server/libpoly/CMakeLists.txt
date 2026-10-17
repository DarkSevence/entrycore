cmake_minimum_required(VERSION 3.20)

add_library(poly STATIC
  Base.cc
  Poly.cc
  SymTable.cc
  Symbol.cc
)

target_compile_features(poly PUBLIC cxx_std_23)

target_compile_options(poly PRIVATE
  -Wall
  -O2
  -pipe
  -fno-exceptions
  -fno-rtti
)


set_target_properties(poly PROPERTIES OUTPUT_NAME "poly")
