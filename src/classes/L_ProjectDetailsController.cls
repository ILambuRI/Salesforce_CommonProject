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
    public static List<EmployeeSkillWrapper> getEmployeeSkillsByProjectID(String ID) {
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

        // System.debug(sumEmployeeAssignedTimeList);

        Map<ID,Integer> employeeIDAndSumAssignedTimeMap = new Map<ID,Integer>();

        for (AggregateResult result : sumEmployeeAssignedTimeList) {
            employeeIDAndSumAssignedTimeMap.put((ID)result.get('Id'), Math.round((Decimal)result.get('sum')));
        }

        EmployeeSkillWrapper[] employeeSkillWrapperList = new EmployeeSkillWrapper[]{};

        for (EmployeeSkill__c employeeSkill : employeeSkillList) {
            Integer employeeAvailability = Math.round((Decimal)employeeSkill.Employee__r.Availability__c);
            Integer employeeSumAssignedTime = employeeIDAndSumAssignedTimeMap.get(employeeSkill.Employee__c);

            Integer freeHours = employeeAvailability - employeeSumAssignedTime;

            EmployeeSkillWrapper employeeSkillWrapper = new EmployeeSkillWrapper();
            employeeSkillWrapper.ID = employeeSkill.ID;
            employeeSkillWrapper.employeeID = employeeSkill.Employee__c;
            employeeSkillWrapper.projectID = employeeSkill.Project__c;
            employeeSkillWrapper.position = employeeSkill.Position__c;
            employeeSkillWrapper.assignedTime = Math.round((Decimal)employeeSkill.Assigned_Time__c);
            employeeSkillWrapper.employeeAvailability = Math.round((Decimal)employeeSkill.Employee__r.Availability__c);
            employeeSkillWrapper.employeeFreeHours = freeHours;
            employeeSkillWrapper.employeeSumAssignedTime = employeeSumAssignedTime;
            employeeSkillWrapper.employeeFirstName = employeeSkill.Employee__r.First_Name__c;
            employeeSkillWrapper.employeeLastName = employeeSkill.Employee__r.Last_Name__c;

            employeeSkillWrapperList.add(employeeSkillWrapper);
        }

        System.debug(employeeSkillWrapperList);

        return employeeSkillWrapperList;
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

    public class EmployeeSkillWrapper {
        @AuraEnabled
        public ID ID {get; set;}
        @AuraEnabled
        public ID employeeID {get; set;}
        @AuraEnabled
        public ID projectID {get; set;}
        @AuraEnabled
        public String position {get; set;}
        @AuraEnabled
        public Integer assignedTime {get; set;}
        @AuraEnabled
        public Integer employeeAvailability {get; set;}
        @AuraEnabled
        public Integer employeeFreeHours {get; set;}
        @AuraEnabled
        public Integer employeeSumAssignedTime {get; set;}
        @AuraEnabled
        public String employeeFirstName {get; set;}
        @AuraEnabled
        public String employeeLastName {get; set;}
    }
}