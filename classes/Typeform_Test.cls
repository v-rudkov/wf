@isTest
private class Typeform_Test {

    private static String payload =
        '{' +
            '"total_items" : 1,' +
            '"items" : [' +
                '{' +
                    '"hidden" : {' +
                       '"uid" : "0010Y00001RLY1e"' +
                    '},' +
                    '"token" : "c7daf651abb635ca399c7eabc75917f2",' +
                    '"landed_at" : "2018-04-28T14:49:59Z",' +
                    '"answers" : [' +
                        '{' +
                            '"field" : {"type" : "multiple_choice", "ref" : "9a4be218e1356747", "id" : "62405912"},' +
                            '"choice" : {' +
                                '"label" : "Between 18 and 65"' +
                            '},' +
                            '"type" : "choice"' +
                        '},' +
                        '{' +
                            '"type" : "email",' +
                            '"email" : "test@wefoxTest.de",' +
                            '"field" : {"type" : "email", "ref" : "14f669bbb33916e5", "id" : "62334414"}' +
                        '},' +
                        '{ ' +
                            '"type" : "yes_no",' +
                            '"field" : {"id" : "62405974", "ref" : "c27b5123e108324a", "type" : "yes_no" },' +
                            '"yes_no" : false' +
                        '},' +
                        '{' +
                            '"type" : "text",' +
                            '"text" : "WefoxTU03",' +
                            '"field" : {"type" : "short_text", "ref" : "ab0e74e99a61ee88", "id" : "62334344"}' +
                        '}' +
                    '],' +
                    '"submitted_at" : "2018-04-28T14:50:32Z"' +
                '}' +
            ']' +
        '}';

    @isTest static void testFixReservedKeywords_1() {
        System.assertEquals(
            '{ "type" : "yes_no", "field" : { "id" : "62405974", "ref" : "c27b5123e108324a", "type" : "yes_no" }, "yes_no" : false }',
            Typeform.fixReservedKeywords('{ "type" : "boolean", "field" : { "id" : "62405974", "ref" : "c27b5123e108324a", "type" : "yes_no" }, "boolean" : false }')
        );
    }

    @isTest static void testDeserialize_1() {
        Typeform.ResponsePayload deserialized= Typeform.deserialize(payload);
        System.assertEquals('0010Y00001RLY1e', deserialized.items[0].hidden.uid);
        System.assertEquals(Datetime.newInstanceGmt(2018, 4, 28, 14, 50, 32), deserialized.items[0].submitted_at);
        System.assertEquals('Between 18 and 65', deserialized.items[0].answers[0].choice.label);
        System.assertEquals(false, deserialized.items[0].answers[2].yes_no);
    }

    @isTest static void testGetTextAnswer_1() {
        Typeform.Answer answer = new Typeform.Answer();
        answer.type = 'choice';
        answer.choice = new Typeform.Choice();
        answer.choice.label = 'Between 18 and 65';

        System.assertEquals('Between 18 and 65', Typeform.getTextAnswer(answer));
    }

    @isTest static void testGetTextAnswer_2() {
        Typeform.Answer answer = new Typeform.Answer();
        answer.type = 'email';
        answer.email = 'test@example.com';

        System.assertEquals('test@example.com', Typeform.getTextAnswer(answer));
    }

    @isTest static void testGetTextAnswer_3() {
        Typeform.Answer answer = new Typeform.Answer();
        answer.type = 'text';
        answer.text = 'some text';

        System.assertEquals('some text', Typeform.getTextAnswer(answer));
    }

    @isTest static void testGetTextAnswer_4() {
        Typeform.Answer answer = new Typeform.Answer();
        answer.type = 'yes_no';
        answer.yes_no = false;

        System.assertEquals('false', Typeform.getTextAnswer(answer));
    }

    @isTest static void testConvertToFormAnswers_1() {
        List<Form_Answer__c> formAnswers = Typeform.convertToFormAnswers('nICm7F', Typeform.deserialize(payload));

        System.assertEquals('0010Y00001RLY1e', formAnswers[0].Account__c);
        System.assertEquals('nICm7F', formAnswers[0].Form_ID__c);
        System.assertEquals('Between 18 and 65', formAnswers[0].Answer__c);

        System.assertEquals('0010Y00001RLY1e', formAnswers[1].Account__c);
        System.assertEquals('nICm7F', formAnswers[1].Form_ID__c);
        System.assertEquals('test@wefoxTest.de', formAnswers[1].Answer__c);

        System.assertEquals('0010Y00001RLY1e', formAnswers[2].Account__c);
        System.assertEquals('nICm7F', formAnswers[2].Form_ID__c);
        System.assertEquals('false', formAnswers[2].Answer__c);

        System.assertEquals('0010Y00001RLY1e', formAnswers[3].Account__c);
        System.assertEquals('nICm7F', formAnswers[3].Form_ID__c);
        System.assertEquals('WefoxTU03', formAnswers[3].Answer__c);

    }
}