public class XMLTagSerializer {

    private static final String OPENING_TAG_START = '<';
    private static final String CLOSING_TAG_START = '</';
    private static final String TAG_END = '>'; 
    private static final String OPEN_CLOSED_TAG_END = '/>';
    private XMLObject xmlTag;
    
    public XMLTagSerializer(XMLObject xmlTag) {
        this.xmlTag = xmlTag;
    }

    public String buildOpeningTag(){
        return getOpeningTag() + 
        getTagValue();
    }

    private String getOpeningTag() {
        return OPENING_TAG_START + 
        xmlTag.tagName + 
        getTagKeys() + 
        getOpeningTagEnd();
    }

    private String getTagValue(){
        if (!xmlTag.hasValue){
            return '';
        }
        return xmlTag.tagValue;
    }

    private String getTagKeys() {
        if (!xmlTag.hasKeys) {
            return '';
        }
        return wrapTagKeys(); 
    }

    private String getOpeningTagEnd() {
        if (xmlTag.openClosedTag) {
            return OPEN_CLOSED_TAG_END;
        }
        return TAG_END;
    }

    private String wrapTagKeys() {
        String tagKeys = '';
        for (String key : xmlTag.tagKeys.keySet()) {
            tagKeys += wrapKey(key);
        }
        return tagKeys;
    }

    private String wrapKey(String key) {
        return ' ' + 
        key + 
        '="' + 
        xmlTag.tagKeys.get(key) + 
        '"';
    }

    public String getClosingTag() {
        System.debug('getClosingTag: ' + xmlTag.openClosedTag);
        if (xmlTag.openClosedTag){
            return '';
        }
        return wrapClosingTag();
    }
    private String wrapClosingTag() {
        return CLOSING_TAG_START + 
        xmlTag.tagName + 
        TAG_END;
    }
}