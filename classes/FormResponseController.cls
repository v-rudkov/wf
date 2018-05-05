public with sharing class FormResponseController {

    public List<Response> responses {get; set;}

    public FormResponseController() {
        this.responses = new List<Response>();
        for (Form_Response__c formResponse : [select Name, Response__c from Form_Response__c]) {
            responses.add(new Response(formResponse));
        }
    }

    @TestVisible private class Response {
        public Form_Response__c sob {get; set;}
        public List<Answer> answers {get; set;}

        public Response (Form_Response__c response) {
            this.sob = response;
            this.answers = new List<Answer>();

            for (Typeform.Answer answer : (List<Typeform.Answer>)JSON.deserialize(sob.Response__c, List<Typeform.Answer>.class)) {
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