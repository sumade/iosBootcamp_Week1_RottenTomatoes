## Rotten Tomatoes [(raw)](https://gist.githubusercontent.com/chug2k/42bf3a7a26c635f70525/raw/c1c86cad42d541d2a08badaafee233c75148fa43/gistfile1.md)

This is a moovies app displaying box office and top rental DVDs using cached Rotten Tomatoes data
* [Movies Data](https://gist.githubusercontent.com/timothy1ee/d1778ca5b944ed974db0/raw/489d812c7ceeec0ac15ab77bf7c47849f2d1eb2b/gistfile1.json)
* [DVD Data](https://gist.githubusercontent.com/timothy1ee/e41513a57049e21bc6cf/raw/b490e79be2d21818f28614ec933d5d8f467f0a66/gistfile1.json)

Time spent: `15`
Research hours: 5
Implementation hours: 10

### Features
- view movies or dvds in a list
- click on movie to view details
- user can refresh the list by pulling down at the top of the screen. since we are using cached data, there will not be any observed change in the list contents
- network errors display an alert. in this app, a network error is indicated when a URL fetch returns error; the app does not check for network status via low level APIs. 
- to simulate the network error, every 5th pull-to-refresh will trigger a URL fetch to a bad address, which should result in a network error alert
- user can switch between movies and dvds via a handy dandy navigation at the bottom of the screen
- user can filter the movies/dvd lists with a search bar. the list changes as the user types letters
- images are loaded asynchronously, and loaded from cache when possible
- app icon changed (iphone6 / ios8+)
- app launch screen changed (iphone6 / ios8+)

#### Required

- [x] User can view a list of movies. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees error message when there is a network error: [image](RottenTomatoes/RottenTomatoes_Error.png)
- [x] User can pull to refresh the movie list.

#### Optional

- [x] Add a tab bar for Box Office and DVD.
- [x] Add a search bar.
- [-] All images fade in. Only high-res poster image fades in
- [x] For the large poster, load the low-res image first, switch to high-res when complete.
- [-] Customize the highlight and selection effect of the cell. Turned them off.
- [-] Customize the navigation bar. Partially. Changed the font and background color.
- [ ] Implement segmented control to switch between list view and grid view.

#### Acknowledgements

### Walkthrough

![Video Walkthrough](RottenTomatoes/RottenTomatoesWalkthrough.gif)

Walkthrough provided by licecap (http://www.cockos.com/licecap/)

Credits
---------
* [Rotten Tomatoes API](http://developer.rottentomatoes.com/docs/read/JSON)
* [AFNetworking](https://github.com/AFNetworking/AFNetworking)
* DVD File icon by mantisshrimpdesign from the Noun Project
* movie reel icon by Josue Oquendo from the Noun Project
* Homer Simpson for the creation of tomacco



