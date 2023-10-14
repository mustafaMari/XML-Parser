public class XMLSerializer {

    private XMLObject objectToSerialize; 
    private String serializedObject;
    private XMLTagSerializer parentTagSerializer;

    public XMLSerializer(XMLObject objectToSerialize) {
        this.objectToSerialize = objectToSerialize;
        serializedObject = '';
    }

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