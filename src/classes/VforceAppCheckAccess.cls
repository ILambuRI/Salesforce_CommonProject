public with sharing class VforceAppCheckAccess {
	
	
	public static Boolean isAccessAccount() {
		return Schema.SObjectType.Account.isAccessible();
	}

	public static Boolean isAccessContact() {
		return Schema.SObjectType.Contact.isAccessible();
	}

	public static Boolean isCreateContact() {
		return Schema.SObjectType.Contact.isCreateable();
	}

	public static Boolean isEditContact() {
		return Schema.SObjectType.Contact.isUpdateable();
	}

	public static Boolean isDelContact() {
		return Schema.SObjectType.Contact.isDeletable();
	}

}