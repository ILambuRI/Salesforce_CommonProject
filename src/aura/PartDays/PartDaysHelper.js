({
	getPartDays: function(component) {
		component.set("v.date", new Date());
		var action = component.get("c.getDaysPart");
		action.setCallback(this, function(response) {
		var state = response.getState();
		if (state === "SUCCESS") {
			var result = response.getReturnValue();

			result = this.convertToArray(result);
			component.set("v.pDays", result);
			console.log(result);
		} else {
			console.log("Error request. Response: " + state);
		}
		});
		$A.enqueueAction(action);
	},

	convertToArray: function(mapObjs) {
		var arr = [];
		for (var key in mapObjs) {
		var times = [];
		for (var keyTime in mapObjs[key]) {
			times.push({
			hour: keyTime,
			minutes: mapObjs[key][keyTime]
			});
		}
		arr.push({
			name: key,
			times: times
		});
		}
		return arr;
	}
});