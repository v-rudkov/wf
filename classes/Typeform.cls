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
    }

    public class Choice {
        public String label;
    }

    public class Customer {
        public String uid;
    }

    public static String retrieveResponses(String formId) {

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

    public static Typeform.ResponsePayload deserialize(String payload) {
        return (Typeform.ResponsePayload)JSON.deserialize(payload, Typeform.ResponsePayload.class);
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