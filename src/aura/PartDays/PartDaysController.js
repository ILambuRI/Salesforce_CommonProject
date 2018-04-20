({
  doInit: function(component, event, helper) {
    helper.getPartDays(component);
  },

  handleSelect: function(component, event, helper) {
    var selected = event.getSource().get("v.value");
    if (selected == "none") {
      component.set("v.partSelect", "");
      return;
    }

    component.set("v.partSelect", "");
    component.set("v.times", []);

    var pDays = component.get("v.pDays");
    for (var key in pDays) {
      if (pDays[key].name == selected) {
        component.set("v.partSelect", selected);
        component.set("v.times", pDays[key].times);
        break;
      }
    }
  }
});