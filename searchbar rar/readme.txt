To install the searchbar in your theme:
	-drop the SearchBar folder under your Graphics folder
	-drop the searchbar.lua under BGAnimations folder
	-add the actor to your ScreenSelectMusic overlay/ScreenNetSelectMusic overlay, ie:
	
			t[#t+1] = LoadActor("searchbar")
			
			or.. (if is subfoldered and you are editing a file named default.lua)
			
			t[#t+1] = LoadActor("../searchbar")
			
	- works! ! ! ! ! !
	
tested on 5.0.7 without problems