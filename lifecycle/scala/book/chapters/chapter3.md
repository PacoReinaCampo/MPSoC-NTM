# TYPES

Scala is a statically typed language, meaning the type of each expression is known at compile time. Types in Scala are classified into various categories, each serving different purposes in the type system. 

## PATHS

Paths are expressions used to refer to types and values. Paths can be classified into:

1. **Stable Identifiers**: These are names that refer to values that cannot be changed (e.g., `val`, `object`).
   * Example: `scala.Predef`
2. **Selections**: These are references to members of objects or packages.
   * Example: `scala.collection.mutable`
3. **This Type**: A reference to the current instance of a class or object.
   * Example: `this`, `MyClass.this`
4. **Super Type**: A reference to the superclass of the current instance.
   * Example: `super`, `MyClass.super`

## VALUE TYPES

Value types represent the types of values that can be assigned to variables. These include primitive types, singleton types, and compound types.

### Singleton Types

Singleton types refer to a single, specific instance of a value. These are useful for precise type definitions.

- Example:
  ```scala
  val x: 42 = 42
  val y: x.type = x
  ```

### Type Projection

Type projection allows accessing a type member of a path without requiring an instance of that type.

- Example:
  ```scala
  class Outer {
    class Inner
  }
  val x: Outer#Inner = new Outer().new Inner
  ```

### Type Designators

Type designators are names that refer to types. They can be simple names or qualified names.

- Example:
  ```scala
  type StringList = List[String]
  val myList: StringList = List("a", "b", "c")
  ```

### Parameterized Types

Parameterized types are types that take type parameters, commonly seen in collections.

- Example:
  ```scala
  val list: List[Int] = List(1, 2, 3)
  ```

### Tuple Types

Tuple types represent fixed-size collections of elements, each possibly of different types.

- Example:
  ```scala
  val tuple: (Int, String, Boolean) = (1, "hello", true)
  ```

### Annotated Types

Annotated types are types with additional metadata, often used with annotations.

- Example:
  ```scala
  @deprecated("use newMethod instead")
  def oldMethod(): Unit = {}
  ```

### Compound Types

Compound types combine multiple types into one, allowing an object to be of multiple types.

- Example:
  ```scala
  trait A
  trait B
  val obj: A with B = new A with B {}
  ```

### Infix Types

Infix types provide an alternate syntax for parameterized types, improving readability.

- Example:
  ```scala
  val pair: Int Either String = Left(42)
  ```

### Function Types

Function types represent functions, with parameters and return types.

- Example:
  ```scala
  val f: (Int, Int) => Int = (x, y) => x + y
  ```

### Existential Types

Existential types allow expressing types with unknown type parameters.

- Example:
  ```scala
  def processList(list: List[_]): Unit = {
    list.foreach(println)
  }
  ```

## NON-VALUE TYPES

Non-value types represent types that do not directly correspond to values, including method types and polymorphic types.

### Method Types

Method types represent methods, including parameter and return types.

- Example:
  ```scala
  def add(x: Int, y: Int): Int = x + y
  ```

### Polymorphic Method Types

Polymorphic method types are methods with type parameters, allowing generic programming.

- Example:
  ```scala
  def identity[T](x: T): T = x
  ```

### Type Constructors

Type constructors are abstractions that take type parameters and produce types.

- Example:
  ```scala
  trait Container[F[_]] {
    def create[T](value: T): F[T]
  }
  ```

## BASE TYPES AND MEMBER DEFINITIONS

Base types are the fundamental types in Scala, from which other types derive. Member definitions include fields, methods, and type members defined within classes, traits, and objects.

- Example:
  ```scala
  class Base {
    type T
    def method(x: Int): String = x.toString
  }
  ```

## RELATIONS BETWEEN TYPES

Understanding the relationships between types is crucial for type checking and type inference.

### Type Equivalence

Type equivalence determines whether two types are considered the same.

- Example:
  ```scala
  type A = Int
  type B = Int
  implicitly[A =:= B] // Proves A and B are equivalent
  ```

### Conformance

Type conformance (subtyping) determines whether one type is a subtype of another.

- Example:
  ```scala
  trait Animal
  trait Dog extends Animal
  val myDog: Animal = new Dog {}
  ```

### Weak Conformance

Weak conformance is a relaxed form of type conformance, allowing operations on mixed types.

- Example:
  ```scala
  val mixedList = List(1, 2.0, 3f)
  ```

## VOLATILE TYPES

Volatile types are types that can change over time, often used in multi-threaded contexts.

- Example:
  ```scala
  @volatile var counter: Int = 0
  ```

## TYPE ERASURE

Type erasure is the process by which type information is removed at runtime, used in JVM languages like Scala.

- Example:
  ```scala
  def processList(list: List[Int]): Unit = {
    println(list)
  }
  ```

Understanding these type concepts and their applications in Scala is essential for writing robust and type-safe Scala programs.
