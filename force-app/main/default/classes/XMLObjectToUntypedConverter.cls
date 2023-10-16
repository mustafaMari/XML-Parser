public class XMLObjectToUntypedConverter {
    private XMLObject xmlObjectToCovert;
    private Map<String, Object> untypedObject;
    private XMLObject xmlChild;
    private Map<String, Object> untypedChild;

    public XMLObjectToUntypedConverter(XMLObject xmlObjectToCovert) {
        this.xmlObjectToCovert = xmlObjectToCovert;
        untypedObject = new Map<String, Object>();
    }

    public Map<String, Object> convert(){
        appendTagValue();
        appendTagKeys();
        appendChildren();
        return untypedObject;
    }

    private void appendTagValue() {
        if (xmlObjectToCovert.hasValue) {
            untypedObject.put(xmlObjectToCovert.tagName, xmlObjectToCovert.tagValue);
        }
    }

    private void appendTagKeys() {
        if (xmlObjectToCovert.hasKeys) {
            untypedObject.putAll(xmlObjectToCovert.tagKeys);
        }
    }

    private void appendChildren() {
        if (!xmlObjectToCovert.hasChildren) {
            return;
        }
        convertTagChildrenToUntyped();
    }

    private void convertTagChildrenToUntyped() {
        for (XMLObject child : xmlObjectToCovert.children) {
            this.xmlChild = child;
            convertTagChildToUntyped();
        }
    }

    private void convertTagChildToUntyped() {
        untypedChild = new XMLObjectToUntypedConverter(xmlChild).convert();
        appendUntypedChild();
    }

    private void appendUntypedChild() {
        if (!untypedObject.containsKey(xmlChild.tagName)) {
            untypedObject.put(xmlChild.tagName, untypedChild);
            return;
        }
        appendUntypedChildToList();
    }

    private void appendUntypedChildToList() {
        Object existingChildTag = untypedObject.get(xmlChild.tagName);
        if (existingChildTag instanceOf List<Object>) {
            ((List<Object>)existingChildTag).add(untypedChild);
            return;
        }
        createNewListForUntypedChild();
    }

    private void createNewListForUntypedChild() {
        List<Object> elementList = new List<Object> {
            untypedObject.get(xmlChild.tagName),
            untypedChild
        };
        untypedObject.put(xmlChild.tagName, elementList);
    }

}