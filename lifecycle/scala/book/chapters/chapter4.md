# BASIC DECLARATIONS AND DEFINITIONS

Scala provides a rich syntax for declaring and defining values, variables, types, functions, and imports. This section covers these fundamental concepts in detail.

## VALUE DECLARATIONS AND DEFINITIONS

Values in Scala are immutable, meaning they cannot be changed once assigned. They are declared using the `val` keyword.

- **Declaration**: Specifies the type of the value without assigning it immediately (rarely used in practice because `val` must be initialized).
- **Definition**: Assigns a value to a name.

- Example:
  ```scala
  val x: Int = 10 // Declaration and definition
  val y = 20      // Type inference
  ```

## VARIABLE DECLARATIONS AND DEFINITIONS

Variables in Scala are mutable, meaning they can be reassigned. They are declared using the `var` keyword.

- **Declaration**: Specifies the type of the variable without assigning it immediately.
- **Definition**: Assigns a value to a variable.

- Example:
  ```scala
  var a: Int = 5 // Declaration and definition
  a = 10         // Reassigning the variable
  var b = 15     // Type inference
  ```

## TYPE DECLARATIONS AND TYPE ALIASES

Type declarations introduce a new type name, which is an alias for an existing type. They are declared using the `type` keyword.

- Example:
  ```scala
  type StringList = List[String]
  val names: StringList = List("Alice", "Bob", "Charlie")
  ```

## TYPE PARAMETERS

Type parameters allow the definition of generic classes, traits, and methods that can operate on different types.

- **Generic Class**:
  ```scala
  class Box[T](value: T) {
    def get: T = value
  }
  val intBox = new Box 
  val stringBox = new Box[String]("Hello")
  ```

- **Generic Method**:
  ```scala
  def identity[T](x: T): T = x
  val intId = identity(42)
  val stringId = identity("Scala")
  ```

## VARIANCE ANNOTATIONS

Variance annotations control how type parameters behave in relation to subtyping. There are three types of variance:

- **Covariant**: `+T` means that for a type `A` and `B`, if `A` is a subtype of `B`, then `Box[A]` is a subtype of `Box[B]`.
   * Example:
    ```scala
    class Box[+T](value: T) {
      def get: T = value
    }
    ```

- **Contravariant**: `-T` means that for a type `A` and `B`, if `A` is a subtype of `B`, then `Box[B]` is a subtype of `Box[A]`.
   * Example:
    ```scala
    trait Printer[-T] {
      def print(value: T): Unit
    }
    ```

- **Invariant**: No variance annotation means that `Box[A]` and `Box[B]` are unrelated unless `A` and `B` are exactly the same type.

## FUNCTION DECLARATIONS AND DEFINITIONS

Functions in Scala can be declared and defined with various features like by-name parameters, repeated parameters, and procedures.

### By-Name Parameters

By-name parameters are evaluated every time they are accessed within the function.

- Example:
  ```scala
  def byNameExample(x: => Int): Int = x * x
  val result = byNameExample {
    println("Evaluating x")
    10
  }
  // Output: Evaluating x
  //         Evaluating x
  ```

### Repeated Parameters

Repeated parameters (varargs) allow passing a variable number of arguments to a function.

- Example:
  ```scala
  def printAll(args: String*): Unit = {
    args.foreach(println)
  }
  printAll("one", "two", "three")
  ```

### Procedures

Procedures are functions that do not return a value (their return type is `Unit`).

- Example:
  ```scala
  def printMessage(message: String): Unit = {
    println(message)
  }
  ```

### Method Return Type Inference

Scala can often infer the return type of methods, making the code more concise.

- Example:
  ```scala
  def add(x: Int, y: Int) = x + y
  // The return type Int is inferred
  ```

## IMPORT CLAUSES

Import clauses allow including external and internal packages, classes, and objects into the current scope. Scala imports are more flexible and fine-grained compared to Java.

- **Single Import**: 
  ```scala
  import scala.collection.mutable.ArrayBuffer
  ```

- **Wildcard Import**: 
  ```scala
  import scala.collection.mutable._
  ```

- **Renaming Import**: 
  ```scala
  import java.util.{Date => UtilDate}
  val date = new UtilDate()
  ```

- **Selective Import**: 
  ```scala
  import scala.collection.mutable.{Map, Set}
  ```

These basic declarations and definitions form the foundation for writing Scala code, enabling the definition of variables, functions, types, and the inclusion of necessary libraries and packages.
