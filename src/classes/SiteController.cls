public with sharing class SiteController {

    @AuraEnabled
    public static List<Topic__c> getTopics(){
        return [SELECT Id, Name, Content__c, Date__c, like__c FROM Topic__c];
    }
    

    @AuraEnabled
    public static String deleteTopic(String id){
        Topic__c[] t = [SELECT Id, Name FROM Topic__c WHERE Id = :id LIMIT 1];
        String name ='';
        try {
            name = t[0].Name;
            delete t;
        } catch (DmlException e) {
            System.debug('Error from delete method ' + e.getMessage());
        }
        return name;
    }

    @AuraEnabled
    public static void setLikeField(String id, Boolean likeTopic) {
        Topic__c[] t = [SELECT Id, like__c FROM Topic__c WHERE Id = :id LIMIT 1];
        try {
           t[0].like__c = likeTopic; 
           update t;
        } catch (DmlException e) {
            System.debug('Error set Like ' + e.getMessage());
        }
    }


    
}