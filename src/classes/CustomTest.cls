public with sharing class CustomTest {
	
	public static void getCustData(){
		List<test2__c> t = test2__c.getall().values();
        System.debug('fffff');
        System.debug(t);
        
        Map<String, test2__c> t2 = test2__c.getAll();
        System.debug('gggg');
        System.debug(t2);
        test2__c obj = test2__c.getValues('Dima');
        System.debug(obj);
        System.debug(obj.name);
        System.debug(obj.one2__c);
        System.debug(t2.get('Dima'));
	}
}