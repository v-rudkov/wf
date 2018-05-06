global class FormResponseJob implements Database.Batchable<sObject>, Schedulable, Database.AllowsCallouts {

    global String query = 'select ID__c from Form__c';

    global Database.QueryLocator start(Database.BatchableContext BC){
        return Database.getQueryLocator(query);
    }

    global void execute(SchedulableContext sc) {
        Database.executeBatch(this, 1);
    }

    global void execute(Database.BatchableContext BC, List<Form__c> scope){
        for (Form__c form : scope) {
            FormResponseService.retrieveResponses(form.ID__c);
        }
    }

    global void finish(Database.BatchableContext BC){}

}