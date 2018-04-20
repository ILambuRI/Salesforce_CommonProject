({
	doInit : function(component, event, helper) {

		var eventProjectId = event.getParam("projectId");
		var projectName = event.getParam("projectName");
		component.set('v.projectId', eventProjectId);
		component.set('v.projectName', projectName);

		var projectId = component.get('v.projectId');
		if (projectId == '') {
			console.log('From doInit - projectId = empty');
			return;
		}
		helper.getEmployees(component);
	},

	getFilteredData : function(component, event, helper) {
		var filterData = component.find('filterForm');		
		var filterValue = {
			name : '',
			department : '',
			level : ''
		};
		for (var i = 0; i < filterData.length; i++) {
			if (filterData[i].get('v.name') == 'inpName') {
				filterValue.name = filterData[i].get('v.value');
			} else if (filterData[i].get('v.name') == 'selDepat') {
				filterValue.department = filterData[i].get('v.value');
			} else if (filterData[i].get('v.name') == 'selLevel') {
				filterValue.level = filterData[i].get('v.value');
			}
		}
		helper.getEmployeesByFilter(component, filterValue);
	}, 

	test : function(component, event, helper) {
		console.log('Sort!');
		var wrappEmployee = component.get('v.wrappEmployee');
		var arr = [];
		for (var i = 0; i < wrappEmployee.length; i++) {

			var obj = {
				firstName : wrappEmployee[i].firstName
			};
				
			arr.push(obj);
		}
		// console.log(wrappEmployee);
		
		// function compare(a,b) {
		// 	// console.log(a.firstName);
			
		// 	if (a.freeHours < b.freeHours)
		// 	return -1;
		// 	if (a.freeHours > b.freeHours)
		// 	return 1;
		// 	return 0;
		// } 

		// wrappEmployee.sort(compare);
		arr.sort(function(a, b){
			// if(a.firstName < b.firstName){
			// 	console.log('<!');
			// 	return -1;
			// } else { 
			// 	console.log('>!');
			// 	return 1;
			// }
			var propA = new String(a.firstName);
			var propB = new String(b.firstName);
			// var propA = '' + a.firstName;
			// var propB = '' + b.firstName;

			return propA == propB ? 0 : +(propA > propB) || -1;
	  	});

		console.log(arr);
		component.set('v.wrappEmployee', arr);
		
		
	}

	// objs.sort(function(a, b){
	// 	return a.last_nom == b.last_nom ? 0 : +(a.last_nom > b.last_nom) || -1;
	//   });

	// function compare(a,b) {
	// 	if (a.last_nom < b.last_nom)
	// 	  return -1;
	// 	if (a.last_nom > b.last_nom)
	// 	  return 1;
	// 	return 0;
	//   }
	  
	//   objs.sort(compare);


})