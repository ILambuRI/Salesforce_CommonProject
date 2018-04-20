public with sharing class TestVisualController {
	
	private String sortOrder = 'LastName';

	public List<Contact> getContactss() {
		List<Contact> result = Database.query(
			'SELECT Id, FirstName, LastName, Title, Email ' +
			'FROM Contact ' +
			'ORDER BY ' + sortOrder + ' ASC ' +
			'LIMIT 10'
		);

		return result;
	} 

	public void sortByLastName() {
    	this.sortOrder = 'LastName';
	}
		
	public void sortByFirstName() {
		this.sortOrder = 'FirstName';
	}


}