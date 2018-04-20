public with sharing class DaysPartController {

	@AuraEnabled
	public static Map<String, Map<Integer, List<String>>> getDaysPart(){
		
		Map<String, Map<Integer, List<String>>> daysPart = 
			DaysPartController.getTimeCellsBySeparator(Days_part__c.getAll());

		return daysPart;
	}

	private static Map<String, Map<Integer, List<String>>> getTimeCellsBySeparator(Map<String, Days_part__c> daysPart) {

		Map<String, Map<Integer, List<String>>> partAndTime = new Map<String, Map<Integer, List<String>>>();

		for (String name : daysPart.keySet()) {
			
			Integer startPoint = Integer.valueOf(daysPart.get(name).Start__c); 
			Integer endPoint = Integer.valueOf(daysPart.get(name).End__c);
			Integer separation = Integer.valueOf(daysPart.get(name).Separation__c);

			Map<Integer, List<String>> hoursAndMinutes = new Map<Integer, List<String>>();
			for (Integer i = startPoint; i < endPoint; i++){
				List<string> minutes = new List<String>{'00'};
				Integer count = separation;
				while(count < 60) {
					minutes.add(String.valueOf(count));
					count +=separation;
				}
				hoursAndMinutes.put(i, minutes);
			}
			partAndTime.put(name, hoursAndMinutes);
		}
		
		return partAndTime;
	}
}