public with sharing class FormResponseController {

    public List<Response> responses {get; set;}
    public Form_Response__c formResponse {
        get {
            this.responses = new List<Response>();
            if (formResponse.Account__c != null) {
                for (Form_Response__c formResponse : [select Name, Form_Title__c, Response__c from Form_Response__c where Account__c = :formResponse.Account__c]) {
                    responses.add(new Response(formResponse));
                }
            }
            return formResponse;
        }
        set;
    }

    public FormResponseController() {
        this.formResponse = new Form_Response__c();
        this.responses = new List<Response>();
    }

    @TestVisible private class Response {
        public Form_Response__c sob {get; set;}
        public List<Answer> answers {get; set;}

        public Response (Form_Response__c response) {
            this.sob = response;
            this.answers = new List<Answer>();

            for (FormResponse.Answer answer : (List<FormResponse.Answer>)JSON.deserialize(sob.Response__c, List<FormResponse.Answer>.class)) {
                answers.add(new Answer(answer));
            }
        }
    }

    @TestVisible private class Answer {
        public String question {get; set;}
        public String answer {get; set;}

        public Answer (FormResponse.Answer answer) {
            this.question = answer.question;
            this.answer = answer.answer;
        }
    }
}