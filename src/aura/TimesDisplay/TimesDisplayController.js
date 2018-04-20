({
	tabClicked : function(component, event, helper) {
		var tab = event.getSource().get('v.id');
		console.log(tab);
		
	},

	bookIt : function(component, event, helper) {
		alert('Booked! Time: ' + event.getSource().get("v.value") );
	}
})