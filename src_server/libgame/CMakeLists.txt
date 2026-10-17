file(GLOB LIBGAME_SOURCES CONFIGURE_DEPENDS
    "${CMAKE_CURRENT_SOURCE_DIR}/src/*.cc"
)

add_library(game STATIC ${LIBGAME_SOURCES})

target_include_directories(game
    PUBLIC
        ${CMAKE_CURRENT_SOURCE_DIR}/include
)
