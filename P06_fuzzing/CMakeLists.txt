cmake_minimum_required(VERSION 2.8)

project(fuzzing-example)

set(CMAKE_C_COMPILER "/usr/bin/clang")
set(CMAKE_C_FLAGS "${CMAKE_C_FLAGS} -std=c11 -Wall -Wextra")

add_library(sanitizer INTERFACE)
target_include_directories(sanitizer INTERFACE ${CMAKE_CURRENT_SOURCE_DIR})

add_executable(main main.c sanitizer.c)
target_link_libraries(main sanitizer)

enable_testing()
add_subdirectory(tests)
