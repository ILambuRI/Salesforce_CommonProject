({
    /**
     * Search an SObject for a match
     */
    search : function(cmp, event, helper) {
        helper.doSearch(cmp);        
    },

    /**
     * Select an SObject from a list
     */
    doInit: function(component, event, helper) {
        var action = cmp.get('c.lookup');

        // Mark the action as abortable, this is to prevent multiple events from the keyup executing
        action.setAbortable();

        // Set the parameters
        action.setParams({ "searchString" : searchString, "sObjectAPIName" : "Project__c"});
                          
        // Define the callback
        action.setCallback(this, function(response) {
            var state = response.getState();
	console.log(state);
            // Callback succeeded
            if (cmp.isValid() && state === "SUCCESS")
            {
                // Get the search matches
                var matches = response.getReturnValue();
console.log(matches);
                // If we have no matches, return nothing
                if (matches.length == 0)
                {
                    cmp.set('v.matches', null);
                    return;
                }
                cmp.set('v.matches', matches);
            }
            // else if (state === "ERROR") // Handle any error by reporting it
            // {
            //     var errors = response.getError();
                
            //     if (errors) 
            //     {
            //         if (errors[0] && errors[0].message) 
            //         {
            //             this.displayToast('Error', errors[0].message);
            //         }
            //     }
            //     else
            //     {
            //         this.displayToast('Error', 'Unknown error.');
            //     }
            // }
        });
               
        $A.enqueueAction(action);     
    },
    
    /**
     * Clear the currently selected SObject
     */
    // clear: function(cmp, event, helper) {
    //     helper.clearSelection(cmp);    
    // }
})