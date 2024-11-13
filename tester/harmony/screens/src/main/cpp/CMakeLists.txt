cmake_minimum_required(VERSION 3.13)
set(CMAKE_VERBOSE_MAKEFILE on)

file(GLOB_RECURSE rnoh_screens_SRC CONFIGURE_DEPENDS *.cpp)

add_library(rnoh_screens SHARED ${rnoh_screens_SRC})
target_include_directories(rnoh_screens PUBLIC ${CMAKE_CURRENT_SOURCE_DIR})
target_link_libraries(rnoh_screens PUBLIC rnoh)
