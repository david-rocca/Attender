David Rocca
Attender

#Project Goal: 

The goal of this project was to create a mobile application that allows the ability to take attendance of a group of people and validate that they are in range of the location that they say they are. This was acheived by using the gps sensors in all of the clients phones along with some server side computing to keep track of all locations and active sessions.


#Project Design:

TThe project was designed using Swift 2.0 for the iOS application and PHP for the server side.

The design of the project was to use a RESTful (minus authorization tokens) system to keep track of all of the current users and sessions. The server was to basically act as the middle man between all of the data and the clients that needed that data. This was not only only for simplicity but also for location privacy. The clients phones were never sent eachothers location but only a true or false if they were in range. 

I have included two files in my repo for representations of the flow of data for this project. One is the data communication graph that was in my powerpoint while the other is an overall project flow diagram. These are located in the "Graphs" folder. In the next section I go into detail about how each part of the code works and I reference the files that I mentioned above. 





#Design of Server

For the php code I created a class that handled all of the database functions. I created it so that once the handle to the database was created in that instance you could access it using the "handle" variable. Once the Php script started the first step was to make sure it was a request coming from one of my clients. I did this by always setting the type key to "Rocca". My server was set to drop all requests if that was not set correctly. The php would then check the method that was being sent. The php would then call the correct function that would handle all database requests for that specific need. At this point I did not use any sort of auth token. I did all of my "Auth" by just checking the username of the user who made the request. This is obviously not good and owuld need to be changed if you were to ever release this to the public. In the Data Comm graph you can see a sample situtation that the application could encounter.

#Design of iOS

For the iOS code I started with the networking library. This was simple non-blocking networking class that would make a simple http request to a designed host. This would use the POST system along with a JSON dictionary. This class would also contain all of the networking requests for the whole applicaton that the other classes would call statically. This class would also pass the response to the correct class that made the call so that they could react to the response in the way that they wanted to. You can see in the DataFlow image in the graphs folder that this acted as the gateway between the application and the server. This was the only part of the app that had persmissions to make the ACTUAL request.

I then moved on to the login and sign up pages. I browesed Pintrest for ideas for a lay out. Once I found one I implemented it and created all of my own custom animations entirely from scratch. This was probably my most proud accomplishment for the whole project. This page would talk to the networking class and also the Users class. It would use the networking class to do the obvious logging in and signing up functions. The users class was made to just have a simple way to pass the user that was logged in to the rest of the application.

The next step of the design was to create the screen of the application that handled the process of creating or joining a session. This screen of the app was also where all of the location services that was being polled from the gps on the phone. The design for this part of the application was just one text field with two buttons. The create a session button would get a random six digits from the server and then segue to the next screen. If the user entered a correct six digits and the server responeded that they were within 100 meters they would be segued to their next page. This relationship is shown in the application box on the DataFlow Graph.


The next step of the design was to create the table that showed what users that joined the session. I did not implement any sort of automatic fetch system. I only implemented a pull to refresh system that would allow the user to poll whenever they wanted to. 

The final step that was implemented was just a segue for when the user successfully joins a session. While this was not needed it was just nice to have a visual representation when it happned. 






#Files

php: 
index.php - Functioned as the server for this project. Parsed all requests and posted in json the correct response and data based on calculations. Would also make all changes to the database.

iOS:
AppDelegate.swift - Starting point of an iOS application. Mostly generated code by xcode. Including Application life cycle functions.

JoinedSessionViewController.swift - If a user successfuly joined a session they would be moved to this scene in the story board. This held all logic for that page. However due to this screen not doing much there is not anything in this file except for lifecycle functions.

MainAreaViewController.swift - This file contains all logic for joining or creating a session including all lifecycle functions for that screen and networking responses.

ManageSession.swift - If you created a session successfully you would be transferd to this page. This file held all of the logic for the table view and all lifecycle and networking functions. 

Strings.swift - A file to hold all string literals used in the application similar to the strings file in Android. However, when I started to get under a time crunch I started to not add things to this.

Users.swift - A simple class to create user objects so they could be passed around easily.

ViewController.swift - This file contains all logic, animations, and network request for the log in page. 

Networking.swift - Includes all implementations for making networking requests and passing on the responses to the correct listeners.

Storyboard.swift - UI Storyboard that helps design UI
