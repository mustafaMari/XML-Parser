/**
 * Provides functionality to deserialize an XML string into an XMLObject.
 */
public class XMLDeserializer {
    private String xmlBodyToDeserialize;
    private XMLObject deserializedObject;
    private Dom.Document xmlDocument;

    /**
     * Constructor for XMLDeserializer class.
     *
     * @param xmlBodyToDeserialize The XML body as a string to be deserialized.
     */
    public XMLDeserializer(String xmlBodyToDeserialize) {
        this.xmlBodyToDeserialize = xmlBodyToDeserialize;
    }

    /**
     * Deserializes the XML body into an XMLObject.
     *
     * @return The deserialized XMLObject.
     */
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