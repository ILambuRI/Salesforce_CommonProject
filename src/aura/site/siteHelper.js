({
    getTopics : function(component) {
        var action = component.get("c.getTopics");
        action.setCallback(this, function(response){
            
            var state = response.getState();
            if (state === "SUCCESS") {
                var result = response.getReturnValue();
                component.set("v.topics", result);
                this.setMenu(component, result);
            } else {
                console.log("Error request. Response: " + state);
            }
        });
        $A.enqueueAction(action);
        
        this.checkBrowser(component);
        this.getDate(component);
    },
    
    setMenu : function(component, result) {
        var arrMenu = [];
        for(var i = 0; i < result.length; i++) {
            var menu = {
                'Name' : result[i].Name,
                'Id' : result[i].Id
            };
            arrMenu.push(menu);
        }
        component.set("v.menu", arrMenu);
    },
    
    showToast : function(type, title, msg) { 
        let toastEvent = $A.get("e.force:showToast"); 
        toastEvent.setParams({ 
            title : title, 
            message: msg, 
            /* https://webkul.com/blog/forceshowtoast-in-lightning/
             messageTemplate: '!!! Mode is sticky ,duration is 5sec and Message is overrriden because messageTemplateData is {0}{1}', 
             messageTemplateData: ['Salesforce', 
                              { url: 'http://www.webkul.com/', 
                              label: 'Click Here', }], 
                              */ 
            duration:'2000',
            //key: 'announcement',
            type: type, 
            mode: 'dismissible' }); 
        toastEvent.fire(); 
    },
    
    checkBrowser: function (cmp) {
        var device = $A.get("$Browser.formFactor");
        cmp.set('v.device', device);
    },

    getDate : function (cmp) {
        cmp.set('v.datetime', new Date());
    }


    /*
    refresh : function(component, event, helper) {
        var action = component.get('c.getTopics');
        action.setCallback(this,
                           function(response) {
                               var state = response.getState();
                               if (state === 'SUCCESS'){
                                   $A.get('e.force:refreshView').fire();
                                   console.log('true');
                               } else {
                                   //do something
                                   console.log('fffff');
                               }
                           }
                          );
        $A.enqueueAction(action);
        
    }*/
})