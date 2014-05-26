

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

Parse.Cloud.beforeSave("Reference", function(request, response) {
	if (request.object.get("from") == null) {
		response.error("from is required");
	}
	else if (request.object.get("to") == null) {
		response.error("to is missing");
	}
	else if (request.object.get("text") == null) {
		response.error("text is missing");
	}
	else if (request.object.get("type") == null) {
		response.error("type is missing");
	}
	else {
		response.success();
	}
});

Parse.Cloud.define("UnreadCommentCount", function(request, response) {
	/*var userQuery = new Parse.Query("User");
	
	userQuery.get(request.params.id, {
		success: function(user) {
			var unreadCommentQuery = new Parse.Query("Comment");
			unreadCommentQuery.notEqualTo("read", true);
			unreadCommentQuery.equalTo("to", user);
			
			unreadCommentQuery.count({
			  success: function(number) {
			    response.success({ unreadComments : number });
			  },
			  error: function(error) {
			    console.error(error);
	 			response.error("Failed to read comment count");
			  }
			});
		},
		error : function(error) {
			console.error(error);
 			response.error("Failed to read comment count");
		}
	});*/
	
	var unreadCommentQuery = new Parse.Query("Comment");
	unreadCommentQuery.notEqualTo("read", true);
	unreadCommentQuery.equalTo("to", Parse.User.current());
	
	unreadCommentQuery.count({
	  success: function(number) {
	    response.success({ unreadCommentCount : number });
	  },
	  error: function(error) {
	    console.error(error);
		response.error("Failed to read comment count");
	  }
	});
});

Parse.Cloud.define("ReferenceCount", function(request, response) {
	var userQuery = new Parse.Query("User");
	
	userQuery.get(request.params.id, {
	  success: function(user) {
	    var query = new Parse.Query("Reference");
		query.equalTo("to", user);
		
		query.find({
			success: function(results) {
	      		var negativeCount = 0;
				var positiveCount = 0;

	      		for (var i=0 ; i<results.length ; i++) {
	        		if (results[i].get("type") == "positive") {
						positiveCount++;
					}
					else if (results[i].get("type") == "negative")  {
						negativeCount++;
					}
	      		}

	      		response.success({
					positive : positiveCount,
					negative : negativeCount
				});
	    	},
	    	error: function(object, error) {
				console.error(error);
	 			response.error("Failed to read references");
	    	}
	  	});
	  },
	  error: function(object, error) {
		console.error(error);
	    response.error("Failed to read references");
	  }
	});
});
