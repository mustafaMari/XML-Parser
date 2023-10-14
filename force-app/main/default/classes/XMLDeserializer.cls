public class XMLDeserializer {
    private String xmlBodyToDeserialize;
    private XMLObject deserializedObject;
    private Dom.Document xmlDocument;

    public XMLDeserializer(String xmlBodyToDeserialize) {
        this.xmlBodyToDeserialize = xmlBodyToDeserialize;
    }

    public XMLObject deserialize() {
        loadAndDeserializeXMLBody();
        return deserializedObject;
    }

    private void loadAndDeserializeXMLBody() {
        loadXMLBody();
        deserializeXMLBody();
    }

    private void loadXMLBody() {
        xmlDocument = new Dom.Document();
        xmlDocument.load(xmlBodyToDeserialize);
    }

    private void deserializeXMLBody() {
        XMLTagDeserializer xmlTagDeserializer = new XMLTagDeserializer(xmlDocument.getRootElement());
        deserializedObject = xmlTagDeserializer.deserializeNode();
    }

}