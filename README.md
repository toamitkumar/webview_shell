webview_shell
=============

A conatiner for HTML5 applications. 

## Pre-requisite

* Zip your html5 application and push it inside a webserver (from where app can download it)

## Feature Set

* Add a new html5 application with a name and URL to download the zip file
* Displays icon for each html5 application in a nice GridView Dashboard
* Gives option to Open/Update/Delete the application


### Conventions

* Root of your application directory should have `` index.html `` file. This file is launched on click on app.
* Root of your application should have `` APP_NAME.png `` file which is used as app icon on the gridview dashboard