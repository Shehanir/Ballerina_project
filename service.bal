import ballerina/config;
import ballerina/http;
import ballerina/io;
import wso2/twitter;

http:Client homer = new("http://api.openweathermap.org");

twitter:TwitterConfiguration twitterConfig = {
    clientId: "FUuUq8pT8gUmrLgUaW6ExEd0r",
    clientSecret: "os5ZlXPOrWHcTHsJDDx5IT1eIrMw9RVjfQSIFnBKHWgb917YdL",
    accessToken: "964436640239206401-VCGe0IetntWsK8SQbtoN8mwa6OTHxBA",
    accessTokenSecret: "wLoHFDcCtRFCrFFYNtABsVKSIh6aXlMESweiyW6KOqRwY"
};

twitter:Client twitterClient = new(twitterConfig);

@http:ServiceConfig {
    basePath: "/"
}
service hello on new http:Listener(9090) {
    @http:ResourceConfig {
        path: "getWeathear",
        methods: ["POST"]
    }
    resource function hi (http:Caller caller, http:Request request) returns error? {

        var req = request.getJsonPayload();
        string city ="";
        if(req is json){
            city = req.city.toString();
            io:println(city);
        }

        var hResp = check homer->get("/data/2.5/weather?q="+ untaint city +"&appid=f4ed0357aa8ac7012a4e4084fd8479a9");

        var status = check hResp.getJsonPayload();

        json myJson = status;
        http:Response res = new;

        res.setPayload(untaint status);

        _ = check caller->respond(res);
        return;
    }

    @http:ResourceConfig{
        path: "getWeathearTwitter",
        methods: ["POST"]
    }
    resource function weather (http:Caller caller, http:Request request) returns error? {

        string twitterData = "";

        var req = request.getJsonPayload();
        string citytweets ="";
        if(req is json){
            citytweets = req.city.toString();
            io:println(citytweets);
        }

        string queryStr = "#weather #" + untaint citytweets;
        twitter:SearchRequest requ = {
            tweetsCount:"10"
        };
        var tweetResponse = twitterClient->search(queryStr, requ);

        if (tweetResponse is error) {
            io:println("twitter response",tweetResponse);
        } else {
            io:println("twitter response length",tweetResponse.length());

            foreach var item in tweetResponse {
                io:println("twitter response",item.text);
                twitterData = twitterData + item.text ;
            }

            io:println("twitter data",twitterData);
        }

        http:Response res = new;


        res.setPayload(untaint twitterData);

        _ = check caller->respond(res);
        return;
    }

}

