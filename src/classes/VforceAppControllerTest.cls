@isTest
private class VforceAppControllerTest {
	
	@isTest static void testRenderPopUp() {
		VforceAppController vForce = new VforceAppController();
		vForce.renderPopUp();
		System.assertEquals(true, vForce.myRender);
	}
	
	@isTest static void testGetAccountsContacts() {
		Account acc = new Account(Name='TestUnit');
		insert acc;
		Contact con = new Contact(LastName='TestContact', AccountId= acc.Id);
		insert con;
		VforceAppController vForce = new VforceAppController();
		
		Test.startTest();
		List<Account> listAcc = vForce.getAccountsContacts();
		Integer myAccSize =  vForce.getMyAccounts(listAcc).size();
		Test.stopTest();
		System.debug(vForce.myAccountsList);

		System.assertEquals(1, listAcc.size());
		System.assertEquals(1, myAccSize);
		System.assertEquals(1, vForce.myAccountsList.size());
	}

	@isTest static void testSaveContact(){
		Account acc = new Account(Name='TestUnit');
		insert acc;
		VforceAppController vForce = new VforceAppController();
		vForce.inputName = 'TestName';
		vForce.inputEmail = 'test@test.com';
		vForce.accountId = acc.Id;
		Test.startTest();
		vForce.saveContact();
		Test.stopTest();
		System.assertEquals(1, vForce.myAccountsList[0].contacts.size());
	}

	@isTest static void testSaveContactErrorMsg() {
		VforceAppController vForce = new VforceAppController();
		Test.startTest();
		vForce.saveContact();
		Test.stopTest();
		System.assertEquals('filld empty', vForce.testProp);
	}

	@isTest static void testSaveContactErrorMsg2() {
		VforceAppController vForce = new VforceAppController();
		vForce.inputName = 'TestName';
		Test.startTest();
		vForce.saveContact();
		Test.stopTest();
		System.assertEquals('filld empty', vForce.testProp);
	}

	@isTest static void testSaveEditContact() {
		Account acc = new Account(Name='TestUnit');
		insert acc;
		Contact con = new Contact(LastName='TestContact', Email='test@test.com', AccountId= acc.Id);
		insert con;
		VforceAppController vForce = new VforceAppController();
		vForce.contactId = con.Id;
		vForce.inputName = 'TestName';
		vForce.inputEmail = 'test@test.com';
		vForce.accountId = acc.Id;
		Test.startTest();
		vForce.saveContact();
		Test.stopTest();
		System.assertEquals(1, vForce.myAccountsList.size());

	}

	@isTest static void testEditContact() {
		Account acc = new Account(Name='TestUnit');
		insert acc;
		Contact con = new Contact(LastName='TestContact', Email='test@test.com', AccountId= acc.Id);
		insert con;
		VforceAppController vForce = new VforceAppController();
		vForce.contactId = con.Id;
		Test.startTest();
		vForce.editContact();
		Test.stopTest();
		System.assertEquals('TestContact', vForce.inputName);
		System.assertEquals('test@test.com', vForce.inputEmail);
	}

	@isTest static void testEditContactErrMsg() {
		Account acc = new Account(Name='TestUnit');
		insert acc;
		Contact con = new Contact(LastName='TestContact', Email='test@test.com', AccountId= acc.Id);
		insert con;
		VforceAppController vForce = new VforceAppController();
		vForce.contactId = con.Id;
		vForce.myAccountsList.clear();
		Test.startTest();
		vForce.editContact();
		Test.stopTest();
		System.assertEquals('Error empty data', vForce.testProp);
	}


	@isTest static void testCancel() {
		Account acc = new Account(Name='TestUnit');
		insert acc;
		Contact con = new Contact(LastName='TestContact', Email='test@test.com', AccountId= acc.Id);
		insert con;
		VforceAppController vForce = new VforceAppController();
		vForce.contactId = con.Id;
		vForce.inputName = 'TestName';
		vForce.inputEmail = 'test@test.com';
		vForce.accountId = acc.Id;
		vForce.selectedContactDel = new List<String>{'test', 'test2', 'test3'};
		Test.startTest();
		vForce.cancel();
		Test.stopTest();
		System.assertEquals('', vForce.accountId);
		System.assertEquals('', vForce.contactId);
		System.assertEquals('', vForce.inputName);
		System.assertEquals('', vForce.inputEmail);
		System.assertEquals(new List<String>(), vForce.selectedContactDel);
		
	}
	
}