

Parse.Cloud.beforeSave("CarPoolOffer", function(request, response) {
	if (request.object.get("time") == null) {
		response.error("time is required");
	} 
	else if (request.object.get("startLocation") == null) {
    	response.error("startLocation is required");
  	} 
	else if (request.object.get("endLocation") == null) {
		response.error("endLocation is required");
  	} 
	else if (request.object.get("from") == null) {
		response.error("from is required");
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
		response.error("to is to");
	} 
	else if (request.object.get("offer") == null) {
		response.error("offer is to");
	}
	else if (request.object.get("startLocation") == null) {
    	response.error("startLocation is required");
  	} 
	else if (request.object.get("endLocation") == null) {
		response.error("endLocation is required");
  	} 
	else if (request.object.get("from") == null) {
		response.error("from is required");
  	} 
	else {
    	response.success();
  	}
});

Parse.Cloud.afterSave("CarPoolRequest", function(request, response) {
	var installationQuery = new Parse.Query("Installation");
    installationQuery.equalTo("user", request.object.get("to"));

	request.object.get("to").fetch().then(function(user) {
		Parse.Push.send(
		{
			where : installationQuery,
			data : 
			{
				alert : "Message from " + user.name
			}
		}, 
		{
			success : function(){},
			error : function(error) { console.log(error); }
		});
	});
});
