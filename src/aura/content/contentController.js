({
	goToRecord : function(component, event, helper) {
		var sObjectEvent = $A.get('e.force:navigateToSObject');
		sObjectEvent.setParams({
			'recordId' : component.get('v.id')
		});
		sObjectEvent.fire();
	},

	like : function (cmp, event, helper) {
		helper.setLike(cmp);
	}
})