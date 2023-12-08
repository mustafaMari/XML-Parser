/**
 * Utility class for serializing and deserializing XMLObjects and handling XML-related operations.
 */
public class XML {
        
    /**
     * Serializes an object into an XML string.
     *
     * @param objectToSerialize The object to be serialized into XML.
     * @param parentTagName     The tag name for the parent XMLObject.
     * @param treatFieldsAsKeys Determines whether to treat fields as tag keys.
     * @param skipNullFields    Determines whether to skip null fields during serialization.
     * @return The serialized XML string.
     */
    public static String serialize(Object objectToSerialize, String parentTagName, Boolean treatFieldsAsKeys, Boolean skipNullFields) {
        XMLObject xmlObjectToSerialize = getXMLObjectToSerialize(objectToSerialize, parentTagName, treatFieldsAsKeys, skipNullFields);
        XMLSerializer serializer = new XMLSerializer(xmlObjectToSerialize);
        return serializer.serialize();
    }

    /**
     * Gets an XMLObject to serialize from an object using specified key names for tag keys.
     *
     * @param objectToSerialize The object to be converted into an XMLObject.
     * @param parentTagName     The tag name for the parent XMLObject.
     * @param treatFieldsAsKeys Determines whether to treat fields as tag keys.
     * @param skipNullFields    Determines whether to skip null fields during serialization.
     * @return The XMLObject prepared for serialization.
     */
    private static XMLObject getXMLObjectToSerialize(Object objectToSerialize, String parentTagName, Boolean treatFieldsAsKeys, Boolean skipNullFields) {
        String jsonSerializedObject = JSON.serialize(objectToSerialize);
        Map<String, Object> jsonUntypedDeserializedObject = (Map<String, Object>) JSON.deserializeUntyped(jsonSerializedObject);
        UntypedToXMLObjectConverter untypedToXMLObjectConverter = new UntypedToXMLObjectConverter(jsonUntypedDeserializedObject, parentTagName, treatFieldsAsKeys, skipNullFields);
        return untypedToXMLObjectConverter.convert();
    }

    /**
     * Serializes an object into an XML string using specific key names for tag keys.
     *
     * @param objectToSerialize The object to be serialized into XML.
     * @param parentTagName     The tag name for the parent XMLObject.
     * @param keyNames          Set of specific key names to be treated as tag keys.
     * @param skipNullFields    Determines whether to skip null fields during serialization.
     * @return The serialized XML string.
     */
    public static String serialize(Object objectToSerialize, String parentTagName, Set<String> keyNames, Boolean skipNullFields) {
        XMLObject xmlObjectToSerialize = getXMLObjectToSerialize(objectToSerialize, parentTagName, keyNames, skipNullFields);
        XMLSerializer serializer = new XMLSerializer(xmlObjectToSerialize);
        return serializer.serialize();
    }

    /**
     * Gets an XMLObject to serialize from an object using specified key names for tag keys.
     *
     * @param objectToSerialize The object to be converted into an XMLObject.
     * @param parentTagName     The tag name for the parent XMLObject.
     * @param keyNames          Set of specific key names to be treated as tag keys.
     * @param skipNullFields    Determines whether to skip null fields during serialization.
     * @return The XMLObject prepared for serialization.
     */
    private static XMLObject getXMLObjectToSerialize(Object objectToSerialize, String parentTagName, Set<String> keyNames, Boolean skipNullFields) {
        String jsonSerializedObject = JSON.serialize(objectToSerialize);
        Map<String, Object> jsonUntypedDeserializedObject = (Map<String, Object>) JSON.deserializeUntyped(jsonSerializedObject);
        UntypedToXMLObjectConverter untypedToXMLObjectConverter = new UntypedToXMLObjectConverter(jsonUntypedDeserializedObject, parentTagName, keyNames, skipNullFields);
        return untypedToXMLObjectConverter.convert();
    }

    /**
     * Deserializes an XML string into an XMLObject.
     *
     * @param xmlBody The XML body as a string to be deserialized.
     * @return The deserialized XMLObject.
     */
    public static XMLObject deserialize(String xmlBody) {
        XMLDeserializer deserializer = new XMLDeserializer(xmlBody);
        return deserializer.deserialize();
    }

    /**
     * Gets a specific child within a given path of XMLObjects.
     *
     * @param parentObject The parent XMLObject.
     * @param path         Set of tag names representing the path to the specific child.
     * @return The specific child XMLObject within the path.
     */
    public static XMLObject getSpecificChildInAPath(XMLObject parentObject, Set<String> path) {
        XMLObject currentParent = parentObject;
        for (String childName : path) {
            currentParent = getSpecificChild(currentParent, childName);
        }
        return currentParent;
    }

    /**
     * Gets a specific child by tag name within a parent XMLObject.
     *
     * @param parentObject    The parent XMLObject.
     * @param targetChildName The tag name of the specific child to retrieve.
     * @return The specific child XMLObject within the parent or null if not found.
     */
    private static XMLObject getSpecificChild(XMLObject parentObject, String targetChildName) {
        for (XMLObject child : parentObject.children) {
            if (child.tagName == targetChildName) {
                return child;
            }
        }
        return null;
    }
}