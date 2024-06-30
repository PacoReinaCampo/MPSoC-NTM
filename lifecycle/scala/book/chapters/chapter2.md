# IDENTIFIERS, NAMES, AND SCOPES

## IDENTIFIERS

Identifiers in Scala are used to name entities such as variables, methods, classes, objects, and packages. An identifier can be a sequence of letters, digits, underscores (`_`), and dollar signs (`$`), but it must not start with a digit. There are several categories of identifiers in Scala:

1. **Alphanumeric Identifiers**: These consist of letters and digits, where the first character must be a letter. 
   - Example: `myVar`, `MAX_SIZE`

2. **Operator Identifiers**: These consist of one or more operator characters, which include `+`, `-`, `*`, `/`, `:`, `=`, `<`, `>`, `!`, `%`, `^`, `&`, `|`, `~`, `?`, and `\`.
   - Example: `+`, `++`, `:=`

3. **Mixed Identifiers**: These start with an alphanumeric identifier followed by an underscore and an operator identifier.
   - Example: `unary_+`, `myVar_=` 

4. **Backtick Identifiers**: Any string enclosed in backticks can be used as an identifier, allowing the use of reserved words.
   - Example: `` `type` ``, `` `val` ``

## NAMES

Names in Scala refer to the symbolic representation of variables, methods, classes, objects, and other entities. Names must be valid identifiers and follow the rules for identifiers mentioned above. Names can be simple or qualified.

1. **Simple Names**: These are just plain identifiers.
   - Example: `myVar`, `calculateSum`

2. **Qualified Names**: These names are prefixed by a package name or an object name, separated by a dot (`.`).
   - Example: `scala.collection.mutable`, `myObject.myMethod`

## SCOPES

Scopes in Scala determine the visibility and lifetime of names and identifiers. Scopes are typically nested, and a name defined in an inner scope can shadow a name defined in an outer scope. There are several types of scopes in Scala:

1. **Local Scope**: The scope within a block of code, such as within a method or a loop.
   - Example:
     ```scala
     def example(): Unit = {
       val localVariable = 10
       println(localVariable)
     }
     ```

2. **Class Scope**: The scope within a class, including its methods and properties.
   - Example:
     ```scala
     class MyClass {
       val classVariable = 20
       def method(): Unit = {
         println(classVariable)
       }
     }
     ```

3. **Object Scope**: The scope within an object, similar to a class scope but for singleton objects.
   - Example:
     ```scala
     object MyObject {
       val objectVariable = 30
       def method(): Unit = {
         println(objectVariable)
       }
     }
     ```

4. **Package Scope**: The scope within a package, allowing access to members of the same package.
   - Example:
     ```scala
     package mypackage {
       class MyClass {
         val packageVariable = 40
       }
       object MyObject {
         def method(): Unit = {
           val instance = new MyClass
           println(instance.packageVariable)
         }
       }
     }
     ```

5. **Import Scope**: The scope created by import statements, which allows selective visibility of members from other packages.
   - Example:
     ```scala
     import scala.collection.mutable
     val buffer = new mutable.ArrayBuffer[Int]()
     ```

6. **Block Scope**: Any code enclosed within braces `{}` creates a block scope.
   - Example:
     ```scala
     {
       val blockVariable = 50
       println(blockVariable)
     }
     ```

## SHADOWING

Shadowing occurs when a name defined in an inner scope has the same name as one defined in an outer scope. The name in the inner scope "shadows" the name in the outer scope, making the outer name inaccessible within the inner scope.

- Example:
  ```scala
  val x = 10
  def method(): Unit = {
    val x = 20
    println(x) // Prints 20, not 10
  }
  ```

## VISIBILITY MODIFIERS

Scala provides several visibility modifiers to control the accessibility of members:

1. **Public**: Members are accessible from anywhere. This is the default visibility.
   - Example:
     ```scala
     class MyClass {
       val publicVar = 10
     }
     ```

2. **Private**: Members are accessible only within the same class or object.
   - Example:
     ```scala
     class MyClass {
       private val privateVar = 20
     }
     ```

3. **Protected**: Members are accessible within the same class and subclasses.
   - Example:
     ```scala
     class MyClass {
       protected val protectedVar = 30
     }
     ```

4. **Package Private**: Members are accessible within the same package using the `private[packageName]` syntax.
   - Example:
     ```scala
     package mypackage {
       class MyClass {
         private[mypackage] val packagePrivateVar = 40
       }
     }
     ```

By understanding identifiers, names, and scopes, Scala programmers can write more organized and maintainable code, ensuring proper visibility and lifetime of variables and other entities.
