# Interview
Sample code for demonstrating implementation of simple Restful web services over HTTP.

Installation

Universal app requiring iOS 8 and above.

Uses RestKit with CoreData - 3rd party library for client server communication and persistence. 

Problem

A JSON over HTTP API is deployed at http://surya-interview.appspot.com. The goal is to make requests to it and render the data obtained from it in an Android application.

Your app should start with a view that asks the user to enter an email address. You are then to make an HTTP POST request to http://surya-interview.appspot.com/list. The post body must be a JSON object that looks like this:

{
    "emailId": "<email address you got from user>"
}
The response will contain a JSON object that looks like this:

{
    "items": [
        {
            "emailId": "john@doe.com",
            "imageUrl": "http//something.com/foo.jpg",
            "firstName": "John",
            "lastName": "Doe"
        },
        {
            "emailId": "jane@doe.com",
            "imageUrl": "http//something.com/bar.jpg",
            "firstName": "Jane",
            "lastName": "Doe"
        }
    ]
}
You are to cache this data locally on the device and render each of these items in a row inside a UITableView.