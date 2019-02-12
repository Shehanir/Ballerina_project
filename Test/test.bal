import ballerina/io;
import ballerina/test;
import ballerina/http;
import ballerina/log;

http:Client clientEndpoint1 = new("http://localhost:9090");

http:Request req1 = new;

@test:Config
function testWeatherForcast(){


    //mock data
    string city = "colombo";

    json jsonMsg = { city: city};
    req1.setJsonPayload(jsonMsg);

    var response = clientEndpoint1->post("/getWeathear",req1);

    if (response is http:Response) {
        var msg = response.getJsonPayload();
        if (msg is json) {

            io:print(msg);

        } else {
            log:printError("Response is not json", err = msg);
        }
    } else {
        log:printError("Invalid response", err = response);
    }
}


@test:Config
function testWeatherForcastInTwitter(){

    //mock data
    string city = "london";

    json jsonMsg = { city: city};
    req1.setJsonPayload(jsonMsg);

    var response = clientEndpoint1->post("/getWeathearTwitter",req1);

    if (response is http:Response) {
        var msg = response.getPayloadAsString();
        if (msg is string) {
            io:println(msg);

        } else {
            log:printError("Response is not json", err = msg);
        }
    } else {
        log:printError("Invalid response", err = response);
    }


}