public with sharing class L_ProjectDetailsController {
    // @AuraEnabled
    // /* Return all objs 'Words__c' where Subject__c == subject */
    // public static List<EmployeeSkill__c> getEmployeeSkillsByProjectID(String ID) {
    //     EmployeeSkill__c[]  employeeSkillList = new EmployeeSkill__c[]{};
        
    //     try {
    //         for (EmployeeSkill__c[] employeeSkillListBatch : [
    //                 SELECT ID,
    //                     Employee__r.First_Name__c,
    //                     Employee__r.Last_Name__c,
    //                     Assigned_Time__c,
    //                     Position__c,
    //                     Project__c
    //                 FROM EmployeeSkill__c
    //                 WHERE Project__c = :ID
    //             ]) {

    //             employeeSkillList.addAll(employeeSkillListBatch);
    //         }
    //     }
    //     catch (QueryException e) {
    //         System.debug(e.getMessage());
    //         System.debug(e.getTypeName());
    //         System.debug(e.getLineNumber());
    //     }
    //     catch (Exception e) {
    //         System.debug(e.getMessage());
    //         System.debug(e.getTypeName());
    //         System.debug(e.getLineNumber());
    //     }

    //     return employeeSkillList;
    // }

    @AuraEnabled
    /* Return all objs 'Words__c' where Subject__c == subject */
    public static List<EmployeeSkill__c> getEmployeeSkillsByProjectID(String ID) {
        EmployeeSkill__c[]  employeeSkillList = new EmployeeSkill__c[]{};
        
        try {
            for (EmployeeSkill__c[] employeeSkillListBatch : [
                    SELECT ID,
                        Employee__r.First_Name__c,
                        Employee__r.Last_Name__c,
                        Employee__r.Availability__c,
                        Assigned_Time__c,
                        Position__c,
                        Project__c
                    FROM EmployeeSkill__c
                    WHERE Project__c = :ID
                ]) {

                employeeSkillList.addAll(employeeSkillListBatch);
            }
        }
        catch (QueryException e) {
            System.debug(e.getMessage());
            System.debug(e.getTypeName());
            System.debug(e.getLineNumber());
        }
        catch (Exception e) {
            System.debug(e.getMessage());
            System.debug(e.getTypeName());
            System.debug(e.getLineNumber());
        }

        // Map<ID, EmployeeSkill__c> employeeSkillMap = new Map<ID, EmployeeSkill__c>(employeeSkillList);
        ID[] employeeIDs = new ID[]{};

        for (EmployeeSkill__c employeeSkill : employeeSkillList) {
            employeeIDs.add(employeeSkill.Employee__c);
        }

        AggregateResult[] sumEmployeeAssignedTimeList = [
            SELECT Employee__r.ID, SUM(Assigned_Time__c) sum
            FROM EmployeeSkill__c
            WHERE Employee__c = :employeeIDs
            GROUP BY Employee__r.ID
        ];

        System.debug(sumEmployeeAssignedTimeList);

        Map<ID,Integer> employeeIDAndAvailabilityMap = new Map<ID,Integer>();

        for (AggregateResult result : sumEmployeeAssignedTimeList) {
            employeeIDAndAvailabilityMap.put((ID)result.get('Id'), Math.round((Decimal)result.get('sum')));
        }

        

        System.debug(employeeIDAndAvailabilityMap);

        return employeeSkillList;
    }

    @AuraEnabled
    /* Return all values from picklist */
    public static List<String> getPicklistValuesFromObject(String objectName, String fieldName) {
        return L_SchemaService.getPicklistValues(objectName, fieldName);
    }

    /* Return all values from picklist */
    private static List<String> getSSS(String objectName, String fieldName) {
        return L_SchemaService.getPicklistValues(objectName, fieldName);
    }

    // public class EmployeeSkillWrapper {
    //     public ID Id {get; set;}
    //     public ID Employee__c {get; set;}
    //     public ID Project__c {get; set;}
    //     public String Position__c {get; set;}
    //     public Integer Assigned_Time__c {get; set;}
    //     public Integer Employee_Availability {get; set;}
    //     public String Employee_FreeHours {get; set;}
    //     public String Employee_FirstName {get; set;}
    //     public String Employee_LastName {get; set;}
    // }
}