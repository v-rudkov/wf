public class FormResponses {

    private List<Form_Response__c> formResponses = new List<Form_Response__c>();

    public FormResponses(List<Form_Response__c> formResponses) {
        this.formResponses = formResponses;
    }

    public void saveNewResponses() {

        List<Error__c> errors = new List<Error__c>();

        Set<String> formIds = new Set<String>();
        for (Form_Response__c formResponse : formResponses) {
            formIds.add(formResponse.Form_ID__c);
        }


        Map<String, Form_Question__c> questions = new Map<String, Form_Question__c>();
        for (Form_Question__c question : [select Name, Title__c from Form_Question__c where Form__r.ID__c in :formIds]) {
            questions.put(question.Name, question);
        }

        for (Form_Response__c formResponse : formResponses) {
            List<FormResponse.Answer> answers = (List<FormResponse.Answer>)JSON.deserialize(formResponse.Response__c, List<FormResponse.Answer>.class);
            for (FormResponse.Answer answer : answers) {
                if (questions.containsKey(answer.questionId)) answer.question = questions.get(answer.questionId).Title__c;
            }
            formResponse.Response__c = JSON.serialize(answers);
        }

        Database.SaveResult[] results = Database.insert(formResponses, false);

        for(Integer i = 0; i < results.size(); i++) {
            if (!results[i].isSuccess()) {
                errors.add(new Error__c(Description__c = String.valueOf(formResponses[i]) + String.valueOf(results[i].getErrors())));
            }
        }
        insert errors;

    }
}