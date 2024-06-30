# PATTERN MATCHING

Pattern matching is a powerful feature in Scala, allowing you to match on the structure of data and decompose it in a concise and readable way. It is extensively used for deconstructing data structures, handling different cases, and more.

## PATTERNS

Patterns are the core components of pattern matching. Scala provides a wide variety of pattern types, each suited for different scenarios.

### Variable Patterns

Variable patterns match any value and bind it to a variable name.

- Example:
  ```scala
  val x = 42
  x match {
    case y => println(s"Matched with y = $y")
  }
  ```

### Typed Patterns

Typed patterns match values of a specific type and bind them to a variable.

- Example:
  ```scala
  def process(input: Any): String = input match {
    case s: String => s"String: $s"
    case i: Int    => s"Integer: $i"
    case _         => "Unknown type"
  }
  ```

### Pattern Binders

Pattern binders allow you to name a pattern for reuse within the same match expression.

- Example:
  ```scala
  val someValue: Option[Int] = Some(42)
  someValue match {
    case some @ Some(value) => println(s"Got a value: $value with $some")
    case None               => println("Got nothing")
  }
  ```

### Literal Patterns

Literal patterns match values that are equal to the literal.

- Example:
  ```scala
  val x = 42
  x match {
    case 42 => println("The answer to everything")
    case _  => println("Not the answer")
  }
  ```

### Stable Identifier Patterns

Stable identifier patterns match values that are equal to a stable identifier (a value that is not reassignable, like a val).

- Example:
  ```scala
  val target = 42
  val x = 42
  x match {
    case `target` => println("Matched the target")
    case _        => println("Did not match the target")
  }
  ```

### Constructor Patterns

Constructor patterns match values of a case class and decompose them.

- Example:
  ```scala
  case class Person(name: String, age: Int)
  val person = Person("Alice", 25)
  person match {
    case Person(n, a) => println(s"Name: $n, Age: $a")
  }
  ```

### Tuple Patterns

Tuple patterns match tuples and decompose them into their elements.

- Example:
  ```scala
  val tuple = (1, "Scala")
  tuple match {
    case (num, str) => println(s"Number: $num, String: $str")
  }
  ```

### Extractor Patterns

Extractor patterns use unapply methods to decompose objects.

- Example:
  ```scala
  object Twice {
    def unapply(x: Int): Option[Int] = if (x % 2 == 0) Some(x / 2) else None
  }
  val number = 10
  number match {
    case Twice(n) => println(s"Half is $n")
    case _        => println("Not even")
  }
  ```

### Pattern Sequences

Pattern sequences match sequences like arrays and lists.

- Example:
  ```scala
  val list = List(1, 2, 3)
  list match {
    case List(1, _*) => println("Starts with 1")
    case _           => println("Does not start with 1")
  }
  ```

### Infix Operation Patterns

Infix operation patterns match patterns using infix notation.

- Example:
  ```scala
  case class Cons(head: Int, tail: List[Int])
  val list = Cons(1, List(2, 3))
  list match {
    case head Cons tail => println(s"Head: $head, Tail: $tail")
  }
  ```

### Pattern Alternatives

Pattern alternatives allow matching multiple patterns in a single case.

- Example:
  ```scala
  val x: Any = 42
  x match {
    case 42 | "Scala" => println("Matched 42 or Scala")
    case _            => println("Did not match")
  }
  ```

### XML Patterns

XML patterns match XML nodes and decompose them.

- Example:
  ```scala
  val xml = <person><name>Alice</name><age>25</age></person>
  xml match {
    case <person><name>{name}</name><age>{age}</age></person> =>
      println(s"Name: $name, Age: $age")
  }
  ```

### Regular Expression Patterns

Regular expression patterns match strings using regular expressions.

- Example:
  ```scala
  val emailPattern = "([^@]+)@([^@]+)".r
  val email = "user@example.com"
  email match {
    case emailPattern(user, domain) => println(s"User: $user, Domain: $domain")
    case _                          => println("Not an email")
  }
  ```

### Irrefutable Patterns

Irrefutable patterns always match. They are often used in variable bindings.

- Example:
  ```scala
  val (a, b) = (1, 2)
  println(s"a: $a, b: $b")
  ```

## TYPE PATTERNS

Type patterns match values of a specific type and can be used in pattern matching and variable declarations.

- Example:
  ```scala
  val x: Any = "Hello"
  x match {
    case s: String => println(s"String: $s")
    case _         => println("Not a string")
  }
  ```

## TYPE PARAMETER INFERENCE IN PATTERNS

Type parameter inference allows the compiler to infer the type parameters based on the pattern being matched.

- Example:
  ```scala
  def getType[T](list: List[T]): String = list match {
    case _: List[Int]    => "List of Ints"
    case _: List[String] => "List of Strings"
    case _               => "Other type of list"
  }
  println(getType(List(1, 2, 3))) // Prints: List of Ints
  ```

## PATTERN MATCHING EXPRESSIONS

Pattern matching expressions use the `match` keyword to perform pattern matching.

- Example:
  ```scala
  val x: Any = 42
  val result = x match {
    case 42 => "The answer"
    case _  => "Not the answer"
  }
  println(result) // Prints: The answer
  ```

## PATTERN MATCHING ANONYMOUS FUNCTIONS

Pattern matching anonymous functions use the `case` keyword within a function literal.

- Example:
  ```scala
  val list = List(1, 2, 3, 4)
  val evens = list.collect { case x if x % 2 == 0 => x }
  println(evens) // Prints: List(2, 4)
  ```

This manual provides a comprehensive overview of pattern matching in Scala, covering various types of patterns and their use in type patterns, pattern matching expressions, and anonymous functions. Pattern matching is a powerful tool for working with data structures in a concise and expressive way.
