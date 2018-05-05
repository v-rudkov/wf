public with sharing class FormResponseExtentions {

    private Form_Response__c formResponse;
    public List<Answer> answers {get;set;}

    public FormResponseExtentions() {}

    public FormResponseExtentions(ApexPages.StandardController controller) {
        this.formResponse = [select Response__c from Form_Response__c where id = :controller.getId()];
        answers = new List<Answer>();
        if (String.isNotEmpty(formResponse.Response__c)) {
            for (Typeform.Answer answer : (List<Typeform.Answer>)JSON.deserialize(formResponse.Response__c, List<Typeform.Answer>.class)) {
                answers.add(new Answer(answer));
            }
        }
    }

    @TestVisible private class Answer {
        public String question {get; set;}
        public String answer {get; set;}

        public Answer (Typeform.Answer answer) {
            this.question = 'question';
            this.answer = answer.type;
        }
    }
}