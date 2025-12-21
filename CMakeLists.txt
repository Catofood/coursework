cmake_minimum_required(VERSION 3.20)
project(lab LANGUAGES CXX)

# C++23
set(CMAKE_CXX_STANDARD 23)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS OFF)

# Enable folders in IDEs
set_property(GLOBAL PROPERTY USE_FOLDERS ON)

# Main executable
set(SOURCES
  src/main.cpp
  src/B1.cpp
  src/B1.hpp
  src/B2.cpp
  src/B2.hpp
  src/D1.cpp
  src/D1.hpp
  src/D2.cpp
  src/D2.hpp
  src/D3.cpp
  src/D3.hpp
)
add_executable(lab ${SOURCES})

# Example: add tests (uncomment / extend as needed)
# enable_testing()
# add_executable(sample_test tests/sample_test.cpp)
# add_test(NAME sample_test COMMAND sample_test)

# Recommended warning flags
if (MSVC)
  target_compile_options(lab PRIVATE /W4 /permissive- /EHsc)
else()
  target_compile_options(lab PRIVATE -Wall -Wextra -Wpedantic)
endif()
