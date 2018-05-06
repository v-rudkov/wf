@isTest
global class TypeformMock implements HttpCalloutMock {

    global HTTPResponse respond(HTTPRequest req) {
        HttpResponse response = new HttpResponse();
        response.setHeader('Content-Type', 'application/json');
        response.setBody(Typeform_Test.payload);
        response.setStatusCode(200);
        return response;
    }

}