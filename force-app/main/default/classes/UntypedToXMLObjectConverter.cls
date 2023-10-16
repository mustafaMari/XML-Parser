public with sharing class UntypedToXMLObjectConverter {
    private Map<String, Object> untypedObject;
    private XMLObject convertedXMLObject;
    private String parentTagName;
    private Boolean treatFieldsAsKeys = false;
    private Boolean skipNullFields = true;
    private Set<String> keyNames;
    private Boolean hasKeys {
        get {
            return treatFieldsAsKeys || 
            (keyNames != null && !keyNames.isEmpty());
        }
    }

    public UntypedToXMLObjectConverter(Map<String, Object> untypedObject, String parentTagName) {
        this.untypedObject = untypedObject;
        this.parentTagName = parentTagName;
        convertedXMLObject = new XMLObject(parentTagName);
        convertedXMLObject.tagKeys = new Map<String, String>();
        convertedXMLObject.children = new List<XMLObject>();
    }

    public UntypedToXMLObjectConverter(Map<String, Object> untypedObject, String parentTagName, Boolean treatFieldsAsKeys, Boolean skipNullFields) {
        this(untypedObject, parentTagName);
        this.treatFieldsAsKeys = treatFieldsAsKeys;
        this.skipNullFields = skipNullFields;
    }

    public UntypedToXMLObjectConverter(Map<String, Object> untypedObject, String parentTagName, Set<String> keyNames, Boolean skipNullFields) {
        this(untypedObject, parentTagName);
        this.keyNames = keyNames;
        this.skipNullFields = skipNullFields;
    }

    public XMLObject convert() {
        appendTagparameters();
        return convertedXMLObject;
    }

    private String iteratedUntypedObjectKey;
    private void appendTagparameters() {
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
        convertedXMLObject.children.add(covnertChildObject((Map<String, Object>) untypedChildObject));
    }

    private void appendFieldAsChild(Object fieldObject) {
        Map<String, Object> untypedChild = new Map<String, Object> {
            iteratedUntypedObjectKey => (String) fieldObject
        };
        convertedXMLObject.children.add(covnertChildObject(untypedChild));
    }

    private void appendListAsObject(Object listObject) {
        for (Object item : (List<Object>) untypedObject.get(iteratedUntypedObjectKey)) {
            appendChildBasedOnType(item);
        }
    }

    private XMLObject covnertChildObject(Map<String, Object> untypedChildObject) {
        return new UntypedToXMLObjectConverter(untypedChildObject, iteratedUntypedObjectKey)
        .convert();
    }

}