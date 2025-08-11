# 🎵 JustPlay!  

JustPlay! is a beautiful and feature-rich music player app for local music files, with a stunning user interface, built to deliver a seamless audio playback experience.

* Intended for an up-and-running system of library management and playback of local music collections without any ads or cluttered UI.
*  Robust visuals without annoying **Unknown Artist, Unknown Album,** etc. littered everywhere for files without appropriate metadata.
*  Shuffler Screen for a level of user control added to a random selection of tracks.  
*  Planned additional features like notification playback controls, playlists management and exporting, editing metadata, tags and much more in progress.

### Feature Progress / Checklist:
#### Functionality:
- [x] Search Menu
- [x] Sort By store into SharedPreferences
- [x] Repeat option single track upon completion
- [x] Shuffle Play populate single Track into NowPlayingMenu()
- [ ] Shuffler Screen
	- [x] Shuffler Menu for constant random selection of tracks
	- [ ] Shuffler add all to NowPlayingList
	- [ ] Edit Shuffler random track count?
	- [ ] Manual Re-roll Shuffler
- [ ] Background Playback
	- [ ] just_audio_background implementation
	- [ ] Foreground Android audio service
	- [ ] Notification Controls
- [ ] Search Screen
	- [ ] Search Screen add all to NowPlayingList
	- [ ] Search Screen shuffle play all to NowPlayingList
- [ ] Playlists
	- [x] Multiple playback
	- [x] Add to playlist
	- [ ] Snackbars shown on playlist updates
	- [ ] Reorder playlist elements with draggable
	- [x] Swipe / Dismiss to remove from nowPlayingList - Dismissible() widget
	- [ ] Shuffle All
	- [x] Repeat All
	- [ ] Repeat Single Toggle
	- [ ] Save Current Playlist into ObjectBox Database - Playlist Title, Track Count, Total Duration
	- [ ] User input custom icons 
- [ ] Song Genre Tags
	- [ ] Track type List\<String\> song genre tags
	- [ ] Search filters based on genre tags
	- [ ] Edit Song Tags Menu
	- [ ] Fetch Album Art from the Internet
- [ ] Download songs in a minibrowser?
- [ ] Syncing files library
- [ ] Sharing playlists into basic format / YTMusic / Spotify playlists
- [ ] Sleep Timer

#### Visual:
- [ ] Audio Visualizers 
- [ ] Dynamic Theming
- [ ] Try Sliver AppBar for HomeScreen?
- [ ] Animated Splash Screen
- [x] Miniplayer Progress Bar - StreamBuilder() > LinearProgressIndicator()
- [x] Hide Miniplayer upon NowPlaybackMenu expansion - AnimatedCrossFade()
- [ ] Color
	- [ ] Accent Color / Background Blur Color extraction from albumart
	- [ ] Dynamic accent color based on albumart / tags
	- [ ] Accent color to CustomGridCards in Shuffler
- [ ] Swipeable ListItems
- [ ] Up Next Widget (Needs playlists)
- [ ] Waveform extraction?
- [ ] Custom/different slider?

### Other
- [ ] Refactor buildLibrary() function into AudioPlayerProvider/TrackStoreDatabase class

#### Known Bugs (Checked = Fixed):
- [x] HomeScreen Receiving unexpected empty future case due to duplicate ObjectBox calls on rebuilds to create new track-store causing OBX_ERROR code 10001 - refactored removing DatabaseProvider, instead using a app-wide variable trackStoreDatabase in main.dart for global database instance, trackStore and db functions
- [ ] Over-scrolling stretching effect slightly distorts CustomListView Elements
- [ ] NowPlayingMenu swipe up is laggy - current solution of AnimatedCrossFade not satisfactory
- [ ] HomeScreen ListViewBuilder Scrolling is laggy
- [ ] Incorrect Track Duration fetched for certain songs + off by few seconds for some songs
- [x] Search Screen consecutive searches stacking screens on top of each other - Added navigation onto SearchScreen and removed the double onSubmit causing issue
- [ ] Search Function is not satisfactory, is case-insensitive and is too typo-sensitive
- [ ] Search Screen Last Result slightly covered by NowPlayingMenu
- [ ] Search Screen NowPlayingMenu slightly covered by keyboard when opened


### Tech Stack 🛠️  
+ Flutter framework with packages:  
+ State Management: [provider](https://pub.dev/packages/provider)  
+ On-device Database: [objectbox](https://pub.dev/packages/objectbox)  
+ Cache Storage & Preferences: [shared_preferences](https://pub.dev/packages/shared_preferences)  
+ Audio Metadata Handling: [audiotags](https://pub.dev/packages/audiotags)  
+ Audio Player: [just_audio](https://pub.dev/packages/just_audio)  
+ Permissions Management: [permission_handler](https://pub.dev/packages/permission_handler), [device_info_plus](https://pub.dev/packages/device_info_plus)  
+ File Management: [file_picker](https://pub.dev/packages/file_picker)    

### Screenshots 📸
<img src="screenshots/screenshot_1.jpg" alt="screenshot_1" width="350">  
<img src="screenshots/screenshot_2.jpg" alt="screenshot_2" width="350">  
<img src="screenshots/screenshot_3.jpg" alt="screenshot_3" width="350">  
<img src="screenshots/screenshot_4.jpg" alt="screenshot_4" width="350">  
<img src="screenshots/screenshot_5.jpg" alt="screenshot_5" width="350">  

Stay tuned for more features and improvements! 🚀  
