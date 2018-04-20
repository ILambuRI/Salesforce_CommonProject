({
	setNewProjects : function(component) {
		var selectedId = component.find('selectedAccount').get("v.value");
		var allProjects = component.get('v.allProjects');
		var projectForSelectedAccount =[];
		if(selectedId == "All"){
			component.set("v.projectsForSelectedAccount",allProjects);
		}else{
			projectForSelectedAccount = this.newProjects(allProjects,selectedId);
			component.set("v.projectsForSelectedAccount",projectForSelectedAccount);
		}
	},
	newProjects : function(allProjects, selectedId){
		var projectForSelectedAccount =[];
		for(var i in allProjects){
			if(allProjects[i].accountId == selectedId && allProjects[i].accountProjects.length >0){
				projectForSelectedAccount.push(allProjects[i]);
				break;
			}
		}
		return projectForSelectedAccount;
	},
	initComponent : function(component){
		var action = component.get('c.getAccountsWithProject');
		action.setStorable();
		action.setCallback(this,function(response){
			if (response.getState() === 'SUCCESS') {
				var retObj = JSON.parse(response.getReturnValue());
					component.set("v.options",retObj); 
					component.set("v.allProjects",retObj); 
					component.set("v.projectsForSelectedAccount",retObj); 
			}else if (response.getState() === 'ERROR'){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						alert(errors[0].message);
					}
				} 
			}
		});
		$A.enqueueAction(action); 
	},
	searchProjects : function(component,accountId){
		var action = component.get('c.getAccountProjects');
		action.setStorable();
		action.setParams({
			'accountId':accountId
		});
		action.setCallback(this,function(response){
			if (response.getState() === 'SUCCESS') {
				var retObj = JSON.parse(response.getReturnValue());
				console.log(retObj)
				if(retObj.length == 0){
				    var toastEvent = $A.get("e.force:showToast");
                        toastEvent.setParams({
                            "title": "Warning!",
                            "message": "Client doesn't have Projects",
                            "type": "Warning"
                        });
                        toastEvent.fire();
                }
                component.set("v.projectsForSelectedAccount",retObj);
			}else if (response.getState() === 'ERROR'){
				var errors = response.getError();
				if (errors) {
					if (errors[0] && errors[0].message) {
						alert(errors[0].message);
					}
				}
			}
		});
    	$A.enqueueAction(action); 
	},

	createDetailsWindow : function(component, event) {
		var projectId = event.getSource().get('v.value');
		$A.createComponent(
            "c:ModalWindow",
            {
                "title": "Project Details",
            },
            function(msgBox,status){                
                if (component.isValid()) {
                    var innerComponent = msgBox.find('innerComponent');
                    $A.createComponent(
                    "c:projectDetails",
                    {
						"projectId" : projectId
                    },function(projectDetailsComponent){ 
                    	var body = innerComponent.get("v.body");
                    	body.push(projectDetailsComponent);
                        innerComponent.set("v.body",body);
                    });
                    var targetCmp = component.find('ModalDialogPlaceholder');
                    var body = targetCmp.get("v.body");
                    body.push(msgBox);
                    targetCmp.set("v.body", body); 
                }
            }
        );
	},
	addNewEmployee : function(component, event) {
		var project = event.getSource().get('v.value');
		var cmpEvent = $A.get("e.c:AddNewEmployeeToProjectEvent");
		cmpEvent.setParams({'projectId':project.Id,
		'projectName':project.Name});
		cmpEvent.fire();
	},
	clearNewEmployee : function(component){
	    var cmpEvent = $A.get("e.c:AddNewEmployeeToProjectEvent");
        cmpEvent.setParams({'projectId':null});
        cmpEvent.fire();
    }
})