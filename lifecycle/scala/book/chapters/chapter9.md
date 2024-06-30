# TOP-LEVEL DEFINITIONS

Top-level definitions in Scala encompass various constructs that can be defined at the outermost level of a source file. These include compilation units, packagings, package objects, and package references. This section provides a detailed overview of these top-level definitions.

## COMPILATION UNITS

A compilation unit in Scala is a single source file. Each source file contains a series of top-level definitions, such as classes, objects, traits, and methods. The compiler processes each compilation unit individually.

- **Example**:
  ```scala
  // File: HelloWorld.scala
  object HelloWorld {
    def main(args: Array[String]): Unit = {
      println("Hello, world!")
    }
  }
  ```

## PACKAGINGS

Packagings allow you to organize your code into namespaces, preventing naming conflicts and making the codebase easier to manage. Packagings are defined using the `package` keyword.

- **Package Declaration**:
  ```scala
  package com.example

  object HelloWorld {
    def main(args: Array[String]): Unit = {
      println("Hello, world!")
    }
  }
  ```

- **Nested Package Declaration**:
  ```scala
  package com {
    package example {
      object HelloWorld {
        def main(args: Array[String]): Unit = {
          println("Hello, world!")
        }
      }
    }
  }
  ```

## PACKAGE OBJECTS

Package objects allow you to define methods, variables, and type aliases that are accessible within the package. They provide a way to add utility functions and constants that are specific to a package.

- **Example**:
  ```scala
  // File: com/example/package.scala
  package com

  package object example {
    val defaultGreeting: String = "Hello, world!"

    def greet(name: String): String = s"$defaultGreeting, $name!"
  }
  ```

  - Usage in another file:
  ```scala
  // File: com/example/HelloWorld.scala
  package com.example

  object HelloWorld {
    def main(args: Array[String]): Unit = {
      println(greet("Scala"))
    }
  }
  ```

## PACKAGE REFERENCES

Package references are used to refer to packages and their members. You can use the `import` statement to bring members of a package into the current scope.

- **Example**:
  ```scala
  import scala.collection.mutable

  object CollectionExample {
    def main(args: Array[String]): Unit = {
      val buffer = mutable.ArrayBuffer(1, 2, 3)
      println(buffer)
    }
  }
  ```

You can also use wildcards to import all members of a package or use renaming and aliasing for more control.

- **Wildcard Import**:
  ```scala
  import scala.collection.mutable._

  object CollectionExample {
    def main(args: Array[String]): Unit = {
      val buffer = ArrayBuffer(1, 2, 3)
      println(buffer)
    }
  }
  ```

- **Renaming and Aliasing**:
  ```scala
  import java.util.{Date => JDate, List => JList}

  object AliasingExample {
    def main(args: Array[String]): Unit = {
      val date = new JDate()
      println(date)
    }
  }
  ```

## PROGRAMS

A Scala program consists of one or more compilation units. The entry point of a Scala program is typically an object with a `main` method that takes an array of strings as arguments.

- **Example**:
  ```scala
  // File: HelloWorld.scala
  object HelloWorld {
    def main(args: Array[String]): Unit = {
      println("Hello, world!")
    }
  }
  ```

Scala programs can also be defined using the `App` trait, which provides a convenient way to create executable programs without explicitly defining a `main` method.

- **Example using `App` trait**:
  ```scala
  // File: HelloWorldApp.scala
  object HelloWorldApp extends App {
    println("Hello, world!")
  }
  ```

This manual provides a detailed overview of top-level definitions in Scala, including compilation units, packagings, package objects, package references, and the structure of Scala programs. These concepts are fundamental for organizing and structuring Scala code effectively.
