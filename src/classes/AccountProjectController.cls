public class AccountProjectController {

    @AuraEnabled 
    public static String getAccountsWithProject(){
        Account[] accountWithProjectsList = [SELECT Id,Name,(SELECT id,Name 
                                                            FROM Projects__r) 
                                            FROM Account
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
        Account[] accountWithProjectsList = [SELECT Id,Name,(SELECT id,Name 
                                                            FROM Projects__r) 
                                            FROM Account
                                            WHERE Id = :accountId];
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

    public class AccountWithProjectsWrapper{
        public String accountName {get;set;}
        public Id accountId{get;set;}
        public Project__c[] accountProjects{get;set;}
    }
}