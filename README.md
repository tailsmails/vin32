# Vin32

A lightweight, dependency-free tool to automatically generate V language bindings from Windows C header files.

---

## About
`vin32` is a utility written in V that parses Windows API headers (`windef.h`, `winuser.h`, `winbase.h` and etc.) and translates C definitions, structures, and constants into clean, idiomatic V code.

This tool is designed to be a "helper" for developers who need a quick, no-nonsense way to bootstrap Windows API bindings in V without complex LLVM/Clang setups.

---

## Features
- **Header Parsing:** Automatically reads and parses `windef.h`, `winuser.h`, and `winbase.h` and any header else.
- **Type Mapping:** Converts common C types (e.g., `DWORD`, `LPVOID`, `HWND`) to their V equivalents (`u32`, `voidptr`, etc.).
- **Struct Conversion:** Extracts struct fields and maps them into V `struct` definitions.
- **Constant Extraction:** Converts `#define` macros into `pub const` definitions in V, including handling of hex/numeric literals.
- **Cleanup:** Automatically strips C comments, SAL annotations (`_In_`, `_Out_`, etc.), and handles macro cleanup.
- **Lightweight:** Zero external dependencies. It's written in pure V and runs as a standalone script.

---

## Usage

### Prerequisites
- [V Programming Language](https://vlang.io/) installed.

### How to use
1. Clone this repository or copy the `vin32.v` script.
2. Ensure you have the target Windows header files (e.g., from the Windows SDK or MinGW) in a directory.
3. Run the script pointing to the directory containing the header files:

```bash
v run vin32.v /path/to/your/headers
```

4. The script will generate a `win32.v` file in your current directory.

---

## Important Notes
- **Best-Effort Generation:** This tool is a parser, not a full preprocessor. While it handles most common patterns, highly complex nested macros or conditional code (`#ifdef`) might require manual adjustment.
- **Manual Review:** Always review the generated `win32.v` file. You may need to manually add `#flag` directives to link against Windows libraries (e.g., `#flag windows -luser32`).
- **Type Safety:** Some types are mapped to `voidptr` to ensure broad compatibility. You may want to refine specific function signatures for better type safety in your final project.

---

## Contributing
Contributions are welcome! If you encounter a header pattern that isn't parsed correctly, feel free to open an issue or submit a pull request with an example of the C code that failed to convert.

---

## License
![License](https://img.shields.io/badge/License-MIT-green.svg)
