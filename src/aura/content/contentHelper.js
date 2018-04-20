({
	setLike: function (cmp) {
		var id = cmp.get('v.id');
		var like = !cmp.get('v.liked');
		var action = cmp.get('c.setLikeField');
		action.setParams({
			'id': id,
			'likeTopic': like
		});
		action.setCallback(this, function (response) {
			var state = response.getState();
			if (state === 'SUCCESS') {
				//var result = response.getReturnValue();
				//console.log(result);
				//console.log('like3');
				//???????????
				//$A.get('e.force:refreshView').fire();
				//cmp.set('v.id', id);
				//TODO ПРИКРУТИТЬ ИВЕНТ С РЕГИСТРАЦИЕЙ И Т.Д. + ИЗМЕНИТЬ В ОБЪЕКТЕ ЛОКАЛЬНОМ.
				var showTopic = cmp.getEvent("showTopic");
				showTopic.setParams({ 
					'topicId': id,
					'like' : like
				 });
				showTopic.fire();
				//console.log('event fire like');


			} else {
				console.log("Error request. Response: " + state);
			}
		});
		$A.enqueueAction(action);
		//cmp.set('v.liked', like);
	}
})