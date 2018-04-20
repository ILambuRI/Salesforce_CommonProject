public with sharing class LookupSObjectController 
{
    @AuraEnabled public List<Result> result{get;set;}

    @AuraEnabled
    public static Result[] lookup(String searchString, String sObjectAPIName)
    {
        
        System.debug(searchString);
        System.debug(sObjectAPIName);
        // Sanitze the input
        String sanitizedSearchString = String.escapeSingleQuotes(searchString);
        String sanitizedSObjectAPIName = String.escapeSingleQuotes(sObjectAPIName);

		List<Result> results = new List<Result>();

        // Build our SOSL query
        String searchQuery = 'FIND \'' + sanitizedSearchString + '*\' IN ALL FIELDS RETURNING ' + sanitizedSObjectAPIName + '(id,name) Limit 50'; 

        system.debug(searchQuery);
        // Execute the Query
        List<List<SObject>> searchList = search.query(searchQuery);
		system.debug(searchList);
        // Create a list of matches to return
		for (SObject so : searchList[0])
        {
            results.add(new Result((String)so.get('Name'), so.Id));
        }
        
        return results;
    }
    
    @AuraEnabled
    public static AccountWithContacts[] getAccountWithContacts(){
        Account[] accauntList= [SELECT id,Name,(SELECT id,Name 
                                    FROM Projects__r) 
                    FROM Account 
                    WHERE Id IN (SELECT Account__c FROM Project__c)];
        List<AccountWithContacts> accountWithContactsList= new List<AccountWithContacts>();
        for(Account account : accauntList){
            AccountWithContacts accountWithContacts = new AccountWithContacts();
            accountWithContacts.accountId = account.Id;
            accountWithContacts.accountName = account.Name;
            accountWithContacts.projectList = (Project__c[])account.Projects__r;

            accountWithContactsList.add(accountWithContacts);
        }
        System.debug(accountWithContactsList);
        return accountWithContactsList;
    }

    /**
     * Inner class to wrap up an SObject Label and its Id
     */
	public class Result
    {
        @AuraEnabled public String SObjectLabel {get; set;}
        @AuraEnabled public Id SObjectId {get; set;}
        
        public Result(String sObjectLabel, Id sObjectId)
        {
            this.SObjectLabel = sObjectLabel;
            this.SObjectId = sObjectId;
        }
    }

    public class AccountWithContacts{
        Id accountId;
        String accountName;
        List<project__c> projectList;
    }
}