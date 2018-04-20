({
	itemSelected : function(component, event, helper) {
		helper.itemSelected(component, event, helper);
	}, 
    serverCall :  function(component, event, helper) {
		helper.serverCall(component, event, helper);
	},
    clearSelection : function(component, event, helper){
        helper.clearSelection(component, event, helper);
    },
    clearAutocomplete : function(component, event, helper){
        if(event.target.getAttribute("autocomplete") !== "off"){
                    event.target.setAttribute("autocomplete","off");
        }
    }
})