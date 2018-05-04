public class Typeform {

    public class TypeformException extends Exception {}

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

}