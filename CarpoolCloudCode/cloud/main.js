var PushNotificationTypeComment = "comment";
var PushNotificationTypeReference = "reference";
var ReferenceTypePositive = "positive";
var ReferenceTypeNegative = "negative";
var CarPoolRequestStatusAccepted = "accepted";
var CarPoolRequestStatusRejected = "rejected";
var CarPoolRequestStatusCanceled = "canceled";

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
	else if (request.object.get("to").id == request.object.get("from").id) {
		response.error("Can't send a request to yourself");
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

Parse.Cloud.afterSave("CarPoolRequest", function(request) {
	if  (!request.object.existed()) {
		var Comment = Parse.Object.extend("Comment");
		var comment = new Comment();
		comment.set("from", request.object.get("from"));
		comment.set("to", request.object.get("to"));
		comment.set("request", request.object);
		comment.set("action", "message"); /*  Don't hardcode message*/
		comment.set("message", request.object.get("message"));
		comment.save(null, {
			success : function(comment) {
				response.success(comment);
			},
			error :function(object, error) {
				console.error(error);
				response.error("There was a problem updating request status");
			}
		});
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
		response.success();
	}
});

Parse.Cloud.afterSave("Comment", function(request){
	Parse.Cloud.useMasterKey();
	
	if  (!request.object.existed()) {
		request.object.get("from").fetch().then(function(user) {
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
							type : PushNotificationTypeComment,
							commentId : request.object.id,
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
		});
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
	else if (request.object.get("from").id == request.object.get("to").id) {
		response.error("you can't leave yourself a reference");
	}
	else {
		response.success();
	}
});

Parse.Cloud.afterSave("Reference", function(request) {
	Parse.Cloud.useMasterKey();
	
	request.object.get("from").fetch().then(function(user) {
		var installationQuery = new Parse.Query("Installation");
	    installationQuery.equalTo("user", request.object.get("to"));

		var message;
		if  (request.object.existed()) {
			message = user.name + " uptaded the reference he left you";
		}
		else {
			message = user.name + " left you a reference";
		}

		Parse.Push.send({
			where : installationQuery,
			data : 
			{
				alert : message,
				data : {
					type : PushNotificationTypeReference,
					fromId : request.object.get("from").id,
					toId : request.object.get("to").id
				}
			}
		}, 
		{
			success : function(){
			},
			error : function(error) { 
				console.error(error); 
			}
		});
	});
});

Parse.Cloud.define("UnreadCommentCount", function(request, response) {
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
	
	userQuery.get(request.params.userId, {
	  success: function(user) {
	    var query = new Parse.Query("Reference");
		query.equalTo("to", user);
		
		query.find({
			success: function(results) {
	      		var negativeCount = 0;
				var positiveCount = 0;

	      		for (var i=0 ; i<results.length ; i++) {
	        		if (results[i].get("type") == ReferenceTypePositive) {
						positiveCount++;
					}
					else if (results[i].get("type") == ReferenceTypeNegative)  {
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

Parse.Cloud.define("InboxComments", function(request, response) {
	var commentsToMeQuery = new Parse.Query("Comment");
	commentsToMeQuery.equalTo("to", Parse.User.current());
	
	var commentsFromMeQuery = new Parse.Query("Comment");
	commentsFromMeQuery.equalTo("from", Parse.User.current());
	
	var mainQuery = Parse.Query.or(commentsToMeQuery, commentsFromMeQuery);
	mainQuery.include("from");
	mainQuery.include("to");
	mainQuery.addDescending("createdAt");
	
	mainQuery.find({
		success: function(results) {
			var currentUserId = Parse.User.current().id;
			var groupedComments = [];
			var groupedCommentKeys = [];
			
			// Loop through all comments, and then group them by either request or from, depending on wheter request field exists or not
	    	for (var i=0 ; i<results.length ; i++) {
				var comment = results[i];
				
				// Group by request
				if (comment.get("request") != null) {
					var requestId = comment.get("request").id;
					var existingComment = comment[requestId];
					
					if (groupedCommentKeys.indexOf(requestId) == -1) {
						groupedComments.push(comment);
						groupedCommentKeys.push(requestId);
					}
				}
				// Group by user
				else {
					// comment could
					var otherUserId = (comment.get("from").id == currentUserId) 
						? comment.get("to").id 
						: comment.get("from").id;
						
					var existingComment = comment[otherUserId];
					
					if (groupedCommentKeys.indexOf(otherUserId) == -1) {
						groupedComments.push(comment);
						groupedCommentKeys.push(otherUserId);
					}
				}
			}
			
			response.success(groupedComments);
	  	},
	  	error: function(error) {
			console.error(error);
	    	response.error("Failed to read references");
	  	}
	});
});

Parse.Cloud.define("UserNotificationSetting", function(request, response) {
	Parse.Cloud.useMasterKey();
	var notificationSettingsQuery = new Parse.Query("NotificationSetting");
	
	notificationSettingsQuery.find({
		success: function(notificationSettings) {
			var userNotificationSettingsQuery = new Parse.Query("UserNotificationSetting");
			userNotificationSettingsQuery.equalTo("user", Parse.User.current());
			userNotificationSettingsQuery.include("notificationSetting");
			
			userNotificationSettingsQuery.find({
				success: function(userSettings) {

					var newUserSettings = [];
					
					for (var i=0 ; i<notificationSettings.length ; i++) {
						var notificationSetting = notificationSettings[i];
						var userSettingExists = false;
						
						for (var j=0 ; j<userSettings.length ; j++) {
							var userSetting = userSettings[j];
							if (userSetting.get("notificationSetting").id == notificationSetting.id) {
								newUserSettings.push(userSetting);
								userSettingExists = true;
								break;
							}
						}
						
						if (userSettingExists == false) {
							var UserNotificationSetting = Parse.Object.extend("UserNotificationSetting");
							var userSetting = new UserNotificationSetting();
							userSetting.set("user", Parse.User.current());
							userSetting.set("notificationSetting", notificationSetting);
							userSetting.set("enabled", notificationSetting.get("defaultValue"));
							newUserSettings.push(userSetting);
						}
					}
					
					Parse.Object.saveAll(newUserSettings, {
				    	success: function(list) {
				      		response.success(newUserSettings);
				    	},
				    	error: function(error) {
				      		console.error(error);
					    	response.error("Failed to read notification settings");
				    	}
					});
				},
				error: function(object, error) {
					console.error(error);
			    	response.error("Failed to read notification settings");
				}
			});
		},
		error: function(object, error) {
			console.error(error);
	    	response.error("Failed to read notification settings");
		}
	});
});


Parse.Cloud.define("UpdateRequestStatus", function(request, response) {
	Parse.Cloud.useMasterKey();
	
	var currentUserId = Parse.User.current().id;
	var requestId = request.params.requestId;
	var status = request.params.status;
	var commentMessage;
	
	if (status != CarPoolRequestStatusAccepted &&
		status != CarPoolRequestStatusRejected && 
		status != CarPoolRequestStatusCanceled) {
			console.error("invalid status was recieved : " + status);
			response.error("invalid status");
	}
		
	if (status == CarPoolRequestStatusCanceled) {
		commentMessage = "Request canceled";
	} else if (status == CarPoolRequestStatusAccepted) {
		commentMessage = "Request accepted";
	} else if (status == CarPoolRequestStatusRejected) {
		commentMessage = "Request rejected";
	}
		
	var requestQuery = new Parse.Query("CarPoolRequest");
	requestQuery.equalTo("objectId", requestId);
	requestQuery.include("from");
	requestQuery.include("to");
	requestQuery.include("offer");
	
	requestQuery.find({
		success : function(requests) {			
			var carpoolRequest = requests[0];
			console.log("size: " + requests.length);
			
			if (carpoolRequest.get("status") == status) {
				console.error("New status values is the same as existing value");
		    	response.error("New status values is the same as existing value");
			}
			
			if (carpoolRequest.get("status") == CarPoolRequestStatusCanceled) {
				console.error("Request has been canceled, no changes can be made");
				response.error("Request has been canceled, no changes can be made");
			}
			
			if (new Date(carpoolRequest.get("time")) < new Date()){
				console.error("Request has been expired");
		    	response.error("Request has been expired");
			}
			
			if ((status == CarPoolRequestStatusAccepted || status == CarPoolRequestStatusRejected) && currentUserId != carpoolRequest.get("to").id) {
				console.error("This request can only be rejected and accepted by whome the request was sent to");
		    	response.error("This request can only be rejected and accepted by whome the request was sent to");
			}
			
			if (status == CarPoolRequestStatusCanceled && currentUserId != carpoolRequest.get("from").id) {
				console.error("This request can only be canceled by whome the request was created by");
		    	response.error("This request can only be canceled by whome the request was created by");
			}
			
			carpoolRequest.set("status", status);
			
			carpoolRequest.save(null, {
				success : function(carpoolRequest) {
					var otherUserToSendMessageTo = (Parse.User.current().id == carpoolRequest.get("from").id)
						? carpoolRequest.get("to")
						: carpoolRequest.get("from");
					
					var Comment = Parse.Object.extend("Comment");
					var comment = new Comment();
					comment.set("from", Parse.User.current());
					comment.set("to", otherUserToSendMessageTo);
					comment.set("request", carpoolRequest);
					comment.set("action", status);
					comment.set("message", commentMessage);
					comment.save(null, {
						success : function(comment) {
							response.success(comment);
						},
						error :function(object, error) {
							console.error(error);
					    	response.error("There was a problem updating request status");
						}
					});
				},
				error : function(object, error) {
					console.error(error);
			    	response.error("There was a problem updating request status");
				}
			});
		},
		error :function(object, error) {
			console.error(error);
	    	response.error("There was a problem updating request status");
		}
	});
});

