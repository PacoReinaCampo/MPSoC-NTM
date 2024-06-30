# XML EXPRESSIONS AND PATTERNS

Scala provides built-in support for XML literals, allowing XML expressions to be embedded directly within Scala code. XML patterns are also supported, enabling pattern matching against XML structures.

## XML EXPRESSIONS

XML expressions in Scala are written using XML literals, which are surrounded by backticks (\`) and braces ({ }). Scala XML literals closely resemble XML syntax.

- **Example**:
  ```scala
  val person = <person>
    <name>Alice</name>
    <age>30</age>
  </person>
  ```

- **Using Scala Expressions in XML**:
  ```scala
  val name = "Alice"
  val age = 30
  val person = <person>
    <name>{name}</name>
    <age>{age}</age>
  </person>
  ```

- **Multiple Lines**:
  ```scala
  val person = <person>
    <name>Alice</name>
    <age>30</age>
  </person>
  ```

## XML PATTERNS

XML patterns in Scala allow you to match against XML structures using pattern matching. This is particularly useful for extracting data from XML or verifying its structure.

- **Example**:
  ```scala
  val xml = <person>
    <name>Alice</name>
    <age>30</age>
  </person>

  xml match {
    case <person><name>{name}</name><age>{age}</age></person> =>
      println(s"Name: $name, Age: $age")
    case _ =>
      println("Not a valid person XML")
  }
  ```

- **Wildcard Patterns**:
  ```scala
  val xml = <person>
    <name>Alice</name>
    <age>30</age>
  </person>

  xml match {
    case <person>{_*}</person> =>
      println("Matched any person XML")
    case _ =>
      println("Not a valid person XML")
  }
  ```

- **Attribute Patterns**:
  ```scala
  val xml = <person age="30">Alice</person>

  xml match {
    case <person age={age}>{name}</person> =>
      println(s"Name: $name, Age: $age")
    case _ =>
      println("Not a valid person XML")
  }
  ```

## HANDLING XML IN SCALA

Scala's XML support includes various methods for handling XML, such as querying, transforming, and validating XML documents.

- **Querying XML**:
  ```scala
  val xml = <people><person><name>Alice</name></person><person><name>Bob</name></person></people>
  val names = (xml \ "person" \ "name").map(_.text)
  ```

- **Transforming XML**:
  ```scala
  val xml = <person><name>Alice</name><age>30</age></person>
  val transformed = xml match {
    case <person><name>{name}</name><age>{age}</age></person> =>
      <person>
        <fullName>{name}</fullName>
        <yearsOld>{age}</yearsOld>
      </person>
    case _ =>
      <error>Invalid person XML</error>
  }
  ```

- **Validating XML**:
  ```scala
  val xml = <person><name>Alice</name><age>30</age></person>
  val isValid = xml match {
    case <person><name>{_}</name><age>{age}</age></person> if age.text.toInt >= 18 =>
      true
    case _ =>
      false
  }
  ```

Scala's support for XML expressions and patterns allows seamless integration of XML data within Scala code. XML literals provide a familiar syntax for creating XML, while XML patterns enable pattern matching against XML structures, facilitating extraction and validation tasks. These features make Scala a versatile language for working with XML data in a concise and expressive manner.
