/**
 * Created by akolotii on 19.04.2018.
 */
@isTest
public with sharing class L_AccountProjectControllerTest {
    @testSetup static void setup() {

        Account[] testAccountList = new List<Account>();
        Project__c[] testProjectList = new List<Project__c>();

        for (Integer i = 0; i < 200; i++) {
            Account testAccount = new Account(Name = 'testAccount');
            testAccountList.add(testAccount);
        }

        insert testAccountList;

        for (Account acc : testAccountList) {
            Project__c testProject = new Project__c(Name = 'testProject', Start_Date__c = Date.newInstance(1900, 2, 5),
                    Account__c = acc.Id);
            testProjectList.add(testProject);
        }
        insert testProjectList;
    }

    @isTest static void TestGetAccountsWithProject() {
        Account[] accountWithProjectsList = [
                SELECT id,Name, (
                        SELECT id,Name
                        FROM Projects__r
                )
                FROM Account
                WHERE Id IN (SELECT Account__c FROM Project__c)
                ORDER BY Name
                LIMIT 20
        ];
        List<L_AccountProjectController.AccountWithProjectsWrapper> accountWithProjectsWrapperList =
                new List<L_AccountProjectController.AccountWithProjectsWrapper>();
        for (Account accountWithProjects : accountWithProjectsList) {
            L_AccountProjectController.AccountWithProjectsWrapper accountProject =
                    new L_AccountProjectController.AccountWithProjectsWrapper();
            accountProject.accountId = accountWithProjects.Id;
            accountProject.accountName = accountWithProjects.Name;
            accountProject.accountProjects = (Project__c[]) accountWithProjects.Projects__r;
            accountWithProjectsWrapperList.add(accountProject);
        }
        String expectedResult = JSON.serialize(accountWithProjectsWrapperList);

        Test.startTest();
        String result = L_AccountProjectController.getAccountsWithProject();
        Test.stopTest();

        System.assertEquals(expectedResult, result);
    }
}