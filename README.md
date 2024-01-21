# image_moderation_app

Mini Flutter Project

## Getting Started

This project is a starting point for a Flutter application.

I tried to implement the use of Google Vision API to be able to moderate images that people select. This was attemoted by calling the API using its token and sending a selected image stored as a variable.
I then attempted to breakdown the repsonse request sent back with the data containing all the different sections it moderated it on to be displayed with the image itself.
I also tried to include different ways of inputting an image, from gallery or camera, (with all images becoming a certain size - not affecting the size of the mobile app).

What I could have implemented:
A verification check to make sure that the uploaded image was an actual image firstly.
Different windows - home screen, screen to pick images etc - making it more of a social media app.
Incoperated more of the Butterfly app itself inside it.
Made sure that I could take an image from camera and be able to upload that.
Breakdown recieved data correctly from the safe search and be able to display it (not 403).

In this project, there is also a file called template.dart which contains all the template code that is first produced when setting up flutter.



For help getting started with Flutter development, view the
[online documentation](https://docs.flutter.dev/), which offers tutorials,
samples, guidance on mobile development, and a full API reference.
