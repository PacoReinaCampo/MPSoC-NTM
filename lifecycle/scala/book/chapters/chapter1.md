# LEXICAL SYNTAX

## IDENTIFIERS

Identifiers in Scala are used to name various programming elements such as variables, functions, classes, and objects. An identifier can be a sequence of letters, digits, underscores (`_`), and dollar signs (`$`), but it must not start with a digit. There are different categories of identifiers in Scala:

1. **Alphanumeric Identifiers**: These consist of letters and digits, where the first character must be a letter. 
   * Example: `myVar`, `MAX_SIZE`

2. **Operator Identifiers**: These consist of one or more operator characters, which include `+`, `-`, `*`, `/`, `:`, `=`, `<`, `>`, `!`, `%`, `^`, `&`, `|`, `~`, `?`, and `\`.
   * Example: `+`, `++`, `:=`

3. **Mixed Identifiers**: These start with an alphanumeric identifier followed by an underscore and an operator identifier.
   * Example: `unary_+`, `myVar_=` 

4. **Backtick Identifiers**: Any string enclosed in backticks can be used as an identifier, allowing the use of reserved words.
   * Example: `` `type` ``, `` `val` ``

## NEWLINE CHARACTERS

In Scala, newline characters (`\n`, `\r\n`) are significant and can affect the interpretation of the code. Newlines are typically used to terminate statements. However, a statement can span multiple lines if the newline is escaped with a backslash (`\`). For instance:

```scala
val result = 1 + 
             2 + 
             3
```

## LITERALS

Literals represent fixed values in the code. Scala supports several types of literals:

### Integer Literals

Integer literals represent whole numbers and can be expressed in different bases:

- **Decimal**: Base 10 (default)
   * Example: `42`, `0`, `-7`
- **Hexadecimal**: Base 16, prefixed with `0x` or `0X`
   * Example: `0x2A`, `0X0`, `0x7F`
- **Octal**: Scala 2.11 and onwards, prefixed with `0`
   * Example: `017`, `020`
- **Binary**: Prefixed with `0b` or `0B`
   * Example: `0b1010`, `0B0101`

### Floating Point Literals

Floating-point literals represent numbers with a fractional part and can be expressed in standard or exponential notation:

- **Standard Notation**: 
   * Example: `3.14`, `0.0`, `-1.5`
- **Exponential Notation**: 
   * Example: `1e10`, `2.5e-3`, `3.14E5`

### Boolean Literals

Boolean literals represent truth values and are denoted as `true` and `false`.

- Example: `true`, `false`

### Character Literals

Character literals represent single Unicode characters and are enclosed in single quotes.

- Example: `'a'`, `'1'`, `'\n'`

### String Literals

String literals represent sequences of characters and are enclosed in double quotes.

- Example: `"Hello, World!"`, `"Scala"`

### Escape Sequences

Escape sequences in character and string literals allow the representation of special characters:

- `\b` : Backspace
- `\t` : Tab
- `\n` : Newline
- `\f` : Formfeed
- `\r` : Carriage return
- `\"` : Double quote
- `\'` : Single quote
- `\\` : Backslash
- `\uXXXX` : Unicode character

### Symbol Literals

Symbol literals are used to create interned strings and are prefixed with a single quote.

- Example: `'symbol`, `'anotherSymbol`

## WHITESPACE AND COMMENTS

Whitespace characters (space, tab, newline) are used to separate tokens but are otherwise ignored. Scala supports both single-line and multi-line comments:

- **Single-line Comments**: Begin with `//` and continue to the end of the line.
   * Example: `// This is a comment`
- **Multi-line Comments**: Enclosed between `/*` and `*/`, can span multiple lines.
   * Example: 
    ```scala
    /* This is a 
       multi-line comment */
    ```

## XML MODE

Scala supports embedding XML literals directly within the code. XML literals are enclosed in angle brackets and can include Scala expressions within `{}`:

```scala
val xml = <note>
  <to>Tove</to>
  <from>Jani</from>
  <heading>Reminder</heading>
  <body>Don't forget me this weekend!</body>
</note>
```

Within XML literals, you can include Scala expressions using `{}`:

```scala
val name = "John"
val xml = <user>
  <name>{name}</name>
</user>
```

This manual covers the basics of Scala's lexical syntax, providing the foundation for writing and understanding Scala code.
