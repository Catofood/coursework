# C# Implementation Instructions

## Project Structure

All C# project files must be placed in the `code/` directory:
- `code/Lab.csproj` - project file
- `code/Program.cs` - main entry point
- `code/*.cs` - additional source files
- `code/Lab.sln` - solution file (optional)

## Language Standards

- **.NET 8+** (latest LTS version preferred)
- Follow C# naming conventions:
  - **PascalCase** for classes, methods, properties, and public members
  - **camelCase** for local variables and parameters
  - **_camelCase** for private fields (with leading underscore)
  - **UPPER_CASE** for constants

## Code Formatting

- **Indentation**: 4 spaces (C# standard)
- **Braces**: Opening brace on new line (Allman style)
- **Using directives**: At top of file, sorted alphabetically
- **Namespace**: Use file-scoped namespace (C# 10+): `namespace MyNamespace;`

## Project Setup

### Creating New Project

```bash
cd code
dotnet new console -n Lab
```

This creates:
- `code/Lab.csproj`
- `code/Program.cs`

### Project File (code/Lab.csproj)

```xml
<Project Sdk="Microsoft.NET.Sdk">
  <PropertyGroup>
    <OutputType>Exe</OutputType>
    <TargetFramework>net8.0</TargetFramework>
    <Nullable>enable</Nullable>
    <ImplicitUsings>enable</ImplicitUsings>
  </PropertyGroup>
</Project>
```

## Build Commands

### From Project Root
```bash
dotnet build code/Lab.csproj -c Release
dotnet run --project code/Lab.csproj -c Release
```

### From code/ Directory
```bash
cd code
dotnet build -c Release
dotnet run -c Release
cd ..
```

### Run Tests (if test project exists)
```bash
dotnet test tests/Tests.csproj -c Release
```

### IDE Support
- **Visual Studio**: Open `code/Lab.csproj` or `code/Lab.sln`
- **VS Code**: Install C# Dev Kit extension, open workspace
- **Rider**: Open `code/Lab.csproj` or `code/Lab.sln`

## Error Handling

- Use exceptions for error handling
- Validate inputs and throw `ArgumentException`, `ArgumentNullException`, etc.
- Use `try-catch` blocks for expected exceptions
- Consider nullable reference types (`string?` for nullable strings)

## Modern C# Features

Use modern C# features where appropriate:
- **File-scoped namespaces**: `namespace MyApp;`
- **Top-level statements**: Simplify `Program.cs`
- **Pattern matching**: `if (obj is MyClass { Value: > 0 })`
- **Records**: `record Person(string Name, int Age);`
- **Init-only properties**: `public int Value { get; init; }`
- **Nullable reference types**: Enable in `.csproj`

## Standard Library Usage

Prefer .NET standard library:
- `List<T>`, `Dictionary<TKey, TValue>` for collections
- `LINQ` for data queries and transformations
- `System.IO` for file operations
- `System.Text.Json` for JSON serialization
- `HttpClient` for HTTP requests

## Example Structure

### Simple Program (code/Program.cs)

```csharp
using System;

namespace Lab;

class Program
{
    static void Main(string[] args)
    {
        try
        {
            var processor = new DataProcessor(42);
            processor.Process();
        }
        catch (Exception ex)
        {
            Console.WriteLine($"Ошибка: {ex.Message}");
        }
    }
}
```

### Class File (code/DataProcessor.cs)

```csharp
using System;

namespace Lab;

/// <summary>
/// Класс для обработки данных
/// </summary>
public class DataProcessor
{
    private readonly int _value;

    /// <summary>
    /// Создаёт новый экземпляр процессора
    /// </summary>
    /// <param name="value">Значение для обработки</param>
    public DataProcessor(int value)
    {
        if (value < 0)
            throw new ArgumentException("Значение не может быть отрицательным", nameof(value));
        
        _value = value;
    }

    /// <summary>
    /// Обрабатывает данные
    /// </summary>
    public void Process()
    {
        Console.WriteLine($"Обработка значения: {_value}");
    }

    /// <summary>
    /// Получает текущее значение
    /// </summary>
    public int Value => _value;
}
```

### Modern Style with Top-Level Statements (code/Program.cs)

```csharp
using Lab;

try
{
    var processor = new DataProcessor(42);
    processor.Process();
}
catch (Exception ex)
{
    Console.WriteLine($"Ошибка: {ex.Message}");
    return 1;
}

return 0;
```

## Output and Localization

All console output must be in **Russian** unless specified otherwise:

```csharp
Console.WriteLine("Введите значение:");
Console.WriteLine($"Результат: {result}");
Console.WriteLine("Ошибка: некорректный ввод");
```

## Documentation for Reports

When creating Typst reports, reference code files:

```typst
#figure(
  raw(read("../code/Program.cs"), lang: "csharp", block: true),
  caption: [Исходный файл Program.cs],
) <file-program>
```

Reference with `@file-program` in text.

## NuGet Packages

Add packages if needed:

```bash
cd code
dotnet add package Newtonsoft.Json
dotnet add package System.CommandLine
cd ..
```

Packages are automatically added to `Lab.csproj`:

```xml
<ItemGroup>
  <PackageReference Include="Newtonsoft.Json" Version="13.0.3" />
</ItemGroup>
```
