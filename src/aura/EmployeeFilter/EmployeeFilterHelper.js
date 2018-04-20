({
	getEmployees : function(component) {
		var action = component.get('c.getFilteredEmployees');
		action.setParams({
			"name" : '',
			"department" : '',
			"level" : ''
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.wrappEmployee', result);

				this.getPicklistValue(component, 'Employee__c', 'IT_Department__c', 'v.depatmentPick');
				this.getPicklistValue(component, 'Employee__c', 'Level__c', 'v.levelPick');
				this.getPicklistValue(component, 'EmployeeSkill__c', 'Position__c', 'v.positionPick');

			} else {
				console.log("Error request. Response: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	getEmployeesByFilter : function(component, params) {
		var action = component.get('c.getFilteredEmployees');
		action.setParams({
			"name" : params.name,
			"department" : params.department,
			"level" : params.level
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set('v.wrappEmployee', result);
			} else {
				console.log("Error request. Response: " + state);
			}
		});
		$A.enqueueAction(action);
	},

	getPicklistValue : function(component, obj, field, compName) {
		var action = component.get('c.getPicklistValues');
		action.setParams({
			"objName" : obj,
			"fieldName" : field
		});
		action.setCallback(this, function(response){
			var state = response.getState();
			if (state === 'SUCCESS') {
				var result = response.getReturnValue();
				component.set(compName, result);
			} else {
				console.log("Error request. Response: " + state);
			}
		});
		$A.enqueueAction(action);
	}


})