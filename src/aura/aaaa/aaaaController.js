({
    /**
     * Handler for receiving the updateLookupIdEvent event
     */
    /* aeHandlerController.js */

    handleApplicationEvent : function(cmp, event) {
        var message = event.getParam("projectId");
	
    
    console.log(message);
    }

})