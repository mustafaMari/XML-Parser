@IsTest
public class XMLTest {
    
    @IsTest
    static void serializeObjectWithAllFieldsAsKeysTest() {
        GetProductsRequest getProductsRequests = new GetProductsRequest();
        String requestXMLBody;
        Test.startTest(); 
        requestXMLBody = XML.serialize(getProductsRequests, 'PRODUCTS', true, false);
        Test.stopTest();
        String expectedRequestBody = '<PRODUCTS country="Poland" brand="Nike"><subcategory subcategoryId="2" categoryId="1"/><bounds upper="300" offset="0"/></PRODUCTS>';
        Assert.areEqual(expectedRequestBody, requestXMLBody);
    }

    @IsTest
    static void serializeObjectWithAllFieldsAsChildrenTest() {
        GetProductsRequest getProductsRequests = new GetProductsRequest();
        String requestXMLBody;
        Test.startTest(); 
        requestXMLBody = XML.serialize(getProductsRequests, 'PRODUCTS', false, false);
        Test.stopTest();
        String expectedRequestBody = '<PRODUCTS><subcategory><subcategoryId>2</subcategoryId><categoryId>1</categoryId></subcategory><country>Poland</country><brand>Nike</brand><bounds><upper>300</upper><offset>0</offset></bounds></PRODUCTS>';
        Assert.areEqual(expectedRequestBody, requestXMLBody);
    }

    @IsTest
    static void serializeObjectWithSpecificFieldsAsChildrenTest() {
        GetProductsRequest getProductsRequests = new GetProductsRequest();
        String requestXMLBody;
        Test.startTest(); 
        requestXMLBody = XML.serialize(getProductsRequests, 'PRODUCTS', new Set<String>{'categoryId', 'brand'}, false);
        Test.stopTest();
        String expectedRequestBody = '<PRODUCTS brand="Nike"><subcategory categoryId="1"><subcategoryId>2</subcategoryId></subcategory><country>Poland</country><bounds><upper>300</upper><offset>0</offset></bounds></PRODUCTS>';
        Assert.areEqual(expectedRequestBody, requestXMLBody);
    }

    @IsTest
    static void deserializeXMLStringToXMLObject() {
        String xmlToDeserialize = '<PRODUCTS country="Poland" brand="Nike"><subcategory categoryId="1" subcategoryId="2"/><bounds upper="300" offset="0"/></PRODUCTS>';
        XMLObject parentObject;
        XMLObject browseIdChild;
        XMLObject boundsChild;
        Test.startTest(); 
        parentObject = XML.deserialize(xmlToDeserialize);
        browseIdChild = XML.getSpecificChildInAPath(parentObject, new Set<String>{'subcategory'});
        boundsChild = XML.getSpecificChildInAPath(parentObject, new Set<String>{'bounds'});
        Test.stopTest();

        Assert.isTrue(parentObject != null);
        Assert.isTrue(parentObject.tagName == 'PRODUCTS');
        Assert.isTrue(parentObject.tagKeys.containsKey('brand'));
        Assert.isTrue(parentObject.tagKeys.containsKey('country'));

        Assert.isTrue(browseIdChild != null);
        Assert.isTrue(browseIdChild.tagName == 'subcategory');
        Assert.isTrue(browseIdChild.tagKeys.containsKey('categoryId'));
        Assert.isTrue(browseIdChild.tagKeys.containsKey('subcategoryId'));

        Assert.isTrue(boundsChild != null);
        Assert.isTrue(boundsChild.tagName == 'bounds');
        Assert.isTrue(boundsChild.tagKeys.containsKey('upper'));
        Assert.isTrue(boundsChild.tagKeys.containsKey('offset'));
    }

    



    public class GetProductsRequest {
        public String brand;
        public String country;
        public Subcategory subcategory;
        public Range bounds;

        public GetProductsRequest() {
            this.brand = 'Nike';
            this.country = 'Poland';
            this.subcategory = new Subcategory('1', '2');
            this.bounds = new Range(0, 300);
        }
    }

    public class Subcategory {
        public String categoryId;
        public String subcategoryId; 

        public Subcategory(String categoryId, String subcategoryId) {
            this.categoryId = categoryId;
            this.subcategoryId = subcategoryId;
        }
    }

    public class Range {
        public String offset;
        public String upper;
        
        public Range(Integer offset, Integer upper) {
            this.offset = String.valueOf(offset);
            this.upper = String.valueOf(upper);
        }
    }

}