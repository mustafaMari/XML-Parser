/**
 * Provides functionality to deserialize a Dom.XMLNode into an XMLObject.
 */
public class XMLTagDeserializer {
    private Dom.XMLNode nodeToDeserialize;
    private XMLObject deserializedNode;
    private Map<String, Object> deserializedUntyped;

    /**
     * Constructor for XMLTagDeserializer class.
     *
     * @param nodeToDeserialize The Dom.XMLNode to be deserialized into an XMLObject.
     */
    public XMLTagDeserializer(Dom.XMLNode nodeToDeserialize) {
        this.nodeToDeserialize = nodeToDeserialize;
        deserializedNode = new XMLObject(nodeToDeserialize.getName());
    }

    /**
     * Deserializes the XMLNode into an XMLObject.
     *
     * @return The deserialized XMLObject.
     */
    public XMLObject deserializeNode(){
        appendTagValue();
        appendTagKeys();
        appendTagChildren();
        return deserializedNode;
    }

    private void appendTagValue() {
        if (String.isBlank(nodeToDeserialize.getText())) {
            return;
        }
        deserializedNode.tagValue = nodeToDeserialize.getText();
    }

    private void appendTagKeys() {
        if(!canAppendTagKeys()) {
            return;
        }
        convertTagKeysToFields();
    }

    private void appendTagChildren() {
        if (!canAppendTagChildren()) {
            return;
        }
        convertTagChildrenToObjects();
    }

    private Boolean canAppendTagKeys() {
        return nodeToDeserialize.getAttributeCount() > 0;
    }

    private void convertTagKeysToFields() {
        deserializedNode.tagKeys = new Map<String, String>();
        for (Integer attributeIndex = 0; attributeIndex < nodeToDeserialize.getAttributeCount(); attributeIndex++) {
            appendTagKey(attributeIndex);
        }
    }

    private Boolean canAppendTagChildren() {
        return nodeToDeserialize.getChildren().size() > 0;
    }

    private void convertTagChildrenToObjects() {
        deserializedNode.children = new List<XMLObject>();
        for (Dom.XmlNode child : nodeToDeserialize.getChildren()) {
            convertChildToObject(child);
        }
    }

    private void appendTagKey(Integer attributeIndex) {
        String key = nodeToDeserialize.getAttributeKeyAt(attributeIndex);
        String keyValue = nodeToDeserialize.getAttribute(key, null);
        deserializedNode.tagKeys.put(key, keyValue);
    }

    private void convertChildToObject(Dom.XmlNode child) {
        if (String.isBlank(child.getName())) {
            return;
        }
        XMLTagDeserializer xmlChildDeserializer = new XMLTagDeserializer(child);
        deserializedNode.children.add(xmlChildDeserializer.deserializeNode());
    }

}