# MyMBTA : MBTA-Application for iOS

<img src = "README_images/mocklogo.png" width = "200">

This is a work in progress. Since this project is still in developmental stage, any images or fonts used <b> currently </b> in this project will not be included in the final project since some are retrieved from Google and they are not of my creation. This is an unpublished project, therefore, there are no economical gains whatsoever from the production of this. The logo for this application is NOT the logo that will be used upon release, this is simply used as a prototype to provide more aesthetic to the production stage.

I have made all of my sources free for the public. Anybody can view this, and anybody can use any source of code contained in this GitHub project free of will. No crediting is needed but it will be much appreciated :)

# What exactly is MyMBTA?

This MBTA Application, with a draft mock-up name of "MyMBTA" is an iOS application coded by Jorge Jimenez using the latest version of XCode. The final work is expected to be an application which is expected to be used by the citizens of Boston as their most reliant source when using any of the services provided by the Massachusetts Bay Transportation Authority. This application is not related or endorsed by the Massachusetts Bay Transportation Authority.

In the demo stage, no auto-layout is implemented for any iPhone other than the iPhone X. Therefore, any rendering and previewing will be previewed for now using iPhone X as the base size of the canvas. In other words, this will not run to size in an iPhone 7.

# How does it work and what features are currently implemented?

MyMBTA makes use of the <a href = "https://www.mbta.com/developers/v3-api"> MBTA V3 API </a> and uses <a href = "https://github.com/Alamofire/Alamofire"> Alamofire </a> to call the MBTA V3 API to make calls to the API to retrieve live or constant data provided by the Massachusetts Bay Transportation Authority. The application has a one time (only appears on installment) user friendly introduction to the application, which shows the users what to expect. This one-time feature is not up to date at the moment and does not provide the correct information since the project is up to development, but the complete framework is already implemented to the project.

<img src = "README_images/one.png">

Furthermore, the project also makes use of <b> CoreData </b> by making an initial call to the API and storing all the names and important information of every route (not including stops and other information) locally on the application. This is done on download and it saves time, because everytime a user enters the application it does not have to reconnect to the internet and make a tedious call which takes time to load. The application uses <a href = "https://github.com/SwiftyJSON/SwiftyJSON"> SwiftyJSON </a> to parse any JSON returned by the API. At the moment, users are able to look at all the routes, which include:
<ul>
  <li> Light Rail </li>
  <li> Heavy Rail </li>
  <li> Commuter Rail </li>
  <li> Buses </li>
  <li> Ferry </li>
</ul>

<img src = "README_images/four.png" width = "300">

The application also uses <b> CoreData </b> and <b> NSFetchRequest </b> to allow the user to search specific routes. Currently, routes can be searched by name or type of route (i.e Green Line B or Commuter Rail). In future stages, the search bar is expected to work by inserting key words, stops, location name and even lat/long coordinates.

<img src = "README_images/five.jpg" width = "300">

If a user is interested in a specific stop, he is allowed to click on the stop, producing an additional call to the API which retrieves information on every stop. The stops are displayed for the users to see, and users can filter between a Northbound or Southbound display.

<img src = "README_images/sixx.jpg" width = "300">

Using <b> CLLocation </b> and <b> MapKit </b>, by clicking on the direction button of any of these stops will display the exact location of the stop inside your Apple Maps. For example, if a user decides to go into <b> Green Line B </b> and display the location of the <b> Boston University Central Stop </b>, this is what they would see:

<img src = "README_images/seven.jpg" width = "300">

Following protocols and safety from Apple, the application will ask the users to share its location in order to pinpoint stop proximity to the users. Once more, using <b> CLLocation </b>, it will approximate and calculate as accurate as possible the distance from the user to a given stop, using a desired accuracy of <b> kCLLocationAccuracyBestForNavigation </b>. This updates live as the user's location changes. In this simulation, the user is currently located at the Boston University College Of Fine Arts, which is located at lat: 42.351170 and long: -71.114370, and selects the Green Line B, which passes right through Boston University and has one stop almost in front of the building:

<img src = "README_images/eight.jpg" width = "300">

The distance is shown in both miles and feet depending on the proximity of the user.

The arrival button does not currently work but the framework is added for implementation. For user convenience but and memory enhancement, this feature <b> currently </b> works in a similar way as caching does by saving a copy of the most recent called stop to not have to call the API once again.

Other Cocoapods used by the application include <a href = "https://github.com/viccalexander/Chameleon"> ChameleonFramework </a>, <a href = "https://github.com/SVProgressHUD/SVProgressHUD"> SVProgressHUD </a> and <a href = "https://cocoapods.org/pods/TableViewReloadAnimation"> TableViewReloadAnimation </a>.

# What are some features expected to be implemented in this application.

Currently, somewhere in my mind I have jotted down in my head the following head. This application will certainly include but it is not limited to:

<ul>
  <li> Real-time updates on service issues and track information </li>
  <li> Location services and predictions: find the location of any stop on the map, find your distance to and from the stop, view where the train currently is, precise predictions on when a certain train is expected to be at a certain stop, nearby stop filtering depending on your location and more.   </li>
  <li> Home Page: Have a user-friendly home page which filters news or important information relating to the MBTA or even Massachusetts in general. </li>
  <li> Favorites: Have a favorite options which allows user to filter favorite routes and stops and be able to retrieve information of them at better ease. This is basically the most essential feature because in here is where the user will store the routes and stops they use day by day. This feature may even include a "Create Custom Route" option for uses who use multiple services in a single day. </li>
</ul>

Again, these are simple some of many ideas that will be included in the final project. If there are any ideas which you would like to share with me or if you would want to collaborate in this project, feel free to email me at jorjimen@bu.edu.

You can also find me on <a href = "https://www.linkedin.com/in/jorge-jimenez-315801186/">  LinkedIn</a>.
