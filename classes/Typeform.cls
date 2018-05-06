public class Typeform {

    public class TypeformException extends Exception {}

    public class ResponsePayload {
        public List<Response> items;
    }

    public class Response {
        public String token;
        public Customer hidden;
        public Datetime submitted_at;
        public List<Answer> answers;
    }

    public class Answer {
        public String type;
        public String email;
        public String text;
        public Boolean yes_no;
        public Choice choice;
        public Field field;
    }

    public class Choice {
        public String label;
    }

    public class Field {
        public String id;
    }

    public class Customer {
        public String uid;
    }

    public static List<Form_Response__c> retrieveResponses(String formId) {
        return convertToFormResponses(
            formId,
            deserialize(fixReservedKeywords(sendRequest(formId)))
        );
    }

    @TestVisible
    private static String sendRequest(String formId) {

        HttpRequest request = new HttpRequest();

        request.setMethod('GET');
        request.setEndpoint(TypeformSettings__c.getInstance().Endpoint__c + 'forms/' + formId + '/responses');
        request.setHeader('Authorization', 'bearer ' + TypeformSettings__c.getInstance().Token__c);

        HttpResponse response = new Http().send(request);

        if (!String.valueOf(response.getStatusCode()).startsWith('2')) {
            throw new TypeformException ('Status Code: ' + response.getStatusCode() + ' - ' + response.getStatus());
        }

        return response.getBody();
    }

    @TestVisible
    private static String fixReservedKeywords(String payload) {
        String result = payload;
        result = result.replaceAll('"boolean"', '"yes_no"');
        return result;
    }

    @TestVisible
    private static Typeform.ResponsePayload deserialize(String payload) {
        return (Typeform.ResponsePayload)JSON.deserialize(payload, Typeform.ResponsePayload.class);
    }

    @TestVisible
    private static List<Form_Response__c> convertToFormResponses(String formId, Typeform.ResponsePayload payload) {
        List<Form_Response__c> result = new List<Form_Response__c>();

        for (Typeform.Response typeformResponse : payload.items) {

            if (typeformResponse.hidden.uid == null || typeformResponse.answers == null) continue; // form was submitted

            FormResponse formResponse = new FormResponse();
            formResponse.id = typeformResponse.token;
            formResponse.accountId = typeformResponse.hidden.uid;
            formResponse.formId = formId;
            formResponse.submittedDate = typeformResponse.submitted_at;
            formResponse.answers = JSON.serialize(convertToFormAnswers(typeformResponse.answers));
            result.add(formResponse.sob);
        }

        return result;
    }

    @TestVisible
    private static List<FormResponse.Answer> convertToFormAnswers(List<Typeform.Answer> typeformAnswers) {
        List<FormResponse.Answer> result = new List<FormResponse.Answer>();

        for (Typeform.Answer typeformAnswer : typeformAnswers) {
            result.add(new FormResponse.Answer(
                typeformAnswer.field.id,
                getTextAnswer(typeformAnswer)
            ));
        }
        return result;
    }

    @TestVisible
    private static String getTextAnswer(Typeform.Answer answer) {
        if (answer.type == 'choice') return answer.choice.label;
        if (answer.type == 'email') return answer.email;
        if (answer.type == 'text') return answer.text;
        if (answer.type == 'yes_no') return String.valueOf(answer.yes_no);
        return null;
    }
}