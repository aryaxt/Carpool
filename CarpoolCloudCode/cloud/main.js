
// Use Parse.Cloud.define to define as many cloud functions as you want.
// For example:


Parse.Cloud.beforeSave("CarPoolOffer", function(request, response) {
  if (request.object.get("time") == null) {
    response.error("Time is required");
  } else if (request.object.get("startLocation") == null) {
    response.error("startLocation is required");
  } else if (request.object.get("endLocation") == null) {
	response.error("endLocation is required");
  } else {
    response.success();
  }
});
