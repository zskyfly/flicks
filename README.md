# Project 1 - *Flick Finder*

**Flick Finder** is a movies app using the [The Movie Database API](http://docs.themoviedb.apiary.io/#).

Time spent: **17** hours spent in total

## User Stories

The following **required** functionality is completed:

- [x] User can view a list of movies currently playing in theaters. Poster images load asynchronously.
- [x] User can view movie details by tapping on a cell.
- [x] User sees loading state while waiting for the API.
- [x] User sees an error message when there is a network error.
- [x] User can pull to refresh the movie list.

The following **optional** features are implemented:

- [x] Add a tab bar for **Now Playing** and **Top Rated** movies.
- [x] Implement segmented control to switch between list view and grid view.
- [x] Add a search bar, filters existing results
- [x] For the large poster, load the low-res image first, switch to high-res when complete.

The following **additional** features are implemented:

- [x] Hide tabBarController on detail view
- [x] Smart-infinite scroll: loads more results until all results loaded from endpoint
- [x] Enhanced details scroll view auto-resizes to content, overlays background image and scroll bars hidden
- [x] Convert release date from "2012-12-21" to NSDate and then custom format, "Dec 21, 2012"
- [x] Lots of custom assets and fallback movie poster images when images fail to load
- [x] Network error displays actual human readable error message returned in NSError

## Video Walkthrough

Here's a walkthrough of implemented user stories:

<img src='https://cloud.githubusercontent.com/assets/1156702/13135125/9f80da08-d5c2-11e5-9d00-36e86b0d3c82.gif' title='Video Walkthrough' width='' alt='Video Walkthrough' />

GIF created with [LiceCap](http://www.cockos.com/licecap/).

## Notes

There are so many directions this app could go, and it was easy to get sucked into the details of each feature.  
I wish I had more time to go deep on each one, but feel like I covered a wide range of features given the time allotted.

## License

    Copyright [2016] [zsky productions]

    Licensed under the Apache License, Version 2.0 (the "License");
    you may not use this file except in compliance with the License.
    You may obtain a copy of the License at

        http://www.apache.org/licenses/LICENSE-2.0

    Unless required by applicable law or agreed to in writing, software
    distributed under the License is distributed on an "AS IS" BASIS,
    WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
    See the License for the specific language governing permissions and
    limitations under the License.
