/**
 * Provides functionality to serialize XMLObjects into an XML string.
 */
public class XMLSerializer {

    private XMLObject objectToSerialize; 
    private String serializedObject;
    private XMLTagSerializer parentTagSerializer;

    /**
     * Constructor for XMLSerializer class.
     *
     * @param objectToSerialize The XMLObject to be serialized.
     */
    public XMLSerializer(XMLObject objectToSerialize) {
        this.objectToSerialize = objectToSerialize;
        serializedObject = '';
    }

    /**
     * Serializes the XMLObject and its children into an XML string.
     *
     * @return The serialized XML string.
     */
    public String serialize() {
        openParentTag();
        appendChildren();
        closeParentTag();
        return serializedObject;
    }

    private void openParentTag(){
        parentTagSerializer = new XMLTagSerializer(objectToSerialize);
        serializedObject += parentTagSerializer.buildOpeningTag(); 
    }

    private void appendChildren() {
        if (!objectToSerialize.hasChildren) {
            return;
        }
        serializeAndAppendChildren();
    }

    private void closeParentTag() {
        serializedObject += parentTagSerializer.getClosingTag();
    }

    private void serializeAndAppendChildren() {
        for (XMLObject child : objectToSerialize.children) {
            serializedObject += serializeChild(child);
        }
    }

    private String serializeChild(XMLObject child) {
        XMLSerializer childSerializer = new XMLSerializer(child);
        return childSerializer.serialize();
    }
}