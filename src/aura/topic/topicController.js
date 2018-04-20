({
    clickTopic : function(component, event, helper){     
        var topicId = event.getSource().get("v.name");
        var showTopic = component.getEvent("showTopic");
       	showTopic.setParams({"topicId" : topicId});
        showTopic.fire();
    }

})