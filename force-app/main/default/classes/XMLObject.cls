public class XMLObject {
    public String tagName;
    public Map<String, String> tagKeys;
    public List<XMLObject> children;
    public String tagValue;
    public Boolean hasChildren {
        get {
            return children != null && !children.isEmpty();
        }
    }
    public Boolean hasValue {
        get {
            return tagValue != null;
        }
    }
    public Boolean openClosedTag {
        get{
            return !hasChildren && !hasValue;
        }
    }
    public Boolean hasKeys {
        get {
            return tagKeys != null && !tagKeys.isEmpty();
        }
    }

    public XMLObject(String tagName) {
        this.tagName = tagName;
    }
}