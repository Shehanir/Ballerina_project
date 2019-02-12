import ballerina/http;
import ballerina/io;
import ballerina/log;

http:Client clientEndpoint = new("http://localhost:9090");

public function main() {

    http:Request req = new;

    int selection = 0;
    int res = -1;

    while(selection !=3){

        io:println("Select weather results you wish to get.");
        io:println("1. Today forcast");
        io:println("2. Weather posts on twitter");
        io:println("3. Exit");

        string val = io:readln("Enter choice 1 - 3: ");
        var choice = int.convert(val);
        if (choice is int) {
            selection = choice;
        } else {
            io:println("Invalid choice \n");
            continue;
        }

        if (selection == 3) {
            break;
        } else if (selection < 1 || selection > 3) {
            io:println("Invalid choice \n");
            continue;
        }

        if (selection == 1) {

            string getCity = io:readln("Enter your city :");


            json jsonMsg = { city: getCity};
            req.setJsonPayload(jsonMsg);


            var response = clientEndpoint->post("/getWeathear",req);

            var x = req.getJsonPayload();

            if(x is json){
                string city = x.city.toString();
                io:println(city);
            }

            if (response is http:Response) {
                var msg = response.getJsonPayload();
                if (msg is json) {

                    io:print("City :");
                    io:println(msg.name);

                    io:print("Weather :");
                    io:println(msg.weather[0].description);

                    io:print("Temperature :");
                    io:println(msg.main.temp);

                    io:print("pressure :");
                    io:println(msg.main.pressure);

                    io:print("humidity :");
                    io:println(msg.main.humidity);

                    io:print("temp_min :");
                    io:println(msg.main.temp_min);

                    io:print("temp_max :");
                    io:println(msg.main.temp_max);


                } else {
                    log:printError("Response is not json", err = msg);
                }
            } else {
                log:printError("Invalid response", err = response);
            }

            string quit = io:readln("Want to quit ? enter 0: \n");
            var select = int.convert(quit);

            if(select is int){
                res = select;
            }

            if(res == 0){
                break ;
            }

        } else if (selection == 2) {

            string getCityfortweets = io:readln("Enter your city :");

            json jsonMsg = { city: getCityfortweets};
            req.setJsonPayload(jsonMsg);

            var response = clientEndpoint->post("/getWeathearTwitter",req);

            var x = req.getJsonPayload();

            if(x is json){
                string city = x.city.toString();
                io:println(city);
            }

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

            string quit = io:readln("Want to quit ? enter 0: \n");
            var select = int.convert(quit);

            if(select is int){
                res = select;
            }

            if(res == 0){
                break ;
            }

        }

    }
}
