public with sharing class VforceAppController {
	
    public Boolean myRender {get; set;} {myRender = false;} 
    public Boolean createAccess {get; set;} { createAccess = false;} 
    public Boolean editAccess {get; set;} { editAccess = false;} 
    public Boolean deleteAccess {get; set;} { deleteAccess = false;} 
    public List<MyAccounts> myAccountsList {get; set;}
    public String accountId {get; set;}
    public String contactId {get; set;}
    public String inputName {get;set;}
    public String inputEmail {get;set;}
    @TestVisible private List<String> selectedContactDel = new List<String>(); 
    @TestVisible private String testProp;


    /**
    *Constructor
    */
    public VforceAppController(){
        //Check access to ojects Account and Contacts
        if (!(VforceAppCheckAccess.isAccessAccount() && VforceAppCheckAccess.isAccessContact())) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' You don\'t have permissions!'));
        } else {
            List<Account> accountsList = this.getAccountsContacts();
            //Check No Empty result SOQL!
            if (accountsList.isEmpty()) { 
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' No result! Error!'));
            } else {
                List<MyAccounts> myAccList = this.getMyAccounts(accountsList);
                this.myAccountsList = myAccList;
                //Check access to create Contact object
                if (VforceAppCheckAccess.isCreateContact()) {
                    this.createAccess = true;
                }
                //Check access to update Contact object
                if (VforceAppCheckAccess.isEditContact()) {
                    this.editAccess = true;
                }
                //Check access to delete Contact object
                if (VforceAppCheckAccess.isDelContact()) {
                    this.deleteAccess = true;
                }
            }
        }
    }


    @TestVisible
    private List<Account> getAccountsContacts() {
		List<Account> result = new List<Account>();
        try{
            result = Database.query(
                'SELECT Id, Name, ' +
                '(SELECT Id, Name, Email FROM Contacts) ' +
                'FROM Account ' +
                'LIMIT 10'
            );
        } catch (QueryException e) {
            System.debug('QueryException caught: ' + e.getMessage());
        } catch(Exception e){
            System.debug('Exception caught: ' + e.getMessage());
        }
		return result;
	}

    @TestVisible
    public List<MyAccounts> getMyAccounts(List<Account> accountsList) {
        List<MyAccounts> myAccList = new List<MyAccounts>();
        
        for (Account acc : accountsList) {
            MyAccounts myAcc = new MyAccounts();
            myAcc.id = acc.Id;
            myAcc.name = acc.Name;
            myAcc.contacts = new List<MyContacts>();

            for (Contact con : acc.Contacts) {
                MyContacts myCon = new MyContacts();
                myCon.id = con.Id;
                myCon.name = con.Name;
                myCon.email = con.Email;
                myAcc.contacts.add(myCon);
            }
            myAccList.add(myAcc);
        }

        return myAccList;
    }

    public void renderPopUp() {
        this.myRender = !this.myRender;
    } 

    public void cancel(){
        this.accountId = '';
        this.contactId = '';
        this.inputName = '';
        this.inputEmail = '';
        this.selectedContactDel.clear();
        this.renderPopUp();
    }


    public void saveContact() {
        if (this.inputName == '' || this.inputName == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' Fill out the form fields'));
            if(Test.isRunningTest()){
                this.testProp = 'filld empty';
            }
        }
        else if (this.inputEmail == '' || this.inputEmail == null) {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' Fill out the form fields'));
            if(Test.isRunningTest()){
                this.testProp = 'filld empty';
            }
        } else {
            try {
                if (this.contactId != '' && this.contactId != null) {
                    Contact contact = new Contact(
                        Id = contactId,
                        LastName = this.inputName, 
                        Email = this.inputEmail
                    );
                    upsert contact;
                    this.contactId='';

                } else {
                    Contact contact = new Contact(
                        LastName = this.inputName, 
                        Email = this.inputEmail, 
                        AccountId = this.accountId);
                    insert contact;
                    this.accountId='';
                }
                this.inputName='';
                this.inputEmail='';
                List<Account> accountsList = this.getAccountsContacts();
                List<MyAccounts> myAccList = this.getMyAccounts(accountsList);
                this.myAccountsList = myAccList;
                this.renderPopUp();
            } catch (DmlException e) {
                System.debug('An unexpected error has occurred: ' + e.getMessage());
            }
        }
    }

    public void editContact() {
        this.selectedContactDel.clear();
        if (!myAccountsList.isEmpty()){
            for ( MyAccounts myAcc : myAccountsList ) {
                for ( MyContacts myCon : myAcc.contacts) {
                    if (myCon.id == this.contactId) {
                        this.inputName = myCon.name;
                        this.inputEmail = myCon.email;
                        break;
                    }
                }
            }
            this.renderPopUp();
        } else {
            ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' Error Something went wrong!'));
            System.debug('Fatal error - empty data');
            if(Test.isRunningTest()){
                this.testProp = 'Error empty data';
            }
        }
    }

    public void addToDelete() {
        String id = ApexPages.currentPage().getParameters().get('SelectedToDelete');
        
        if (this.selectedContactDel.size() > 0 && this.selectedContactDel.contains(id)) {
            for (Integer i = 0; i < this.selectedContactDel.size(); i++) {
                
                if (this.selectedContactDel[i] == id) {
                    this.selectedContactDel.remove(i);
                }
            }
        } else {
            this.selectedContactDel.add(id);
        }
    }

    public void deleteContacts() {
        try {

            if (this.selectedContactDel.isEmpty()) {
                ApexPages.addMessage(new ApexPages.Message(ApexPages.Severity.FATAL, ' Select Checkbox!'));
            } else {
                List<Contact> contacts = new List<Contact>();
                for (String id : this.selectedContactDel) {
                    contacts.add(new Contact(Id = id));
                }
                delete contacts;
                this.deleteMyContacts(this.selectedContactDel);
                this.selectedContactDel.clear();
            }
        } catch (DMLException e) {
            System.debug('DMLException caught: ' + e.getMessage());
        } catch(Exception e){
            System.debug('Exception caught: ' + e.getMessage());
        }

    }

    private void deleteMyContacts(List<String> ids) {
        if (!this.myAccountsList.isEmpty()) {
            for (MyAccounts myA : this.myAccountsList) {
                for (Integer k=0; k < myA.contacts.size(); k++) {
                    for (Integer i =0; i < ids.size(); i++) {
                        if (myA.contacts[k].id == ids[i]) {
                            myA.contacts.remove(k);
                        }
                    }
                }
            }
        } else {
            System.debug('Error empty data');
        }
    }

    public class MyAccounts {

        public String id {get; set;}
        public String name {get;set;}
        public List<MyContacts> contacts { get; set; }
    }

    public class MyContacts {

        public String id { get; set; }
        public String name { get; set; }
        public String email { get; set; }
        public Boolean selected { get; set; } { selected = false; }
    }

}