public with sharing class EmployeeController {


	@AuraEnabled
	public static List<Employee__c> getEmployees() {
		return [SELECT Id, Name, First_Name__c, Last_Name__c, Level__c,
			IT_Department__c, isActive__c FROM Employee__c LIMIT 30];
	}

	@AuraEnabled
	public static List<String> getPicklistValues(String objName, String fieldName) {
		List<String> picklistValue= new List<String>();
		//Get Object
		Map<String, Schema.SObjectType> allObjects = Schema.getGlobalDescribe();
		try {
			if (!allObjects.containsKey(objName)) {
				System.debug('Error Object Name');
			} else { 
				Schema.DescribeSObjectResult objectDesc = allObjects.get(objName).getDescribe();
				//Get Fields
				Map<String, Schema.SObjectField> fieldsMap = objectDesc.fields.getMap();
				if (!fieldsMap.containsKey(fieldName)) {
					System.debug('Error Field Name in Object');
				} else {
					Schema.DescribeFieldResult fieldResult = fieldsMap.get(fieldName).getDescribe();
					List<Schema.PicklistEntry> picklistEntry = fieldResult.getPicklistValues();
					for (Schema.PicklistEntry pickEntry : picklistEntry) {
						picklistValue.add(pickEntry.getValue());
					}
				}
			}
			System.debug(picklistValue);
		} catch(NullPointerException e) {
			System.debug('NullPointerException caught: ' + e.getMessage());
			System.debug('NullPointerException caught: ' + e.getTypeName());
			System.debug('NullPointerException caught: ' + e.getLineNumber());
			System.debug('NullPointerException caught: ' + e.getCause());
		} catch(Exception e){
            System.debug('Exception caught: ' + e.getMessage());
        }
		return picklistValue;
	}



}