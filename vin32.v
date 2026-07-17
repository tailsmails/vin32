import os
import strings

const obsolete_keywords = [
    'FAR', 'NEAR', 'const', 'CONST', 'volatile', '_cdecl', '__cdecl', '__stdcall', 'CDECL', 'extern',
    'WINUSERAPI', 'WINBASEAPI', 'WINAPIV', 'WINAPI', 'CALLBACK', 'WINADVAPI', 
    'WINGDIAPI', 'NTAPI', 'NTSYSAPI', 'WSAAPI', 'WINSOCK_API_LINKAGE', 
    'DECLSPEC_NORETURN', 'DECLSPEC'
]

const c_compiler_conventions = [
    '__clrcall', '__cdecl', '__stdcall', '__fastcall', '__thiscall', '__vectorcall',
    'inline', '__inline', '__forceinline', '__declspec'
]

const ms_suffixes = [
    'ui64', 'UI64', 'i64', 'I64',
    'ui32', 'UI32', 'i32', 'I32',
    'ui16', 'UI16', 'i16', 'I16',
    'ui8', 'UI8', 'i8', 'I8'
]

const c_to_v_types = {
    'unsigned long':  'u32'
    'unsigned int':   'u32'
    'unsigned short': 'u16'
    'unsigned char':  'u8'
    'int':            'int'
    'long':           'i32'
    'short':          'i16'
    'char':           'u8'
    'void':           'void'
    'void*':          'voidptr'
    'float':          'f32'
    'double':         'f64'
    'SHORT':          'i16'
    'USHORT':         'u16'
    'LONG':           'i32'
    'ULONG':          'u32'
    'DWORD':          'u32'
    'WORD':           'u16'
    'BYTE':           'u8'
    'BOOL':           'bool'
    'BOOLEAN':        'bool'
    'VOID':           'void'
    'PVOID':          'voidptr'
    'LPVOID':         'voidptr'
    'LPCVOID':        'voidptr'
    'HWND':           'voidptr'
    'HHOOK':          'voidptr'
    'HICON':          'voidptr'
    'HCURSOR':        'voidptr'
    'HGDIOBJ':        'voidptr'
    'HMENU':          'voidptr'
    'HBRUSH':         'voidptr'
    'HINSTANCE':      'voidptr'
    'HMODULE':        'voidptr'
    'HANDLE':         'voidptr'
    'HDC':            'voidptr'
    'HGLOBAL':        'voidptr'
    'HLOCAL':         'voidptr'
    'WNDPROC':        'voidptr'
    'DLGPROC':        'voidptr'
    'TIMERPROC':      'voidptr'
    'GRAYSTRINGPROC': 'voidptr'
    'WNDENUMPROC':    'voidptr'
    'HOOKPROC':       'voidptr'
    'SENDASYNCPROC':  'voidptr'
    'EDITWORDBREAKPROCA': 'voidptr'
    'EDITWORDBREAKPROCW': 'voidptr'
    'PROPENUMPROCA':  'voidptr'
    'PROPENUMPROCW':  'voidptr'
    'PROPENUMPROCEXA': 'voidptr'
    'PROPENUMPROCEXW': 'voidptr'
    'DRAWSTATEPROC':  'voidptr'
    'NAMEENUMPROCA':  'voidptr'
    'NAMEENUMPROCW':  'voidptr'
    'WINSTAENUMPROCA': 'voidptr'
    'WINSTAENUMPROCW': 'voidptr'
    'DESKTOPENUMPROCA': 'voidptr'
    'DESKTOPENUMPROCW': 'voidptr'
    'LPARAM':         'voidptr'
    'WPARAM':         'voidptr'
    'LRESULT':        'voidptr'
    'ULONG_PTR':      'voidptr'
    'LONG_PTR':       'voidptr'
    'DWORD_PTR':      'voidptr'
    'INT_PTR':        'isize'
    'UINT_PTR':       'voidptr'
    'PROC':           'voidptr'
    'LPCSTR':         '&char'
    'LPSTR':          '&char'
    'LPCWSTR':        '&u16'
    'LPWSTR':         '&u16'
    'UINT':           'u32'
    'INT':            'i32'
    'COLORREF':       'u32'
    'HRESULT':        'i32'
    'GUID':           'voidptr'
    'UCHAR':          'u8'
    'HDESK':          'voidptr'
    'LUID':           'voidptr'
    'BLENDFUNCTION':  'voidptr'
    'UINT16':         'u16'
    'UINT32':         'u32'
    'INT32':          'i32'
    'UINT64':         'u64'
    'DWORD64':        'u64'
    'ULONGLONG':      'u64'
    'ULONG64':        'u64'
    'WCHAR':          'u16'
    'CHAR':           'u8'
    'CCHAR':          'i8'
    'HBITMAP':        'voidptr'
    'LOGFONTA':       'voidptr'
    'LOGFONTW':       'voidptr'
    'LANGID':         'u16'
    'POINTER_DEVICE_TYPE': 'u32'
    'POINTER_DEVICE_CURSOR_TYPE': 'u32'
    'COPYFILE2_MESSAGE_TYPE': 'u32'
    'COPYFILE2_COPY_PHASE': 'u32'
    'PCOPYFILE2_PROGRESS_ROUTINE': 'voidptr'
    'ULARGE_INTEGER': 'u64'
    'LARGE_INTEGER':  'i64'
    'INPUT_MESSAGE_DEVICE_TYPE': 'u32'
    'INPUT_MESSAGE_ORIGIN_ID': 'u32'
    'PFIBER_START_ROUTINE': 'voidptr'
    'PLDT_ENTRY':     'voidptr'
    'SIZE_T':         'usize'
    'HMONITOR':       'voidptr'
    'POINTER_BUTTON_CHANGE_TYPE': 'u32'
    'PRIORITY_HINT':  'u32'
    'FILE_ID_TYPE':   'u32'
    'RTL_UMS_THREAD_INFO_CLASS': 'u32'
    'RTL_UMS_SCHEDULER_REASON': 'u32'
    '_RTL_UMS_THREAD_INFO_CLASS': 'u32'
    '_RTL_UMS_SCHEDULER_REASON': 'u32'
    'REASON_CONTEXT': 'voidptr'
    'LCID':           'u32'
    'ATOM':           'u16'
    'PSID':           'voidptr'
    'PACL':           'voidptr'
    'PSECURITY_DESCRIPTOR': 'voidptr'
    'LPOVERLAPPED':   'voidptr'
    'LPDWORD':        '&u32'
    'PDWORD':         '&u32'
    'LPBOOL':         '&bool'
    'PCWSTR':         '&u16'
    'COPYFILE2_EXTENDED_PARAMETERS': 'voidptr'
    'LPPROGRESS_ROUTINE': 'voidptr'
    'HFILE':          'voidptr'
    'HKL':            'voidptr'
    'HACCEL':         'voidptr'
    'HWINSTA':        'voidptr'
    'HSYNTHETICPOINTERDEVICE': 'voidptr'
    'DPI_AWARENESS':  'u32'
    'DPI_AWARENESS_CONTEXT': 'voidptr'
    'DPI_HOSTING_BEHAVIOR': 'u32'
    'HWINEVENTHOOK':  'voidptr'
    'HRSRC':          'voidptr'
    'PSID_IDENTIFIER_AUTHORITY': 'voidptr'
    'PUCHAR':         '&u8'
    'PSLIST_ENTRY':   'voidptr'
    'PSLIST_HEADER':  'voidptr'
    'PINIT_ONCE':     'voidptr'
    'PINIT_ONCE_FN':  'voidptr'
    'WINEVENTPROC':   'voidptr'
    'POINTER_INPUT_TYPE': 'u32'
    'POINTER_FEEDBACK_MODE': 'u32'
    'ACCESS_MASK':    'u32'
    'LPSECURITY_ATTRIBUTES': 'voidptr'
    'HTOUCHINPUT':    'voidptr'
    'FEEDBACK_TYPE':  'u32'
    'LPCDLGTEMPLATEA': 'voidptr'
    'LPCDLGTEMPLATEW': 'voidptr'
    'PSRWLOCK': 'voidptr'
}

struct ParserState {
mut:
    defined_types     map[string]bool
    defined_structs   map[string]bool
    defined_consts    map[string]bool
    alias_resolutions map[string]string
}

fn is_valid_v_identifier(s string) bool {
    if s == '' {
        return false
    }
    first := s[0]
    if !((first >= `a` && first <= `z`) || (first >= `A` && first <= `Z`) || first == `_`) {
        return false
    }
    for i in 0 .. s.len {
        c := s[i]
        if !((c >= `a` && c <= `z`) || (c >= `A` && c <= `Z`) || (c >= `0` && c <= `9`) || c == `_`) {
            return false
        }
    }
    return true
}

fn is_valid_v_const_value(val string) bool {
    trimmed := val.trim_space()
    if trimmed == '' {
        return false
    }
    if trimmed.contains('==') || trimmed.contains('!=') || trimmed.contains('&&') || trimmed.contains('||') {
        return false
    }
    if trimmed.contains('?') || trimmed.contains(':') {
        return false
    }
    if trimmed.contains(',') {
        return false
    }
    for i in 1 .. trimmed.len {
        if trimmed[i] == `(` {
            prev := trimmed[i-1]
            if (prev >= `a` && prev <= `z`) || (prev >= `A` && prev <= `Z`) || (prev >= `0` && prev <= `9`) || prev == `_` {
                return false
            }
        }
    }
    return true
}

fn is_pure_numeric(s string) bool {
    if s == '' {
        return false
    }
    for i in 0 .. s.len {
        c := s[i]
        if !((c >= `0` && c <= `9`) || c == `x` || c == `X` || (c >= `a` && c <= `f`) || (c >= `A` && c <= `F`)) {
            return false
        }
    }
    return true
}

fn has_undefined_identifiers(val string, defined map[string]bool) bool {
    trimmed := val.trim_space()
    mut word := strings.new_builder(trimmed.len)
    for i in 0 .. trimmed.len {
        ch := trimmed[i]
        if (ch >= `a` && ch <= `z`) || (ch >= `A` && ch <= `Z`) || (ch >= `0` && ch <= `9`) || ch == `_` {
            word.write_string(trimmed[i..i+1])
        } else {
            w := word.str().trim_space()
            if w != '' {
                if !is_pure_numeric(w) {
                    if w !in defined && w != 'true' && w != 'false' && w != 'u32' && w != 'voidptr' {
                        return true
                    }
                }
            }
            word = strings.new_builder(trimmed.len)
        }
    }
    w := word.str().trim_space()
    if w != '' {
        if !is_pure_numeric(w) {
            if w !in defined && w != 'true' && w != 'false' && w != 'u32' && w != 'voidptr' {
                return true
            }
        }
    }
    return false
}

fn fix_v_numeric_overflow(val string) string {
    trimmed := val.trim_space()
    if trimmed.starts_with('0x') || trimmed.starts_with('0X') {
        hex_part := trimmed[2..].trim_space()
        if hex_part.len == 8 {
            first_digit := hex_part[0]
            if first_digit in [`8`, `9`, `A`, `B`, `C`, `D`, `E`, `F`, `a`, `b`, `c`, `d`, `e`, `f`] {
                return 'u32(${trimmed})'
            }
        }
    }
    return val
}

fn remove_spaces_in_brackets(s string) string {
    mut result := strings.new_builder(s.len)
    mut in_brackets := false
    for i in 0 .. s.len {
        ch := s[i]
        if ch == `[` {
            in_brackets = true
            result.write_string('[')
        } else if ch == `]` {
            in_brackets = false
            result.write_string(']')
        } else {
            if in_brackets && ch == ` ` {
                continue
            }
            result.write_string(s[i..i+1])
        }
    }
    return result.str()
}

fn clean_c_string_literal(val string) string {
    mut s := val.trim_space()
    
    if (s.starts_with('TEXT(') || s.starts_with('_T(') || s.starts_with('__TEXT(')) && s.ends_with(')') {
        first_paren := s.index('(') or { -1 }
        if first_paren != -1 {
            s = s[first_paren + 1 .. s.len - 1].trim_space()
        }
    }
    
    if s.starts_with('L"') && s.ends_with('"') {
        s = s[1..].trim_space()
    } else if s.starts_with("L'") && s.ends_with("'") {
        s = s[1..].trim_space()
    }
    
    return s
}

fn clean_c_tag_name(s string) string {
    mut clean := s.trim_space()
    if clean.starts_with('tag') {
        clean = clean[3..].trim_space()
    } else if clean.starts_with('_tag') {
        clean = clean[4..].trim_space()
    } else if clean.starts_with('_') {
        clean = clean[1..].trim_space()
    }
    return clean
}

fn map_c_to_v(c_type string) string {
    mut clean_type := c_type.trim_space()
    
    if clean_type.starts_with('struct ') {
        clean_type = clean_type[7..].trim_space()
    } else if clean_type.starts_with('union ') {
        clean_type = clean_type[6..].trim_space()
    } else if clean_type.starts_with('enum ') {
        clean_type = clean_type[5..].trim_space()
    }

    if clean_type in c_to_v_types {
        return c_to_v_types[clean_type]
    }

    mut ptr_prefix := ''
    for clean_type.ends_with('*') {
        ptr_prefix += '&'
        clean_type = clean_type[0..clean_type.len-1].trim_space()
    }

    if ptr_prefix != '' {
        if clean_type in c_to_v_types {
            clean_type = c_to_v_types[clean_type]
        }
        if clean_type == 'void' {
            return 'voidptr'
        }
        return ptr_prefix + clean_type
    }
    return clean_type
}

fn is_sal_annotation(word string) bool {
    if !word.starts_with('_') {
        return false
    }
    
    sal_prefixes := [
        '_In_', '_Out_', '_Inout_', '_Reserved_', '_Field_', '_Success_', 
        '_Post_', '_Pre_', '_Ret_', '_Null_', '_Notnull_', '_Maybenull_', 
        '_Printf_', '_Format_', '_Check_', '_Writes_', '_Reads_', '_Use_',
        '_On_', '_Always_', '_Maybe_', '_When_', '_Struct_', '_COM_Outptr_',
        '_Outptr_', '_Deref_'
    ]
    
    for pref in sal_prefixes {
        if word.starts_with(pref) {
            return true
        }
    }
    return false
}

fn strip_all_comments_from_text(text string) string {
    mut result := strings.new_builder(text.len)
    mut i := 0
    mut in_block_comment := false
    mut in_line_comment := false
    
    for i < text.len {
        if in_block_comment {
            if i + 1 < text.len && text[i] == `*` && text[i+1] == `/` {
                in_block_comment = false
                i += 2
            } else {
                if text[i] == `\n` || text[i] == `\r` {
                    result.write_string(text[i..i+1])
                }
                i++
            }
        } else if in_line_comment {
            if text[i] == `\n` || text[i] == `\r` {
                in_line_comment = false
                result.write_string(text[i..i+1])
            }
            i++
        } else {
            if i + 1 < text.len && text[i] == `/` && text[i+1] == `*` {
                in_block_comment = true
                i += 2
            } else if i + 1 < text.len && text[i] == `/` && text[i+1] == `/` {
                in_line_comment = true
                i += 2
            } else {
                result.write_string(text[i..i+1])
                i++
            }
        }
    }
    return result.str()
}

fn lowercase_const_value(val string) string {
    if !val.contains('"') && !val.contains("'") {
        return val.to_lower()
    }
    
    mut result := strings.new_builder(val.len)
    mut in_quote := false
    mut quote_char := `\0`
    
    for i in 0 .. val.len {
        ch := val[i]
        if (ch == `"` || ch == `'`) && (i == 0 || val[i-1] != `\\`) {
            if in_quote {
                if ch == quote_char {
                    in_quote = false
                }
            } else {
                in_quote = true
                quote_char = ch
            }
            result.write_string(val[i..i+1])
        } else {
            if in_quote {
                result.write_string(val[i..i+1])
            } else {
                result.write_string(val[i..i+1].to_lower())
            }
        }
    }
    return result.str()
}

fn is_valid_c_type(s string) bool {
    trimmed := s.trim_space()
    if trimmed == '' {
        return false
    }
    
    mut is_all_digits := true
    for c in trimmed {
        if !c.is_digit() {
            is_all_digits = false
            break
        }
    }
    if is_all_digits {
        return false
    }

    for c in trimmed {
        if !c.is_alnum() && c != `_` && c != ` ` && c != `*` {
            return false
        }
    }
    return true
}

fn strip_outer_parens(s string) string {
    mut clean := s.trim_space()
    for clean.starts_with('(') && clean.ends_with(')') {
        mut count := 0
        mut matching := true
        for i in 0 .. clean.len {
            if clean[i] == `(` {
                count++
            } else if clean[i] == `)` {
                count--
                if count == 0 && i < clean.len - 1 {
                    matching = false
                    break
                }
            }
        }
        if matching && count == 0 {
            clean = clean[1..clean.len - 1].trim_space()
        } else {
            break
        }
    }
    return clean
}

fn clean_single_token_literal(val string) string {
    mut clean := val.trim_space()
    if clean.len > 0 {
        first := clean[0]
        if !(first >= `0` && first <= `9`) {
            return clean
        }
    }
    is_hex := clean.starts_with('0x') || clean.starts_with('0X')

    for suff in ms_suffixes {
        if clean.ends_with(suff) {
            if clean.len > suff.len {
                prev_char := clean[clean.len - suff.len - 1]
                if prev_char.is_digit() || prev_char in [`A`, `B`, `C`, `D`, `E`, `F`, `a`, `b`, `c`, `d`, `e`, `f`] {
                    clean = clean[0..clean.len - suff.len].clone()
                    return clean
                }
            }
        }
    }

    if clean.ends_with('ULL') || clean.ends_with('ull') {
        clean = clean[0..clean.len - 3].clone()
    } else if clean.ends_with('UL') || clean.ends_with('ul') {
        clean = clean[0..clean.len - 2].clone()
    } else if clean.ends_with('L') || clean.ends_with('l') || clean.ends_with('U') || clean.ends_with('u') {
        if clean.len > 1 {
            last_char := clean[clean.len - 1]
            prev_char := clean[clean.len - 2]
            if (last_char in [`L`, `l`, `U`, `u`]) && (prev_char.is_digit() || prev_char in [`A`, `B`, `C`, `D`, `E`, `F`, `a`, `b`, `c`, `d`, `e`, `f`]) {
                clean = clean[0..clean.len - 1].clone()
            }
        }
    } else if (clean.ends_with('F') || clean.ends_with('f')) && !is_hex {
        if clean.len > 1 {
            prev_char := clean[clean.len - 2]
            if prev_char.is_digit() || prev_char == `.` {
                clean = clean[0..clean.len - 1].clone()
            }
        }
    }
    return clean
}

fn clean_c_numeric_literal(val string) string {
    mut clean := val.trim_space()
    clean = strip_outer_parens(clean)
    
    if clean.starts_with('(') {
        idx := clean.index(')') or { -1 }
        if idx != -1 {
            cast_content := clean[1..idx].trim_space()
            if is_valid_c_type(cast_content) {
                clean = clean[idx+1..].trim_space()
            }
        }
    }
    
    mut result := strings.new_builder(clean.len)
    mut i := 0
    for i < clean.len {
        if clean[i].is_alnum() || clean[i] == `_` || clean[i] == `.` {
            mut start := i
            for i < clean.len && (clean[i].is_alnum() || clean[i] == `_` || clean[i] == `.`) {
                i++
            }
            mut token := clean[start..i].clone()
            token = clean_single_token_literal(token)
            result.write_string(token)
        } else {
            result.write_string(clean[i..i+1].clone())
            i++
        }
    }
    return result.str()
}

fn is_structural_line(line string) bool {
    trimmed := line.trim_space()
    if trimmed == '{' || trimmed == '}' || trimmed == '};' || trimmed == ';' {
        return true
    }
    if trimmed.contains('union') || trimmed.contains('struct') {
        if trimmed.contains('{') || trimmed.contains('}') || trimmed.ends_with(';') {
            return true
        }
    }
    return false
}

fn parse_struct_fields(field_line string, mut state ParserState) []string {
    mut line := remove_spaces_in_brackets(field_line).trim_space()
    if line.ends_with(';') {
        line = line[0..line.len - 1].trim_space()
    }

    if line.contains(':') {
        line = line.all_before(':').trim_space()
    }

    for keyword in obsolete_keywords {
        line = line.replace(' ' + keyword + ' ', ' ')
        line = line.replace(' ' + keyword, ' ')
        line = line.replace(keyword + ' ', ' ')
        line = line.replace(keyword, ' ')
    }

    line = line.replace('*', ' * ')
    line = line.trim_space()
    for line.contains('  ') {
        line = line.replace('  ', ' ')
    }
    
    words := line.split(' ').filter(it != '' && !is_sal_annotation(it))
    if words.len < 2 {
        return []
    }

    mut comma_idx := -1
    for i, w in words {
        if w.contains(',') {
            comma_idx = i
            break
        }
    }

    mut c_type := ''
    mut variables := []string{}

    if comma_idx != -1 {
        c_type = words[0..comma_idx].join(' ').trim_space()
        for i in comma_idx .. words.len {
            v := words[i].replace(',', '').trim_space()
            if v != '' {
                variables << v
            }
        }
    } else {
        c_type = words[0..words.len - 1].join(' ').trim_space()
        variables << words[words.len - 1].trim_space()
    }

    mut results := []string{}
    for var_name in variables {
        mut field_name := var_name
        mut is_array := false
        mut array_size := ''
        
        if field_name.contains('[') && field_name.contains(']') {
            is_array = true
            array_size = field_name.all_after('[').all_before(']').trim_space()
            field_name = field_name.all_before('[').trim_space()
        }

        mut is_ptr := false
        for field_name.starts_with('*') {
            is_ptr = true
            field_name = field_name[1..].trim_space()
        }

        mut base_type_words := []string{}
        type_parts := c_type.split(' ')
        for tp in type_parts {
            if tp == '*' {
                is_ptr = true
            } else {
                base_type_words << tp
            }
        }
        clean_c_type := base_type_words.join(' ').trim_space()

        field_name = field_name.to_lower()

        for field_name.starts_with('_') {
            if field_name.len > 1 && field_name[1].is_digit() {
                field_name = 'v_' + field_name[1..]
                break
            } else {
                field_name = field_name[1..]
            }
        }
        if field_name == '' {
            field_name = 'unnamed'
        }

        mut v_type := map_c_to_v(clean_c_type)
        if is_ptr {
            if v_type == 'void' {
                v_type = 'voidptr'
            } else {
                v_type = '&' + v_type
            }
        }

        mut formatted_field := ''
        if is_array {
            mut clean_size := array_size
            if !array_size.is_int() {
                clean_size = array_size.to_lower()
                if clean_size == 'max_path' {
                    clean_size = '260'
                } else if clean_size == 'anysize_array' {
                    clean_size = '1'
                } else if clean_size == 'cchdevicename' {
                    clean_size = '32'
                } else if clean_size == 'pointer_device_product_string_max' {
                    clean_size = '520'
                } else if clean_size == 'ofs_maxpathname' {
                    clean_size = '128'
                } else if clean_size == 'hw_profile_guidlen' {
                    clean_size = '39'
                } else if clean_size == 'max_profile_len' {
                    clean_size = '80'
                }
            }
            formatted_field = '${field_name} [${clean_size}]${v_type}'
        } else {
            formatted_field = '${field_name} ${v_type}'
        }
        results << formatted_field
    }

    known_basic_v_types := ['u8','u16','u32','u64','i8','i16','i32','i64',
                            'f32','f64','bool','void','voidptr','usize','int','isize',
                            'char','&char','&u8','&u16','&u32','&i8','&i16','&i32']

    mut fixed_results := []string{}
    for r in results {
        if r.contains('[') {
            arr_part := r.all_after('[').all_before(']').trim_space()
            t_part   := r.all_after(']').trim_space()
            mut new_t := t_part
            if t_part.starts_with('&') {
                under := t_part[1..]
                if under !in known_basic_v_types && under !in state.defined_types && under !in state.defined_structs && under !in c_to_v_types {
                    new_t = 'voidptr'
                }
            } else if t_part !in known_basic_v_types && t_part !in state.defined_types && t_part !in state.defined_structs && t_part !in c_to_v_types {
                new_t = 'voidptr'
            }
            if new_t == 'byte' { new_t = 'u8' }
            name_part := r.all_before(' [').trim_space()
            fixed_results << '${name_part} [${arr_part}]${new_t}'
        } else {
            parts := r.split(' ')
            if parts.len >= 2 {
                name_part := parts[0]
                t_part := parts[1..].join(' ')
                mut new_t := t_part
                if t_part.starts_with('&') {
                    under := t_part[1..]
                    if under !in known_basic_v_types && under !in state.defined_types && under !in state.defined_structs && under !in c_to_v_types {
                        new_t = 'voidptr'
                    }
                } else if t_part !in known_basic_v_types && t_part !in state.defined_types && t_part !in state.defined_structs && t_part !in c_to_v_types {
                    new_t = 'voidptr'
                }
                if new_t == 'byte' { new_t = 'u8' }
                fixed_results << '${name_part} ${new_t}'
            } else {
                fixed_results << r
            }
        }
    }
    return fixed_results
}

fn print_v_typedef(name string, base string, is_pointer bool, mut state ParserState, mut output strings.Builder) {
    n := name.trim_space()
    if n == '' || n.contains('(') || n.contains(')') {
        return
    }
    if n in state.defined_types || n in state.defined_structs {
        return
    }

    resolved_base := clean_c_tag_name(base)

    mut original := resolved_base
    for {
        if original in state.alias_resolutions {
            next := state.alias_resolutions[original]
            if next == original {
                break
            }
            original = next
        } else {
            break
        }
    }

    known_basic_v_types := ['u8','u16','u32','u64','i8','i16','i32','i64',
                            'f32','f64','bool','void','voidptr','usize','int','isize',
                            'char','&char','&u8','&u16','&u32','&i8','&i16','&i32']

    if original.starts_with('&') {
        mut final_v_type := original
        underlying := original[1..]
        if underlying != 'void' && underlying !in state.defined_structs && underlying !in state.defined_types && underlying !in c_to_v_types && underlying !in known_basic_v_types {
            final_v_type = 'voidptr'
        }
        if final_v_type == 'byte' { final_v_type = 'u8' }
        if final_v_type.starts_with('&byte') {
            final_v_type = final_v_type.replace('&byte', '&u8')
        }
        output.writeln('pub type ${n} = ${final_v_type}')
        state.defined_types[n] = true
        state.alias_resolutions[n] = final_v_type
        return
    }

    if original == 'voidptr' {
        output.writeln('pub type ${n} = voidptr')
        state.defined_types[n] = true
        state.alias_resolutions[n] = 'voidptr'
        return
    }

    mut final_v_type := original
    if is_pointer {
        if original == 'void' {
            final_v_type = 'voidptr'
        } else {
            final_v_type = '&' + original
        }
    } else {
        if original == 'void' {
            final_v_type = 'u8'
        } else {
            final_v_type = original
        }
    }

    if final_v_type.starts_with('&') {
        under := final_v_type[1..]
        if under !in state.defined_structs && under !in state.defined_types && under !in c_to_v_types && under !in known_basic_v_types {
            final_v_type = 'voidptr'
        }
    } else if final_v_type != 'voidptr' && final_v_type !in state.defined_structs && final_v_type !in state.defined_types && final_v_type !in c_to_v_types && final_v_type !in known_basic_v_types {
        final_v_type = 'voidptr'
    }

    if final_v_type == 'byte' {
        final_v_type = 'u8'
    }
    if final_v_type.starts_with('&byte') {
        final_v_type = final_v_type.replace('&byte', '&u8')
    }

    output.writeln('pub type ${n} = ${final_v_type}')
    state.defined_types[n] = true
    state.alias_resolutions[n] = final_v_type
}

fn process_header(header_path string, mut state ParserState, mut output strings.Builder) {
    if !os.exists(header_path) {
        eprintln('// Error: ${header_path} not found!')
        return
    }

    output.writeln('// #### ')
    output.writeln('// Generated V bindings from ${header_path}')
    output.writeln('// ####')

    content := os.read_file(header_path) or {
        eprintln('// Error reading file: ${err}')
        return
    }

    clean_text := strip_all_comments_from_text(content)
    lines := clean_text.split_into_lines()

    mut merged_lines := []string{}
    mut temp_line := ''
    for line in lines {
        trimmed := line.trim_space()
        if trimmed.ends_with('\\') {
            temp_line += trimmed[0..trimmed.len - 1].trim_space() + ' '
        } else {
            if temp_line != '' {
                merged_lines << temp_line + trimmed
                temp_line = ''
            } else {
                merged_lines << line
            }
        }
    }

    mut in_struct := false
    mut brace_depth := 0
    mut struct_fields := []string{}
    mut added_fields := []string{}

    for line in merged_lines {
        mut l := line.trim_space()
        
        if l == '' {
            continue
        }

        if in_struct {
            if l.starts_with('#') {
                continue
            }

            mut has_braces := false
            for ch in l {
                if ch == `{` {
                    brace_depth++
                    has_braces = true
                } else if ch == `}` {
                    brace_depth--
                    has_braces = true
                }
            }

            if brace_depth <= 0 {
                mut names_part := ''
                if l.contains('}') {
                    names_part = l.all_after('}')
                    if names_part.contains(';') {
                        names_part = names_part.all_before(';')
                    }
                    names_part = names_part.trim_space()
                }
                
                for keyword in obsolete_keywords {
                    names_part = names_part.replace(' ' + keyword + ' ', ' ')
                    names_part = names_part.replace(' ' + keyword, ' ')
                    names_part = names_part.replace(keyword + ' ', ' ')
                    names_part = names_part.replace(keyword, ' ')
                }
                names_part = names_part.trim_space()
                for names_part.contains('  ') {
                    names_part = names_part.replace('  ', ' ')
                }

                declarators := names_part.split(',')
                mut struct_name := ''
                mut pointer_names := []string{}
                
                for decl in declarators {
                    mut name := decl.trim_space()
                    if name == '' {
                        continue
                    }
                    if name.starts_with('*') {
                        pointer_names << name[1..].trim_space()
                    } else {
                        if struct_name == '' {
                            struct_name = name
                        } else {
                            pointer_names << name
                        }
                    }
                }

                if struct_name != '' {
                    if struct_name in state.defined_structs || struct_name in state.defined_types {
                        
                    } else {
                        output.writeln('pub struct ${struct_name} {')
                        output.writeln('pub mut:')
                        for field in struct_fields {
                            output.writeln('\t${field}')
                        }
                        output.writeln('}')
                        output.writeln('')
                        state.defined_structs[struct_name] = true
                        state.alias_resolutions[struct_name] = struct_name
                    }

                    for ptr_name in pointer_names {
                        if ptr_name in state.defined_types || ptr_name in state.defined_structs {
                            continue
                        }
                        output.writeln('pub type ${ptr_name} = &${struct_name}')
                        state.defined_types[ptr_name] = true
                        state.alias_resolutions[ptr_name] = '&' + struct_name
                    }
                    output.writeln('')
                }

                in_struct = false
                brace_depth = 0
                struct_fields.clear()
                added_fields.clear()
                continue
            }

            if has_braces || is_structural_line(l) {
                continue
            }

            if l == '{' {
                continue
            }

            parsed_fields := parse_struct_fields(l, mut state)
            for pf in parsed_fields {
                if pf != '' {
                    field_name := pf.all_before(' ').trim_space()
                    if field_name !in added_fields {
                        struct_fields << pf
                        added_fields << field_name
                    }
                }
            }
            continue
        }

        if l.starts_with('typedef struct') && (!l.ends_with(';') || l.contains('{')) {
            in_struct = true
            brace_depth = 0
            for ch in l {
                if ch == `{` {
                    brace_depth++
                }
            }
            struct_fields.clear()
            added_fields.clear()
            continue
        }

        if l.starts_with('#define ') {
            macro_content := l[8..].trim_space()
            
            words := macro_content.split(' ').filter(it != '' && !is_sal_annotation(it))
            if words.len >= 2 {
                mut name := words[0]
                value := words[1..].join(' ').trim_space()
                
                if !name.contains('(') && value != '' {
                    cleaned_value := clean_c_numeric_literal(value)
                    if cleaned_value in c_compiler_conventions {
                        continue
                    }
                    
                    name_lower := name.to_lower()
                    if name_lower in state.defined_consts {
                        continue
                    }
                    
                    if !is_valid_v_identifier(name_lower) {
                        continue
                    }
                    
                    temp_value := clean_c_string_literal(cleaned_value)
                    
                    final_value := lowercase_const_value(temp_value)
                    
                    if !is_valid_v_const_value(final_value) {
                        continue
                    }
                    
                    fixed_value := fix_v_numeric_overflow(final_value)
                    
                    if has_undefined_identifiers(fixed_value, state.defined_consts) {
                        continue
                    }
                    
                    if is_valid_v_identifier(fixed_value) {
                        if fixed_value !in state.defined_consts && fixed_value != 'true' && fixed_value != 'false' {
                            continue
                        }
                    }
                    
                    output.writeln('pub const ${name_lower} = ${fixed_value}')
                    state.defined_consts[name_lower] = true
                }
            }
            continue
        }

        if l.starts_with('typedef ') && l.ends_with(';') {
            if l.contains('(') && l.contains(')') {
                continue
            }

            l = l[8..l.len - 1].trim_space()

            for keyword in obsolete_keywords {
                l = l.replace(' ' + keyword + ' ', ' ')
                l = l.replace(' ' + keyword, ' ')
                l = l.replace(keyword + ' ', ' ')
                l = l.replace(keyword, ' ')
            }
            l = l.trim_space()

            for l.contains('  ') {
                l = l.replace('  ', ' ')
            }

            parts := l.split(',')
            if parts.len == 0 {
                continue
            }

            first_part := parts[0].trim_space()
            first_words := first_part.split(' ').filter(it != '' && !is_sal_annotation(it))
            if first_words.len < 2 {
                continue
            }

            mut first_decl := first_words[first_words.len - 1].trim_space()
            mut base_type_parts := first_words[0..first_words.len - 1].clone()

            mut is_ptr := false
            if base_type_parts.len > 0 && base_type_parts[base_type_parts.len - 1] == '*' {
                is_ptr = true
                base_type_parts = base_type_parts[0..base_type_parts.len - 1].clone()
            } else if base_type_parts.len > 0 && base_type_parts[base_type_parts.len - 1].ends_with('*') {
                is_ptr = true
                last_idx := base_type_parts.len - 1
                base_type_parts[last_idx] = base_type_parts[last_idx].trim_string_right('*')
            }

            if first_decl.starts_with('*') {
                is_ptr = true
                first_decl = first_decl.trim_string_left('*').trim_space()
            }

            c_base_type := base_type_parts.join(' ').trim_space()
            v_base_type := map_c_to_v(c_base_type)

            print_v_typedef(first_decl, v_base_type, is_ptr, mut state, mut output)

            for i in 1 .. parts.len {
                part := parts[i].trim_space()
                if part == '' {
                    continue
                }
                mut decl_name := part
                mut part_is_ptr := false
                
                if decl_name.starts_with('*') {
                    part_is_ptr = true
                    decl_name = decl_name.trim_string_left('*').trim_space()
                }
                
                print_v_typedef(decl_name, v_base_type, part_is_ptr, mut state, mut output)
            }
            continue
        }

        if l.ends_with(';') && l.contains('(') && l.contains(')') {
            if l.starts_with('#') || l.contains('struct') || l.contains('typedef') || l.contains('=') {
                continue
            }
            
            mut clean_line := l[0..l.len - 1].trim_space()
            for keyword in obsolete_keywords {
                clean_line = clean_line.replace(' ' + keyword + ' ', ' ')
                clean_line = clean_line.replace(' ' + keyword, ' ')
                clean_line = clean_line.replace(keyword + ' ', ' ')
                clean_line = clean_line.replace(keyword, ' ')
            }
            clean_line = clean_line.trim_space()
            for clean_line.contains('  ') {
                clean_line = clean_line.replace('  ', ' ')
            }

            left_part := clean_line.all_before('(').trim_space()
            right_part := clean_line.all_after('(').all_before(')').trim_space()

            left_words := left_part.split(' ').filter(it != '' && !is_sal_annotation(it))
            if left_words.len < 2 {
                continue
            }

            mut func_name := left_words[left_words.len - 1].trim_space()
            for func_name.starts_with('*') {
                func_name = func_name[1..].trim_space()
            }
            
            if !is_valid_v_identifier(func_name) {
                continue
            }

            c_ret_type := left_words[0..left_words.len - 1].join(' ').trim_space()
            mut v_ret_type := map_c_to_v(c_ret_type)

            known_basic_v_types := ['u8','u16','u32','u64','i8','i16','i32','i64',
                                    'f32','f64','bool','void','voidptr','usize','int','isize',
                                    'char','&char','&u8','&u16','&u32','&i8','&i16','&i32']

            if v_ret_type.starts_with('&') {
                under := v_ret_type[1..]
                if under !in known_basic_v_types && under !in state.defined_types && under !in state.defined_structs && under !in c_to_v_types {
                    v_ret_type = 'voidptr'
                }
            } else if v_ret_type !in known_basic_v_types && v_ret_type !in state.defined_types && v_ret_type !in state.defined_structs && v_ret_type !in c_to_v_types {
                v_ret_type = 'voidptr'
            }
            if v_ret_type == 'byte' { v_ret_type = 'u8' }

            if v_ret_type in ['return', 'if', 'while', 'for', 'switch', 'else', 'do'] {
                continue
            }

            params := right_part.split(',')
            mut v_params := []string{}

            for p in params {
                p_trimmed := p.trim_space()
                if p_trimmed == '' || p_trimmed == 'void' {
                    continue
                }

                p_words := p_trimmed.split(' ').filter(it != '' && !is_sal_annotation(it))
                mut p_name := ''
                mut p_c_type := ''

                if p_words.len == 1 {
                    p_name = 'arg${v_params.len + 1}'
                    p_c_type = p_words[0]
                } else {
                    p_name = p_words[p_words.len - 1].trim_space()
                    p_c_type = p_words[0..p_words.len - 1].join(' ').trim_space()
                }

                mut is_param_ptr := false
                for p_name.starts_with('*') {
                    is_param_ptr = true
                    p_name = p_name[1..].trim_space()
                }
                if p_name == '' || !is_valid_v_identifier(p_name) {
                    p_name = 'arg${v_params.len + 1}'
                }

                mut v_param_type := map_c_to_v(p_c_type)
                if is_param_ptr {
                    if v_param_type == 'void' {
                        v_param_type = 'voidptr'
                    } else if v_param_type == 'voidptr' {
                    } else {
                        v_param_type = '&' + v_param_type
                    }
                }

                if v_param_type.starts_with('&') {
                    under := v_param_type[1..]
                    if under !in known_basic_v_types && under !in state.defined_types && under !in state.defined_structs && under !in c_to_v_types {
                        v_param_type = 'voidptr'
                    }
                } else if v_param_type !in known_basic_v_types && v_param_type !in state.defined_types && v_param_type !in state.defined_structs && v_param_type !in c_to_v_types {
                    v_param_type = 'voidptr'
                }
                if v_param_type == 'byte' { v_param_type = 'u8' }

                v_params << '${p_name} ${v_param_type}'
            }

            output.writeln('pub fn C.${func_name}(${v_params.join(', ')}) ${v_ret_type}')
        }
    }
}

fn main() {
    if os.args.len < 2 {
        eprintln('Usage: vin32 <folder_path>')
        exit(1)
    }

    folder := os.args[1]
    if !os.is_dir(folder) {
        eprintln('Error: Directory "${folder}" not found.')
        exit(1)
    }
    
    files := os.ls(folder) or {
        eprintln('Error reading directory: ${err}')
        exit(1)
    }

    target_files := ['windef.h', 'winuser.h', 'winbase.h']
    mut headers_to_process := []string{}

    for file in files {
        lower_file := file.to_lower()
        if lower_file in target_files {
            headers_to_process << os.join_path(folder, file)
        }
    }

    if headers_to_process.len == 0 {
        eprintln('No target headers (windef.h, winuser.h, winbase.h) found in ${folder}')
        exit(1)
    }

    mut state := ParserState{
        defined_types:     map[string]bool{}
        defined_structs:   map[string]bool{}
        defined_consts:    map[string]bool{}
        alias_resolutions: map[string]string{}
    }

    mut output := strings.new_builder(1024 * 1024)
    output.writeln('// Generated V bindings for Windows API')
    output.writeln('module win32')
    output.writeln('')

    for header in headers_to_process {
        process_header(header, mut state, mut output)
    }
    
    os.write_file('win32.v', output.str()) or {
        eprintln('Error writing win32.v: ${err}')
        exit(1)
    }

    println('Successfully generated win32.v')
}
