# Agent Guidelines for Lab Template

This document provides technical guidelines for GitHub Copilot agents working with this lab template.

## Supported Programming Languages

**Choose ONE language per lab work:**
- **C++** (C++23, CMake build system)
- **C#** (.NET 8+, dotnet CLI)

❌ Mixing languages in a single project is not supported.

## Custom Agents

Custom agents are located in `.github/agents/` directory. See agent files for detailed instructions.

Available agents:
- **Verificator** - Task verification from methodology PDF, determines programming language
- **Coder** - C++ or C# implementation (one language per project)
- **QA** - Testing and quality assurance for chosen language
- **Writer** - Typst report generation with code listings
- **Orchestrator** - Workflow coordination

## Build Commands

### C++ (CMake)
```
cmake -S . -B build -DCMAKE_BUILD_TYPE=Release
cmake --build build --config Release
build\lab.exe
ctest --test-dir build -C Release --output-on-failure
```

### C# (.NET)
From project root:
```
dotnet build code/Lab.csproj -c Release
dotnet run --project code/Lab.csproj -c Release
dotnet test tests/Tests.csproj -c Release
```

Or from code/ directory:
```
cd code
dotnet build -c Release
dotnet run -c Release
cd ..
```

### Documentation (Both)
```
typst compile docs/index.typ build/index.pdf
```

## Code Style Guidelines

### C++
- **Language**: C++23 standard (use `/std:c++latest` in Visual Studio)
- **Platform**: Visual Studio Community 2022+ or compatible C++ compiler
- **Imports**: Use standard library headers (`<iostream>`, etc.)
- **Naming**: Standard C++ conventions (snake_case for variables/functions, PascalCase for types)
- **Formatting**: 2-space indentation, minimal spacing
- **Error Handling**: Basic exception handling where needed, validate inputs
- **Documentation**: Use Typst for reports, embed code with `#raw(read("../code/main.cpp"), lang: "cpp")`

### C#
- **Language**: .NET 8+ (latest LTS)
- **Platform**: .NET SDK installed
- **Imports**: Use `using` directives
- **Naming**: PascalCase for public members, camelCase for local/private
- **Formatting**: 4-space indentation (C# standard)
- **Error Handling**: Use exceptions, validate inputs
- **Documentation**: Use Typst for reports, embed code with `#raw(read("../code/Program.cs"), lang: "csharp")`

## Academic Requirements
- Implement assigned variant from methodology document
- Generate control examples covering all execution paths
- Handle edge cases (overflow, empty structures)
- Create comprehensive Typst report with figures and captions
- Save screenshots in `images/` directory with sequential numbering

## PDF Extraction
When agents need to read methodology PDF files, use:
```
pdftotext -layout "filename.pdf" -
```
- `-layout`: preserves text structure and spacing from PDF
- `-`: outputs to stdout for direct reading
- Requires poppler-utils (install via `winget install pdftotext` on Windows)

## Document Formatting (Typst)
- Main file: `docs/index.typ`. Use provided `lib/` for ГОСТ-like layout.
- Title page: fill all fields (title, authors, teachers, date, education, department, position, documentName, group, city, object).
- Navigation/TOC: if methodology says "no contents", disable it with `#show: doc => init(doc, hasContentNavigationPage: false)`.
- Inline backticks in .typ are allowed for short inline code; they render inline with monospace only. Use `#figure(raw(...), block: true)` for multi-line listings.
- Structure (recommended):
	1) Введение (цель, задачи)
	2) Постановка задачи (вариант, требования)
	3) Описание алгоритма (структуры данных, схема/шаги)
	4) Реализация (listings via `#raw(read("../code/<file>"), lang: "cpp"` or `lang: "csharp"`, `block: true)`)
	5) Тестирование (table with Input / Expected / Actual; all branches covered)
	6) Скриншоты (figures from `images/` with clear, scenario-based captions)
	7) Выводы (results, improvements)
- Captions: each `#figure` caption must describe the exact scenario (input, result, and note like "midnight rollover" or "validation error"). Keep numbering consistent with the test table.
- Images: store under `images/` with sequential names (e.g., `Screenshot_1.png` or `001_time_scenarios.png`). Reference with `image("../images/<name>")`.
- **Image insertion responsibility**: When an agent is responsible for adding images to the report, it should ONLY create the figure placeholder with proper syntax and caption — do NOT attempt to generate or create the actual image files. The user will add image files to `images/` directory manually. Agent's job: format the `#figure(image("../images/<filename>"), caption: [...])` block with appropriate descriptions.
- Sources/References: include only if methodology requires. If stated "no sources", omit the section entirely.
- File naming (final report): follow the methodology pattern, e.g., `Группа_ФИО_ЛР1.pdf`.

### Writer Agent Detailed Style (from `demo.typ`)
- Title page: replicate parameter usage (`title`, `authors`, `teachers`, etc.).
- TOC control: `#show: doc => init(doc, hasContentNavigationPage: true)` or disable via `false` per task.
- Code listings: 
  * C++: `#figure(raw(read("../code/main.cpp"), lang: "cpp", block: true), caption: [...])` with anchor `<file-main>`
  * C#: `#figure(raw(read("../code/Program.cs"), lang: "csharp", block: true), caption: [...])` with anchor `<file-program>`
  * Reference via `@file-main` or `@file-program`
- Fenced examples: optional ` ```cpp ... ``` ` or ` ```csharp ... ``` ` inside `#figure` for illustrative snippets.
- Tables: wrap in `#figure(table(...), caption: [...])` and anchor `<tab-*>`; reference with `@tab-...`.
- Images: only placeholders `#figure(image("../images/<name>.png"), caption: [...])`; do not fabricate files.
- Captions: include scenario (input/state), expected effect, special condition (e.g. overflow, boundary).
- Sources section: reproduce structured call similar to `#sourcesSection(...)` only when required.
- Math: use provided math helper macros if needed (`#math-equation`).
- Inline backticks are allowed for short code; prefer `#figure(raw(...))` for longer listings.
- Testing section: table with columns: Case / Input / Expected / Actual / Note (or per methodology).
- Consistent anchors: `<example-code>`, `<fig-diagram>`, etc., referenced as `@example-code`.

## Report Build
- Build PDF: `typst compile docs/index.typ build/index.pdf`
- The PDF will be generated in the `build/` directory
- Ensure Typst is installed: `winget install --id Typst.Typst`

## Project Structure
```
lab/
├── .github/agents/     # Custom Copilot agents
├── code/               # Source code (C++ or C# - only ONE language)
│   ├── *.cpp, *.hpp    # C++ files (if C++ project)
│   ├── *.cs            # C# files (if C# project)
│   ├── Lab.csproj      # C# project file (if C# project)
│   └── Lab.sln         # C# solution file (optional, if C# project)
├── tests/              # Test files (created by QA agent)
├── docs/               # Typst documentation
│   ├── index.typ       # Main report
│   ├── examples/       # Report examples
│   └── lib/            # ГОСТ formatting libraries
├── images/             # Screenshots for reports
├── build/              # Build artifacts (executables, PDFs)
└── CMakeLists.txt      # For C++ projects only
```