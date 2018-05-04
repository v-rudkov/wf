@isTest
private class Typeform_Test {

    @isTest static void testFixReservedKeywords_1() {
        System.assertEquals(
            '{ "type" : "yes_no", "field" : { "id" : "62405974", "ref" : "c27b5123e108324a", "type" : "yes_no" }, "yes_no" : false }',
            Typeform.fixReservedKeywords('{ "type" : "boolean", "field" : { "id" : "62405974", "ref" : "c27b5123e108324a", "type" : "yes_no" }, "boolean" : false }')
        );
    }
}