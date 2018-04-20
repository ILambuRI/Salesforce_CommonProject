public class L_AccountProjectController {

    @AuraEnabled 
    public static String getAccountsWithProject(){

        if (!Schema.getGlobalDescribe().get('Account').getDescribe().isAccessible()
                || !Schema.getGlobalDescribe().get('Project__c').getDescribe().isAccessible()){
            throw new AuraHandledException('Access error');
        }

        Account[] accountWithProjectsList = [SELECT id, Name,(SELECT id, Name, Team_Members__c
                                                                FROM Projects__r)
                                            FROM Account
                                            WHERE Id IN (SELECT Account__c FROM Project__c)
                                            ORDER BY Name 
                                            LIMIT 20];

        List<AccountWithProjectsWrapper> accountWithProjectsWrapperList = new List<AccountWithProjectsWrapper>();
        for(Account accountWithProjects : accountWithProjectsList){
            AccountWithProjectsWrapper accountProject = new AccountWithProjectsWrapper();
            accountProject.accountId = accountWithProjects.Id;
            accountProject.accountName = accountWithProjects.Name;
            accountProject.accountProjects = (Project__c[])accountWithProjects.Projects__r;
            accountWithProjectsWrapperList.add(accountProject);
        }
        return JSON.serialize(accountWithProjectsWrapperList);
    }

    @AuraEnabled 
    public static String getAccountProjects(Id accountId){

        if (!Schema.getGlobalDescribe().get('Account').getDescribe().isAccessible()
                || !Schema.getGlobalDescribe().get('Project__c').getDescribe().isAccessible()){
            throw new AuraHandledException('Access error');
        }

        Account[] accountWithProjectsList;
        try{
            accountWithProjectsList = [SELECT Id,Name,(SELECT id,Name 
                                                            FROM Projects__r) 
                                            FROM Account
                                            WHERE Id = :accountId];
        }catch(DmlException e){
            throw new AuraHandledException('You try to break us');
        }
        List<AccountWithProjectsWrapper> accountWithProjectsWrapperList = new List<AccountWithProjectsWrapper>();
        for(Account accountWithProjects : accountWithProjectsList){
            if((Integer)accountWithProjects.Projects__r.size() > 0){
                AccountWithProjectsWrapper accountProject = new AccountWithProjectsWrapper();
                accountProject.accountId = accountWithProjects.Id;
                accountProject.accountName = accountWithProjects.Name;
                accountProject.accountProjects = (Project__c[])accountWithProjects.Projects__r;
                accountWithProjectsWrapperList.add(accountProject);
            }
        }
        return JSON.serialize(accountWithProjectsWrapperList);
    }

    public class AccountWithProjectsWrapper{
        public String accountName {get;set;}
        public Id accountId{get;set;}
        public Project__c[] accountProjects{get;set;}
    }
}