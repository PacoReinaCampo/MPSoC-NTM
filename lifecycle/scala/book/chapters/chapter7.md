# IMPLICIT PARAMETERS AND VIEWS

Scala provides powerful features for implicit parameters and views, allowing for more concise and expressive code. These features are widely used for dependency injection, type class pattern, and other design patterns that rely on context-based information.

## THE IMPLICIT MODIFIER

The `implicit` modifier in Scala can be used in three contexts:
1. To declare an implicit parameter.
2. To declare an implicit value.
3. To define an implicit conversion (view).

- **Implicit Value**:
  ```scala
  implicit val defaultGreeting: String = "Hello"
  ```

- **Implicit Conversion**:
  ```scala
  implicit def intToString(x: Int): String = x.toString
  ```

## IMPLICIT PARAMETERS

Implicit parameters allow you to omit certain arguments when calling a function. If the omitted parameters are marked as `implicit`, Scala will search for an implicit value of the correct type in the current scope.

- **Example**:
  ```scala
  def greet(implicit greeting: String): Unit = {
    println(greeting)
  }

  implicit val defaultGreeting: String = "Hello, World!"
  greet // Prints: Hello, World!
  greet("Hi there!") // Prints: Hi there!
  ```

Implicit parameters can also be used with multiple parameter lists, with the last list being implicit.

- **Example**:
  ```scala
  def add(x: Int)(implicit y: Int): Int = x + y

  implicit val defaultY: Int = 5
  println(add(3)) // Prints: 8
  ```

## VIEWS

Implicit conversions, also known as views, allow Scala to automatically convert a value from one type to another when needed.

- **Example**:
  ```scala
  implicit def intToString(x: Int): String = x.toString

  val s: String = 42 // Automatically converts Int to String
  ```

Implicit conversions are defined using implicit methods or implicit classes.

- **Implicit Method**:
  ```scala
  implicit def doubleToInt(d: Double): Int = d.toInt
  val x: Int = 3.5 // Automatically converts Double to Int
  ```

- **Implicit Class**:
  ```scala
  implicit class RichInt(val x: Int) {
    def square: Int = x * x
  }

  val y = 4.square // Automatically enriches Int with the square method
  ```

## CONTEXT BOUNDS AND VIEW BOUNDS

### Context Bounds

Context bounds provide a concise syntax for specifying that an implicit value of a certain type must be available.

- **Example**:
  ```scala
  def sort[T: Ordering](list: List[T]): List[T] = {
    list.sorted
  }

  val sortedList = sort(List(3, 1, 2)) // Implicit Ordering[Int] is used
  ```

This is equivalent to:

- **Equivalent Example**:
  ```scala
  def sort[T](list: List[T])(implicit ord: Ordering[T]): List[T] = {
    list.sorted
  }
  ```

### View Bounds

View bounds (`<%`) specify that one type can be implicitly converted to another.

- **Example**:
  ```scala
  def printLength[T <% Int](x: T): Unit = {
    println(x)
  }

  implicit def stringToInt(s: String): Int = s.length
  printLength("Hello") // Prints: 5
  ```

However, view bounds are deprecated and it is recommended to use implicit parameters with context bounds or implicit conversions instead.

## MANIFESTS

Manifests provide runtime type information, which is otherwise erased by Scala's type erasure. Manifests are often used in conjunction with implicit parameters to preserve type information at runtime.

- **Example**:
  ```scala
  def arrayOf[T](implicit manifest: Manifest[T]): Array[T] = {
    new Array 
  }

  val intArray = arrayOf[Int] // Creates an Array[Int] of size 10
  ```

In Scala 2.10 and later, `Manifest` has been replaced by `ClassTag` and `TypeTag`.

- **Example with ClassTag**:
  ```scala
  import scala.reflect.ClassTag

  def arrayOf[T: ClassTag]: Array[T] = {
    new Array 
  }

  val stringArray = arrayOf[String] // Creates an Array[String] of size 10
  ```

This manual provides a detailed overview of Scala's implicit parameters and views, covering the implicit modifier, implicit parameters, implicit conversions, context bounds, view bounds, and manifests. These features are powerful tools for writing more flexible and concise Scala code.
