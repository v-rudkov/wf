public class FormResponse {

    public class Answer {
        public String questionId;
        public String question;
        public String answer;

        public Answer(String questionId, String answer) {
            this.questionId = questionId;
            this.answer = answer;
        }
    }

    public Form_Response__c sob {
        get;
        private set;
    }
    public String id {
        get;
        set {
            id = value;
            sob.Name = value;
        }
    }
    public String accountId {
        get;
        set {
            try {
                accountId = value;
                sob.Account__c = value;
            } catch (Exception ex) {}
        }
    }
    public String formId {
        get;
        set {
            formId = value;
            sob.Form_ID__c = value;
        }
    }
    public Datetime submittedDate {
        get;
        set {
            submittedDate = value;
            sob.Submitted_Date__c = value;
        }
    }

    public String answers {
        get;
        set {
            answers = value;
            sob.Response__c = value;
        }
    }

    public FormResponse() {
        sob = new Form_Response__c();
    }

    public FormResponse(String accountId, String formId) {
    }

}