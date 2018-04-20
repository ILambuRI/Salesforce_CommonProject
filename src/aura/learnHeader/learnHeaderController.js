({
	changeLable : function(component, event, helper) {
		var lable = event.getSource().get('v.label');
		if (lable == 'test') {
			event.getSource().set('v.label', 'dddd');
			component.set('v.title', 'Title updated');
			return;
		} else {
			component.set('v.title', 'Title default');
			event.getSource().set('v.label', 'test');
			return;
		}
	},

	tabClicked : function (cmp, event, helper) {
		var tab = event.getSource().get('v.id');
		console.log(tab);
	},

	
})