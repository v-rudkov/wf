public class FormResponses {

    private List<Form_Response__c> formResponses = new List<Form_Response__c>();

    public FormResponses(List<Form_Response__c> formResponses) {
        this.formResponses = formResponses;
    }

    public void saveNewResponses() {

        List<Error__c> errors = new List<Error__c>();
        Database.SaveResult[] results = Database.insert(formResponses, false);

        for(Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                errors.add(new Error__c(Description__c = String.valueOf(formResponses[i]) + String.valueOf(results[i].getErrors())));
            }
        }
        insert errors;

    }
}