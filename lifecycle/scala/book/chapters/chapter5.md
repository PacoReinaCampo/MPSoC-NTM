# CLASSES AND OBJECTS

Scala supports object-oriented programming with a robust system for defining and using classes and objects. This section details the structure and features of classes and objects in Scala.

## TEMPLATES

Templates in Scala are blueprints for creating objects. They consist of class definitions, trait definitions, and object definitions. Templates include members such as fields, methods, and nested types.

### Constructor Invocations

Constructors are used to create instances of classes. Scala distinguishes between primary and auxiliary constructors.

- **Primary Constructor**: Defined as part of the class signature.
  ```scala
  class Person(val name: String, val age: Int)
  val person = new Person("Alice", 25)
  ```

- **Auxiliary Constructors**: Defined using `def this(...)` inside the class body.
  ```scala
  class Person(val name: String) {
    var age: Int = 0
    def this(name: String, age: Int) {
      this(name)
      this.age = age
    }
  }
  val person = new Person("Alice", 25)
  ```

### Class Linearization

Class linearization defines the order in which traits and classes are inherited. It ensures a consistent and predictable method resolution order.

- **Example**:
  ```scala
  trait A { def msg = "A" }
  trait B extends A { override def msg = "B" }
  trait C extends A { override def msg = "C" }
  class D extends B with C
  val d = new D
  println(d.msg) // Output: "C" (C overrides B)
  ```

### Class Members

Class members include fields, methods, nested classes, and traits. They can have different visibility modifiers.

- **Fields**:
  ```scala
  class Person {
    var name: String = "John"
    val age: Int = 30
  }
  ```

- **Methods**:
  ```scala
  class Calculator {
    def add(x: Int, y: Int): Int = x + y
  }
  ```

- **Nested Classes**:
  ```scala
  class Outer {
    class Inner {
      def innerMethod = "Inner method"
    }
  }
  val outer = new Outer
  val inner = new outer.Inner
  ```

### Overriding

Methods and fields in Scala can be overridden using the `override` keyword.

- **Example**:
  ```scala
  class Animal {
    def speak: String = "generic sound"
  }
  class Dog extends Animal {
    override def speak: String = "bark"
  }
  ```

### Inheritance Closure

Inheritance closure ensures that the initialization of fields and methods in inherited traits and classes is properly ordered and completed.

- **Example**:
  ```scala
  trait A { println("A") }
  trait B extends A { println("B") }
  class C extends B { println("C") }
  val c = new C // Output: A B C
  ```

### Early Definitions

Early definitions allow initializing parts of an object before the superclass constructor is called.

- **Example**:
  ```scala
  trait A { val message: String }
  class B extends { val message = "Hello" } with A {
    println(message)
  }
  ```

## MODIFIERS

Scala provides several modifiers to control the visibility and behavior of class members.

- **Access Modifiers**: `private`, `protected`, `public` (default)
  ```scala
  class Person {
    private var name: String = "John"
    protected val age: Int = 30
    def greet(): String = "Hello"
  }
  ```

- **Other Modifiers**:
  - `override`: Indicates that a member overrides a member in a superclass.
  - `final`: Prevents a class from being extended or a member from being overridden.
  - `sealed`: Restricts subclassing to within the same file.

## CLASS DEFINITIONS

Class definitions include the class keyword, the class name, optional type parameters, constructor parameters, and the class body.

### Constructor Definitions

Constructors initialize new instances of a class. Scala supports primary and auxiliary constructors.

- **Primary Constructor**:
  ```scala
  class Person(val name: String, val age: Int)
  ```

- **Auxiliary Constructors**:
  ```scala
  class Person(val name: String) {
    var age: Int = 0
    def this(name: String, age: Int) {
      this(name)
      this.age = age
    }
  }
  ```

### Case Classes

Case classes are special classes that come with built-in methods for pattern matching, immutability, and more.

- **Example**:
  ```scala
  case class Person(name: String, age: Int)
  val alice = Person("Alice", 25)
  val bob = Person("Bob", 30)
  ```

### Traits

Traits are abstract data types that define methods and fields which can be mixed into classes.

- **Example**:
  ```scala
  trait Greeting {
    def greet(name: String): String
  }
  class Greeter extends Greeting {
    def greet(name: String): String = s"Hello, $name"
  }
  ```

## OBJECT DEFINITIONS

Objects in Scala are singletons, meaning they have only one instance. They are defined using the `object` keyword.

- **Example**:
  ```scala
  object Singleton {
    def greet(): String = "Hello"
  }
  println(Singleton.greet())
  ```

Objects can also be used as companions to classes, providing factory methods or utility functions.

- **Companion Object**:
  ```scala
  class Person(val name: String, val age: Int)
  object Person {
    def apply(name: String, age: Int): Person = new Person(name, age)
  }
  val person = Person("Alice", 25)
  ```

This manual covers the basic and advanced concepts of classes and objects in Scala, providing the foundation for object-oriented programming in the language.
