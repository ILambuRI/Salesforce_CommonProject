public with sharing class MyProjectController {

	@AuraEnabled
	public static List<Project__c> getProjectsAndSkills() {
		return [SELECT Id, Name, 
				(SELECT Name, Employee__c FROM EmployeeSkills__r) 
			FROM Project__c LIMIT 3];
	}

}