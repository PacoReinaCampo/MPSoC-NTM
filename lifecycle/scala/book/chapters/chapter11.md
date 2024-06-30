# USER-DEFINED ANNOTATIONS

Annotations in Scala provide metadata about classes, methods, fields, or expressions. They can be used for various purposes such as documentation, optimization hints, and runtime checks. Scala allows you to define your own annotations using the `@annotation` or `@Annotation` syntax.

## DECLARING ANNOTATIONS

To declare a user-defined annotation in Scala, you typically use the `@annotation` annotation and define it as a trait or class that extends `scala.annotation.StaticAnnotation`.

- **Example: Simple Annotation**
  ```scala
  import scala.annotation._

  @annotation.myAnnotation
  class MyClass {
    @annotation.myAnnotation
    def myMethod(): Unit = {
      // Method body
    }
  }

  object annotation {
    class myAnnotation extends StaticAnnotation
  }
  ```

## APPLYING ANNOTATIONS

Annotations can be applied to classes, methods, fields, or expressions by placing them directly before the declaration.

- **Example: Applying Annotations**
  ```scala
  @annotation.myAnnotation
  class MyClass {
    @annotation.myAnnotation
    def myMethod(@annotation.myAnnotation param: Int): Unit = {
      // Method body
    }
  }
  ```

## ANNOTATION ARGUMENTS

Annotations can optionally have arguments, which can be used to customize their behavior.

- **Example: Annotation with Arguments**
  ```scala
  import scala.annotation._

  @annotation.myAnnotation("value")
  class MyClass {
    @annotation.myAnnotation("value")
    def myMethod(@annotation.myAnnotation("value") param: Int): Unit = {
      // Method body
    }
  }

  object annotation {
    class myAnnotation(value: String) extends StaticAnnotation
  }
  ```

## RETENTION POLICIES

Annotations in Scala can have different retention policies:
- **Source**: Annotations are discarded by the compiler and are not included in the class files.
- **Class**: Annotations are recorded in the class file by the compiler but are not available at runtime.
- **Runtime**: Annotations are recorded in the class file by the compiler and can be accessed via reflection at runtime.

By default, Scala annotations are retained at runtime unless explicitly specified otherwise.

- **Example: Annotation with Retention Policy**
  ```scala
  import scala.annotation._

  @Retention(RetentionPolicy.RUNTIME)
  @annotation.myAnnotation
  class MyClass {
    @Retention(RetentionPolicy.RUNTIME)
    @annotation.myAnnotation
    def myMethod(): Unit = {
      // Method body
    }
  }

  object annotation {
    import java.lang.annotation._

    @Retention(RetentionPolicy.RUNTIME)
    class myAnnotation extends StaticAnnotation
  }
  ```

## BUILT-IN ANNOTATIONS

Scala also provides several built-in annotations that serve various purposes:
- `@deprecated`: Marks a method or class as deprecated.
- `@tailrec`: Ensures that a method is tail-recursive.
- `@unchecked`: Suppresses unchecked warnings.

## USING ANNOTATIONS

Annotations can be used for a variety of purposes, including:
- Compiler optimizations and warnings
- Runtime checks and validations
- Code generation and documentation tools

User-defined annotations in Scala provide a flexible mechanism for attaching metadata to code elements. They can be customized with arguments and have different retention policies to control their visibility at compile-time and runtime. Annotations are useful for documenting code, enforcing constraints, and integrating with external tools and libraries, enhancing the expressiveness and functionality of Scala programs.
