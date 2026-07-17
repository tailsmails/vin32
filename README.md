# Vin32

A basic, heuristic-based CLI tool to generate V language bindings from simple Windows C header files.

---

## About
`vin32` is a line-by-line parsing utility written in V that helps generate basic V language bindings from Windows API headers (such as `windef.h`, `winuser.h`, etc.). 

Since it does not use a full AST parser or a C preprocessor (like Clang/LLVM), it relies on string-matching heuristics. It is designed to quickly bootstrap simple Win32 bindings, structures, and constants, though some generated parts may require manual adjustment.

---

## Features
- **Heuristic Parsing:** Iterates through sorted `.h` files to find struct declarations, flat typedefs, and function signatures.
- **Basic Type Mapping:** Translates common Win32 types (like `DWORD`, `LPVOID`, `HWND`) to V equivalents (`u32`, `voidptr`, etc.) using a static map.
- **Macro Constant Extraction:** Identifies simple numeric, hexadecimal, and string `#define` statements and converts them to `pub const`.
- **Reserved Keyword Safety:** Automatically prefixes fields that clash with V's reserved keywords (such as `type`) with `v_` to prevent syntax errors.
- **Configurable CLI:** Allows specifying the input directory, output path, and module name via command-line flags.

---

## Usage

### Prerequisites
- [V Programming Language](https://vlang.io/) installed.

### Command Line Options
```text
Usage: vin32 [flags]

Flags:
  -i, --input <string>      Path to the directory containing C headers
  -o, --output <string>     Path to the output V file (default: win32.v)
  -m, --module <string>     V module name (default: win32)
  -h, --help                Prints help information
```

### Example
To compile and run the tool against a folder of headers:

```bash
v cmd/vin32.v
./vin32 -i /path/to/mingw/include -o win32.v -m win32
```

---

## Known Limitations

This utility is a line-by-line text parser and has several limitations that may require manual post-processing of the generated code:

- **No C Preprocessor:** It does not resolve conditional compilation (`#ifdef`, `#ifndef`). Code inside inactive or active preprocessor blocks is parsed indiscriminately.
- **Unresolved Types to `voidptr`:** Any C type or structure pointer not found in the static mapping or not yet processed will fall back to `voidptr` to ensure the generated code compiles.
- **Flattened Unions:** C `union` blocks are currently flattened into standard V `struct` definitions. This changes the memory layout size and offsets, which can cause silent runtime crashes when passed to Windows APIs. Users must manually add the `[union]` attribute where necessary.
- **Empty Structs:** Structs with complex nested declarations, inline macro functions, or unrecognized syntax may be parsed with empty fields.
- **Function Pointers:** Complex function pointers (such as `typedef void (*WNDPROC)(...)`) are skipped or simplified.

---

## Contributing
If you find a common Win32 pattern that isn't parsed correctly, feel free to open an issue or submit a pull request with the C code snippet and the expected V translation.

---

## License
![License](https://img.shields.io/badge/License-MIT-green.svg)
