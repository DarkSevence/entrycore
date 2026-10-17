project(UserInterface LANGUAGES CXX)

file(GLOB_RECURSE UI_SOURCES CONFIGURE_DEPENDS
    "*.cpp" 
    "*.c"
)
file(GLOB_RECURSE UI_HEADERS CONFIGURE_DEPENDS
    "*.h" 
    "*.hpp"
)

set(UI_RESOURCES "UserInterface.rc")

add_executable(UserInterface WIN32
    ${UI_SOURCES}
    ${UI_HEADERS}
    ${UI_RESOURCES}
)

target_include_directories(UserInterface PRIVATE
    ${CMAKE_CURRENT_SOURCE_DIR}
)

target_compile_definitions(UserInterface PRIVATE
    "$<$<OR:$<CONFIG:Debug>,$<BOOL:${ENTRYCORE_DIAGNOSTIC_CONSOLE}>>:ENTRYCORE_DIAGNOSTIC_CONSOLE>"
)
target_precompile_headers(UserInterface PRIVATE
    "${CMAKE_CURRENT_SOURCE_DIR}/StdAfx.h"
)
target_link_libraries(UserInterface PRIVATE
    EffectLib
    eterBase
    EterGrnLib
    EterImageLib
    EterLib
    EterLocale
    EterPack
    EterPythonLib
    GameLib
    AudioLib
    PRTerrainLib
    ScriptLib
    SpeedTreeLib
    SphereLib
    third_party
    version
    imagehlp
    winmm
    imm32
    oldnames
    ws2_32
    strmiids
    ddraw
    dmoguids
)
if(MSVC)
    target_link_options(UserInterface PRIVATE /MAP)
endif()
if(CMAKE_SIZEOF_VOID_P EQUAL 8)
    target_compile_definitions(UserInterface PRIVATE NANOBEGIN= NANOEND= IL_STATIC_LIB)
endif()
set_target_properties(UserInterface PROPERTIES
    FOLDER ""
    OUTPUT_NAME EntryCore
    RUNTIME_OUTPUT_DIRECTORY "${ENTRYCORE_CLIENT_RUNTIME_DIR}"
)

set(ENTRYCORE_PYTHON_DLL "${ENTRYCORE_THIRD_PARTY_DIR}/python/bin/${ENTRYCORE_CLIENT_ARCH}/python27.dll")
foreach(runtime_dll IN ITEMS
  "${ENTRYCORE_PYTHON_DLL}"
  "${ENTRYCORE_DX9_DIR}/d3dx/build/native/release/bin/${ENTRYCORE_DX9_ARCH}/D3DX9_43.dll"
)
  if(EXISTS "${runtime_dll}")
    add_custom_command(TARGET UserInterface POST_BUILD
      COMMAND "${CMAKE_COMMAND}" -E copy_if_different
        "${runtime_dll}" "$<TARGET_FILE_DIR:UserInterface>"
    )
  endif()
endforeach()

add_custom_command(TARGET UserInterface POST_BUILD
  COMMAND "${CMAKE_COMMAND}" -E copy_if_different
    "$<TARGET_FILE:SpeedTreeRT>" "$<TARGET_FILE_DIR:UserInterface>"
)

set(CLIENT_RUNTIME_DIR "" CACHE PATH "Optional directory for a runnable client copy")
if(CLIENT_RUNTIME_DIR AND EXISTS "${CLIENT_RUNTIME_DIR}")
    add_custom_command(TARGET UserInterface POST_BUILD
        COMMAND "${CMAKE_COMMAND}" -E copy_if_different
            "$<TARGET_FILE:UserInterface>"
            "${CLIENT_RUNTIME_DIR}/$<TARGET_FILE_NAME:UserInterface>"
    )
endif()
