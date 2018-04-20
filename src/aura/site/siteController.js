({
    doInit: function (component, event, helper) {
        helper.getTopics(component);
    },

    showTopicDesc: function (component, event, helper) {
        var id = event.getParam("topicId");
        var like = event.getParam('like');
        var topics = component.get("v.topics");
        for (var i = 0; i < topics.length; i++) {
            if (topics[i].Id == id) {
                component.set("v.topicContent", topics[i].Content__c);
                component.set("v.date", topics[i].Date__c);
                component.set("v.topicId", id);
                if (like != undefined) {
                    component.set('v.liked', like);
                    topics[i].like__c = like;
                    component.set('v.topics', topics);
                } else {
                    component.set('v.liked', topics[i].like__c);
                }
            }
        }
    },

    newTopic: function (component, event, helper) {
        var dateTime = new Date();
        //console.log(dateTime);
        var createRecordEvent = $A.get("e.force:createRecord");
        createRecordEvent.setParams({
            "entityApiName": "Topic__c",
            "defaultFieldValues": {
                "Date__c": dateTime,
            }
        });
        createRecordEvent.fire();
    },
    
    editRecord: function (component, event, helper) {
        var id = component.get("v.topicId");
        if (!id) {
            helper.showToast('warning', 'Choice Topic', 'Select the topic you want to change!');
            return;
        }
        var editRecordEvent = $A.get("e.force:editRecord");
        editRecordEvent.setParams({
            "recordId": id
        });
        editRecordEvent.fire();
        //console.log('gggg');
        component.set('v.test', true);
    },

    deleteRecord: function (component, event, helper) {
        var id = component.get("v.topicId");
        if (!id) {
            helper.showToast('error', 'Choice Topic', 'Select the topic you want to delete!');
            return;
        }
        var action = component.get("c.deleteTopic");
        action.setParams({
            "id": id
        });
        action.setCallback(this, function (response) {
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                helper.showToast('success', 'Record deleted', 'You delete the record \"' + result + '\"');
                $A.get('e.force:refreshView').fire();
            } else {
                console.log("Error request. Response: " + state);
            }
        });
        $A.enqueueAction(action);

    },

    test: function (component, event, helper) {
        
        console.log('test say');
        console.log('old value = '+ event.getParam('oldValue'));
        console.log('current value = '+ event.getParam('value'));
    }


})