

Parse.Cloud.beforeSave("CarPoolOffer", function(request, response) {
	if (request.object.get("time") == null) {
		response.error("time is missing");
	} 
	else if (request.object.get("startLocation") == null) {
    	response.error("startLocation is missing");
  	} 
	else if (request.object.get("endLocation") == null) {
		response.error("endLocation is missing");
  	} 
	else if (request.object.get("from") == null) {
		response.error("from is missing");
  	} 
	else {
    	response.success();
  	}
});

Parse.Cloud.beforeSave("CarPoolRequest", function(request, response) {
	if (request.object.get("from") == null) {
		response.error("from is required");
	} 
	else if (request.object.get("to") == null) {
		response.error("to is missing");
	} 
	else if (request.object.get("time") == null) {
		response.error("time is missing");
	}
	else if (request.object.get("offer") == null) {
		response.error("offer is missing");
	}
	else if (request.object.get("startLocation") == null) {
    	response.error("startLocation is missing");
  	} 
	else if (request.object.get("endLocation") == null) {
		response.error("endLocation is missing");
  	} 
	else if (request.object.get("from") == null) {
		response.error("from is missing");
  	} 
	else {
		response.success();
  	}
});

Parse.Cloud.beforeSave("Comment", function(request, response) {
	if (request.object.get("from") == null) {
		response.error("from is required");
	} 
	else if (request.object.get("to") == null) {
		response.error("to is missing");
	}
	else if (request.object.get("message") == null) {
		response.error("message is missing");
	}
	else {
		if (request.object.isNew()) {
			var installationQuery = new Parse.Query("Installation");
		    installationQuery.equalTo("user", request.object.get("to"));

			request.object.get("to").fetch().then(function(user) {
				Parse.Push.send(
				{
					where : installationQuery,
					data : 
					{
						alert : "Message from " + user.name,
						data : {
							type : "comment",
							fromId : request.object.get("from").id,
							toId : request.object.get("to").id,
							requestId : (request.object.get("request") == null) ? null : request.object.get("request").id
						}
					}
				}, 
				{
					success : function(){
						response.success();
					},
					error : function(error) { 
						console.log(error); 
						response.error("Failed to send message to user");
					}
				});
			});
		}
		else {
			response.success();
		}
	}
});
