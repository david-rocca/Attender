David Rocca
Attender

#Project Goal: 

The goal of this project was to create a mobile application that allows the ability to take attendance of a group of people and validate that they are in range of the location that they say they are. This was acheived by using the gps sensors in all of the clients phones along with some server side computing to keep track of all locations and active sessions.


#Project Design:

TThe project was designed using Swift 2.0 for the iOS application and PHP for the server side.

The design of the project was to use a RESTful (minus authorization tokens) system to keep track of all of the current users and sessions. The server was to basically act as the middle man between all of the data and the clients that needed that data. This was not only only for simplicity but also for location privacy. The clients phones were never sent eachothers location but only a true or false if they were in range. 

I have included two files in my repo for representations of the flow of data for this project. One is the data communication graph that was in my powerpoint while the other is an overall project flow diagram. These are located in the "Graphs" folder.

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
