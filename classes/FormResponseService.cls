public with sharing class FormResponseService {

    public static void retrieveResponses(String formId) {
        try {
            FormResponses formResponses = Typeform.retrieveResponses(formId);
            formResponses.saveNewResponses();
        } catch (Exception ex) {
            insert new Error__c(Description__c = ex.getMessage() + '; ' + ex.getStackTraceString());
        }
    }

}