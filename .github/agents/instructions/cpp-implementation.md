# C++ Implementation Instructions

## Project Structure

All C++ source files must be placed in the `code/` directory:
- `code/main.cpp` - main entry point
- `code/*.hpp` - header files with class declarations
- `code/*.cpp` - implementation files

## Language Standards

- **C++23** standard (use `/std:c++latest` in Visual Studio)
- Use `#pragma once` at the top of all `.hpp` files
- Follow standard C++ conventions:
  - **PascalCase** for classes and types
  - **camelCase** for functions and methods
  - **snake_case** for variables
  - **UPPER_CASE** for constants

## Code Formatting

- **Indentation**: 2 spaces
- **Spacing**: Minimal, clean spacing between logical blocks
- **Braces**: Opening brace on same line for functions/classes
- **Includes**: Group by standard library, third-party, then project headers

## Build System (CMake)

Update `CMakeLists.txt` if explicit listing is required:

```cmake
set(SOURCES
   code/main.cpp
   code/MyClass.cpp
   code/MyClass.hpp
)
add_executable(lab ${SOURCES})
```

## Build Commands

### Configure and Build
```bash
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
```

### Run
```bash
build\lab.exe
```

### Run Tests
```bash
ctest --test-dir build -C Release --output-on-failure
```

### IDE Support
- **Visual Studio**: Open folder, IDE detects `CMakeLists.txt`
- **VS Code**: Install CMake Tools extension, configure and build via UI

## Error Handling

- Use basic exception handling with `try-catch` blocks
- Validate inputs at function entry points
- Throw `std::invalid_argument`, `std::runtime_error`, etc. for errors
- Use `noexcept` for functions that guarantee no exceptions

## Standard Library Usage

Prefer standard library over manual implementations:
- `std::vector`, `std::string`, `std::array` for containers
- `std::unique_ptr`, `std::shared_ptr` for memory management
- `std::optional` for optional values
- `std::variant` for type-safe unions
- `<algorithm>`, `<ranges>` for data processing

## Example Structure

```cpp
// code/MyClass.hpp
#pragma once
#include <string>

class MyClass {
public:
  MyClass(int value);
  void process();
  int getValue() const;

private:
  int m_value;
};
```

```cpp
// code/MyClass.cpp
#include "MyClass.hpp"
#include <iostream>

MyClass::MyClass(int value) : m_value(value) {
  // Constructor implementation
}

void MyClass::process() {
  std::cout << "Обработка значения: " << m_value << std::endl;
}

int MyClass::getValue() const {
  return m_value;
}
```

```cpp
// code/main.cpp
#include "MyClass.hpp"
#include <iostream>

int main() {
  try {
    MyClass obj(42);
    obj.process();
    return 0;
  } catch (const std::exception& e) {
    std::cerr << "Ошибка: " << e.what() << std::endl;
    return 1;
  }
}
```

## Documentation for Reports

When creating Typst reports, reference code files:

```typst
#figure(
  raw(read("../code/main.cpp"), lang: "cpp", block: true),
  caption: [Исходный файл main.cpp],
) <file-main>
```

Reference with `@file-main` in text.
