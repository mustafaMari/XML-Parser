# XML Utility

## Overview

This XML Utility provides a set of Apex classes designed to assist with XML manipulation in Salesforce Apex. It offers functionalities for serializing and deserializing XML data, allowing developers to convert between XML representation and structured data objects.

## Classes

### `XMLObject`

- Represents an XML object with tag name, tag keys, children, tag value, and helper properties.
- Provides functionalities to check for children, tag values, open or closed tags, and tag keys.

### `XML`

- Utility class providing serialization, deserialization, and XML-related operations.
- Methods include serialization of objects into XML strings, deserialization of XML strings into `XMLObject`, and handling XMLObject operations.

### `XMLSerializer`

- Serializes an `XMLObject` into XML strings.
- Constructs opening and closing tags, including tag values and keys.

### `XMLTagSerializer`

- Serializes an `XMLObject` into XML tags.
- Constructs opening and closing tags, including tag values and keys.

### `UntypedToXMLObjectConverter`

- Converts an untyped object (`Map<String, Object>`) into an `XMLObject`.
- Offers multiple constructors allowing flexibility in treating fields as keys, skipping null fields, and specifying key names as tag keys.

### `XMLDeserializer`

- Deserializes an XML string into an `XMLObject`.
- Loads the XML body as a string, creates a DOM document, and utilizes `XMLTagDeserializer` to convert the document into an `XMLObject`.

### `XMLTagDeserializer`

- Deserializes a `Dom.XMLNode` into an `XMLObject`.
- Handles deserialization of XML nodes, extracting tag values, keys, and children.

## Usage

### Serialization

To serialize an object into an XML string:

```java
Object objectToSerialize = ...; // Your object to serialize
String parentTagName = "RootElement"; // Tag name for the parent XMLObject
Boolean treatFieldsAsKeys = true; // Determine if fields should be treated as tag keys
Boolean skipNullFields = true; // Determine if null fields should be skipped

String serializedXML = XML.serialize(objectToSerialize, parentTagName, treatFieldsAsKeys, skipNullFields);
// 'serializedXML' contains the XML representation of the 'objectToSerialize'
```
To serialize an object with specific key names as tag keys:

```java
Object objectToSerialize = ...; // Your object to serialize
String parentTagName = "RootElement"; // Tag name for the parent XMLObject
Set<String> keyNames = new Set<String>{'key1', 'key2'}; // Specific key names to be treated as tag keys
Boolean skipNullFields = true; // Determine if null fields should be skipped

String serializedXML = XML.serialize(objectToSerialize, parentTagName, keyNames, skipNullFields);
// 'serializedXML' contains the XML representation of the 'objectToSerialize' using specified key names as tag keys
```
### Deserialization

To deserialize an XML string into an XMLObject:

```java
String xmlString = '<RootElement><ChildTag>Value</ChildTag></RootElement>'; // Your XML string
XMLObject deserializedObject = XML.deserialize(xmlString);
// 'deserializedObject' holds the structured representation of the XML string
```
### Working with XMLObject

To get a specific child within a given path of XMLObjects:

```java
XMLObject parentObject = ...; // Your parent XMLObject
Set<String> path = new Set<String>{'Child1', 'Child2', 'Child3'}; // Path to the specific child

XMLObject specificChild = XML.getSpecificChildInAPath(parentObject, path);
// 'specificChild' holds the last specified child within the provided path
```

## License

This code is provided under the [MIT License](LICENSE).