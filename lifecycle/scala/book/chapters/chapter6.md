# EXPRESSIONS

Expressions are a fundamental part of Scala, as they are in most programming languages. In Scala, almost everything is an expression, including some constructs that are statements in other languages.

## EXPRESSION TYPING

Expressions in Scala are statically typed. The type of an expression is known at compile time. Scala uses type inference to deduce the type of expressions when it is not explicitly stated.

## LITERALS

Literals are constant values that are directly written in the code. Scala supports several types of literals:

- **Integer Literals**: `42`, `0`, `-1`
- **Floating Point Literals**: `3.14`, `0.0`, `-2.5`
- **Boolean Literals**: `true`, `false`
- **Character Literals**: `'a'`, `'\n'`
- **String Literals**: `"Hello, world!"`, `"""Triple-quoted strings"""`

## THE NULL VALUE

`null` is a special literal in Scala, representing the absence of a value. It can be assigned to any reference type but not to value types (like `Int`, `Float`, etc.).

- Example:
  ```scala
  val s: String = null
  val n: Int = null // This will cause a compile error
  ```

## DESIGNATORS

Designators refer to named entities in the program, such as variables, methods, or types.

- **Variable Designator**:
  ```scala
  val x = 10
  println(x)
  ```

- **Method Designator**:
  ```scala
  def greet(): String = "Hello"
  println(greet())
  ```

## THIS AND SUPER

`this` and `super` are special designators used to refer to the current instance and the superclass, respectively.

- **This**:
  ```scala
  class MyClass {
    val name = "Scala"
    def showName(): Unit = println(this.name)
  }
  ```

- **Super**:
  ```scala
  class A {
    def show(): String = "A"
  }
  class B extends A {
    override def show(): String = "B"
    def superShow(): String = super.show()
  }
  ```

## FUNCTION APPLICATIONS

Function applications in Scala are the syntax for calling functions or methods.

- **Basic Function Application**:
  ```scala
  def add(x: Int, y: Int): Int = x + y
  val result = add(2, 3)
  ```

### Named and Default Arguments

Named arguments allow passing arguments to a function by specifying the parameter names. Default arguments provide default values for parameters.

- **Named Arguments**:
  ```scala
  def printInfo(name: String, age: Int): Unit = {
    println(s"Name: $name, Age: $age")
  }
  printInfo(age = 30, name = "Alice")
  ```

- **Default Arguments**:
  ```scala
  def greet(name: String = "Guest"): Unit = {
    println(s"Hello, $name")
  }
  greet()         // Prints: Hello, Guest
  greet("Alice")  // Prints: Hello, Alice
  ```

## METHOD VALUES

Method values allow treating methods as first-class functions by converting them into function values.

- Example:
  ```scala
  class MyClass {
    def multiply(x: Int, y: Int): Int = x * y
  }
  val myClass = new MyClass
  val f = myClass.multiply _
  println(f(2, 3)) // Prints: 6
  ```

## TYPE APPLICATIONS

Type applications specify type arguments for generic classes, traits, or methods.

- Example:
  ```scala
  class Box[T](value: T) {
    def get: T = value
  }
  val intBox = new Box 
  ```

## TUPLES

Tuples group a fixed number of elements of potentially different types into a single composite value.

- Example:
  ```scala
  val tuple: (Int, String, Boolean) = (42, "Scala", true)
  println(tuple._1) // Prints: 42
  println(tuple._2) // Prints: Scala
  println(tuple._3) // Prints: true
  ```

## INSTANCE CREATION EXPRESSIONS

Instance creation expressions create new instances of classes.

- Example:
  ```scala
  class Person(val name: String, val age: Int)
  val person = new Person("Alice", 25)
  ```

## BLOCKS

Blocks group multiple expressions and return the value of the last expression.

- Example:
  ```scala
  val result = {
    val x = 10
    val y = 20
    x + y
  }
  println(result) // Prints: 30
  ```

## PREFIX, INFIX, AND POSTFIX OPERATIONS

Scala supports various ways to write expressions using operators.

### Prefix Operations

Prefix operations apply a unary operator before its operand.

- Example:
  ```scala
  val x = -10
  val y = !true
  ```

### Postfix Operations

Postfix operations apply a method after its operand. This syntax is enabled by importing `scala.language.postfixOps`.

- Example:
  ```scala
  import scala.language.postfixOps
  val s = "Hello"
  println(s.toUpperCase)
  ```

### Infix Operations

Infix operations apply a method between its operands.

- Example:
  ```scala
  val sum = 1 + 2
  val str = "Hello" concat " World"
  ```

### Assignment Operators

Assignment operators assign values to variables, including combined operators like `+=`, `-=`, etc.

- Example:
  ```scala
  var x = 10
  x += 5 // x is now 15
  x *= 2 // x is now 30
  ```

## TYPED EXPRESSIONS

Typed expressions explicitly specify the type of an expression.

- Example:
  ```scala
  val x: Int = 10
  val y: String = "Hello"
  ```

## ANNOTATED EXPRESSIONS

Annotated expressions attach annotations to expressions for metadata or compiler hints.

- Example:
  ```scala
  @deprecated("Use newMethod instead")
  def oldMethod(): Unit = {}
  ```

## ASSIGNMENTS

Assignments set the value of a variable.

- Example:
  ```scala
  var x = 10
  x = 20
  ```

## CONDITIONAL EXPRESSIONS

Conditional expressions evaluate different expressions based on a condition.

- Example:
  ```scala
  val x = if (true) 1 else 0
  ```

## WHILE LOOP EXPRESSIONS

While loops repeatedly execute a block of code as long as a condition holds.

- Example:
  ```scala
  var i = 0
  while (i < 5) {
    println(i)
    i += 1
  }
  ```

## DO LOOP EXPRESSIONS

Do loops repeatedly execute a block of code as long as a condition holds, evaluating the condition after the block.

- Example:
  ```scala
  var i = 0
  do {
    println(i)
    i += 1
  } while (i < 5)
  ```

## FOR COMPREHENSIONS AND FOR LOOPS

For comprehensions are powerful looping constructs that can also produce new collections.

- Example:
  ```scala
  val numbers = List(1, 2, 3, 4, 5)
  val doubled = for (n <- numbers) yield n * 2
  val evenNumbers = for (n <- numbers if n % 2 == 0) yield n
  ```

## RETURN EXPRESSIONS

Return expressions exit from the nearest enclosing method, optionally returning a value.

- Example:
  ```scala
  def add(x: Int, y: Int): Int = {
    return x + y
  }
  ```

## THROW EXPRESSIONS

Throw expressions signal an error condition by throwing an exception.

- Example:
  ```scala
  throw new RuntimeException("Error occurred")
  ```

## TRY EXPRESSIONS

Try expressions handle exceptions using `try`, `catch`, and `finally` blocks.

- Example:
  ```scala
  try {
    val result = 10 / 0
  } catch {
    case e: ArithmeticException => println("Cannot divide by zero")
  } finally {
    println("Cleanup code here")
  }
  ```

## ANONYMOUS FUNCTIONS

Anonymous functions (lambdas) define functions without naming them.

- Example:
  ```scala
  val add = (x: Int, y: Int) => x + y
  println(add(2, 3))
  ```

## CONSTANT EXPRESSIONS

Constant expressions are expressions whose values are known at compile time.

- Example:
  ```scala
  val x = 10
  val y = x + 5
  ```

## STATEMENTS

Statements are units of execution in Scala, such as assignments, method calls, or control flow constructs.

- Example:
  ```scala
  val x = 10
  println(x)
  if (x > 5) println("x is greater than 5")
  ```

## IMPLICIT CONVERSIONS

Implicit conversions automatically convert values from one type to another.

### Value Conversions

Value conversions implicitly convert a value from one type to another.

- Example:
  ```scala
  implicit def intToString(x: Int): String = x.toString
  val str: String = 42
  ```

### Method Conversions

Method conversions implicitly convert methods into function values.

- Example:
  ```scala
  class MyClass {
    def greet(name: String): String = s

"Hello, $name"
  }
  val myClass = new MyClass
  val f: String => String = myClass.greet
  println(f("Scala"))
  ```

### Overloading Resolution

Overloading resolution uses implicit conversions to resolve ambiguous method calls.

- Example:
  ```scala
  def add(x: Int, y: Int): Int = x + y
  def add(x: String, y: String): String = x + y

  implicit def intToString(x: Int): String = x.toString
  println(add(1, 2))         // Calls Int version
  println(add("1", "2"))     // Calls String version
  println(add(1, "2"))       // Uses implicit conversion to String
  ```

### Local Type Inference

Local type inference determines the types of expressions within a local scope.

- Example:
  ```scala
  val x = 10 // Type inferred as Int
  val y = x + 5 // Type inferred as Int
  ```

### Eta Expansion

Eta expansion converts a method into a function value.

- Example:
  ```scala
  class MyClass {
    def greet(name: String): String = s"Hello, $name"
  }
  val myClass = new MyClass
  val f: String => String = myClass.greet _
  println(f("Scala"))
  ```

This manual provides a comprehensive overview of Scala's expression syntax and semantics, covering the essential aspects of working with expressions in Scala.
