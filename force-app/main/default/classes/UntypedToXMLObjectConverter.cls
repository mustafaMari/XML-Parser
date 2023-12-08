/**
 * Provides functionality to convert an untyped object (Map<String, Object>) into an XMLObject.
 */
public class UntypedToXMLObjectConverter {
    private Map<String, Object> untypedObject;
    private XMLObject convertedXMLObject;
    private String parentTagName;
    private Boolean treatFieldsAsKeys = false;
    private Boolean skipNullFields = true;
    private Set<String> keyNames;
    private String iteratedUntypedObjectKey;
    private Boolean hasKeys {
        get {
            return treatFieldsAsKeys || 
            (keyNames != null && !keyNames.isEmpty());
        }
    }

    /**
     * Constructor to create an UntypedToXMLObjectConverter instance for converting an untyped object into an XMLObject.
     *
     * @param untypedObject The untyped object to be converted into an XMLObject.
     * @param parentTagName The tag name for the parent XMLObject.
     *                      Represents the name of the XML tag that will encapsulate the converted content.
     */
    public UntypedToXMLObjectConverter(Map<String, Object> untypedObject, String parentTagName) {
        this.untypedObject = untypedObject;
        this.parentTagName = parentTagName;
        convertedXMLObject = new XMLObject(parentTagName);
        convertedXMLObject.tagKeys = new Map<String, String>();
        convertedXMLObject.children = new List<XMLObject>();
    }

    /**
     * Constructor to create an UntypedToXMLObjectConverter instance for converting an untyped object into an XMLObject
     * with the option to treat specific fields as tag keys and control handling of null fields.
     *
     * @param untypedObject     The untyped object to be converted into an XMLObject.
     * @param parentTagName     The tag name for the parent XMLObject.
     *                          Represents the name of the XML tag that will encapsulate the converted content.
     * @param treatFieldsAsKeys Determines whether to treat fields as tag keys.
     *                          If true, specific fields will be treated as tag keys.
     * @param skipNullFields    Determines whether to skip null fields during the conversion.
     *                          If true, null fields will be omitted in the resulting XMLObject.
     */
    public UntypedToXMLObjectConverter(Map<String, Object> untypedObject, String parentTagName, Boolean treatFieldsAsKeys, Boolean skipNullFields) {
        this(untypedObject, parentTagName);
        this.treatFieldsAsKeys = treatFieldsAsKeys;
        this.skipNullFields = skipNullFields;
    }

    /**
     * Constructor to create an UntypedToXMLObjectConverter instance for converting an untyped object into an XMLObject
     * with the option to specify certain fields as tag keys, allowing control over handling null fields.
     *
     * @param untypedObject     The untyped object to be converted into an XMLObject.
     * @param parentTagName     The tag name for the parent XMLObject.
     *                          Represents the name of the XML tag that will encapsulate the converted content.
     * @param keyNames          Set of specific key names to be treated as tag keys.
     *                          Fields included in this set will be considered as tag keys during conversion.
     * @param skipNullFields    Determines whether to skip null fields during the conversion.
     *                          If true, null fields will be omitted in the resulting XMLObject.
     */
    public UntypedToXMLObjectConverter(Map<String, Object> untypedObject, String parentTagName, Set<String> keyNames, Boolean skipNullFields) {
        this(untypedObject, parentTagName);
        this.keyNames = keyNames;
        this.skipNullFields = skipNullFields;
    }


    /**
     * Converts the untyped object into an XMLObject.
     *
     * @return The converted XMLObject.
     */
    public XMLObject convert() {
        appendTagParameters();
        return convertedXMLObject;
    }

    private void appendTagParameters() {
        for (String untypedObjectKey : untypedObject.keySet()) {
            if (untypedObject.get(untypedObjectKey) == null && skipNullFields) {
                continue;
            }
            iteratedUntypedObjectKey = untypedObjectKey;
            handleUntypedObjectKey();
        }
    }

    private void handleUntypedObjectKey() {
        if (iteratedUntypedObjectKey == parentTagName) {
            appendTagValue();
            return;
        }
        if (hasKeys && isUntypedKeyATagKey()) {
            convertedXMLObject.tagKeys.put(iteratedUntypedObjectKey, (String) untypedObject.get(iteratedUntypedObjectKey));
            return;
        }
        appendChild();
    }


    private void appendTagValue() {
        if (untypedObject.containsKey(parentTagName)) {
            convertedXMLObject.tagValue = (String) untypedObject.get(parentTagName);
        }
    }

    private Boolean isUntypedKeyATagKey() {
        if (keyNames != null && keyNames.contains(iteratedUntypedObjectKey)) {
            return true;
        }
        if (treatFieldsAsKeys) {
            return untypedObject.get(iteratedUntypedObjectKey) instanceOf String;
        }
        return false;
    }

    private void appendChild() {
        appendChildBasedOnType(untypedObject.get(iteratedUntypedObjectKey));
    }

    private void appendChildBasedOnType(Object specificChild) {
        if (specificChild instanceOf Map<String, Object>) {
            appendUntypedObjectAsChild(specificChild);
            return;
        }

        if (specificChild instanceOf String) {
            appendFieldAsChild(specificChild);
            return;
        }

        if (specificChild instanceOf List<Object>) {
            appendListAsObject(specificChild);
            return;
        }
    }

    private void appendUntypedObjectAsChild(Object untypedChildObject) {
        convertedXMLObject.children.add(convertChildObject((Map<String, Object>) untypedChildObject));
    }

    private void appendFieldAsChild(Object fieldObject) {
        Map<String, Object> untypedChild = new Map<String, Object> {
            iteratedUntypedObjectKey => (String) fieldObject
        };
        convertedXMLObject.children.add(convertChildObject(untypedChild));
    }

    private void appendListAsObject(Object listObject) {
        for (Object item : (List<Object>) untypedObject.get(iteratedUntypedObjectKey)) {
            appendChildBasedOnType(item);
        }
    }

    private XMLObject convertChildObject(Map<String, Object> untypedChildObject) {
        return getChildUntypedConverter(untypedChildObject)
        .convert();
    }

    private UntypedToXMLObjectConverter getChildUntypedConverter(Map<String, Object> untypedChildObject) {
        if (keyNames != null && !keyNames.isEmpty()) {
            return new UntypedToXMLObjectConverter(untypedChildObject, iteratedUntypedObjectKey, keyNames, skipNullFields);
        }
        return new UntypedToXMLObjectConverter(untypedChildObject, iteratedUntypedObjectKey, treatFieldsAsKeys, skipNullFields);
    }

}