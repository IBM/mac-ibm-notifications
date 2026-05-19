# [3.2.4 - 136] - Unreleased

## General Updates
### Bug Fixes
- Resolved an issue that could cause the desired UI not to appear if IBM Notifier is invoked after first login of the user. #302

# [3.2.3 - 135] - 2025-10-28

## General Updates
### Bug Fixes
- Resolved an issue that could cause the popup window to be misaligned when the -position argument was used.
- Fixed an issue that could cause the app to crash unexpectedly when multiple accessory views are used.
- Fixed an issue that prevented the image accessory view from appearing when used alongside a video accessory view.

### Enhancements
- Updated version and copyrights.
- Support for Liquid Glass design language.

# [3.2.2 - 128] - 2025-03-06

## General Updates
### Bug Fixes
* Fixed an issue that caused wrong label and exit code on the main button during "user interruptible" pogress bar run - #229 

## [3.2.1 - 127] - 2024-11-13

## General Updates
### Bug Fixes
* Fixed an issue that caused missing title bar buttons on Onboarding UI - #218
* Fixed an issue with unexpected app crashes while using the `slideshow` accessory view - #223 

# [3.2.0 - 126] - 2024-07-16

## General Updates
### Bug Fixes
* Fixed an issue with text colour in `html` and `htmlwhitebox` accessory views - #211

## Pop-up
### Improvements
* It's now possible to hide the title bar in the popup UI using the `-hide_title_bar` argument - [Doc](https://github.com/IBM/mac-ibm-notifications/wiki/Usage) - #181
* The popup UI can now show more that two accessory views using `-accessory_view_type_N` and `-accessory_view_payload_N` arguments, where `N` is an integer - [Doc](https://github.com/IBM/mac-ibm-notifications/wiki/Usage) - #202
### Bug Fixes
* Resolved an issue with the popup UI icon's aspect ratio when using custom icons - #201

## Onboarding
### Bug Fixes
* Increased the horizontal margin for the onboarding UI texts - #206 
* Resolved an issue that caused unexpected behavior of the progress bar in a single-paged onboarding - #214  

# [3.1.0 - 110] - 2023-12-13

## General Updates
### Improvements
* Introduced a new `slideshow` accessory view.
* Added a new `-disable_quit` argument to prevent the command cmd+q from closing the UI. Close #180 
* Added support for displaying GIFs in the image accessory view. Close #165 
* Introduced a new payload key for the `datepicker` accessory view to specify a limited range for selecting dates/times. Close #178 
### Bug Fixes
* Resolved an issue where incorrect behavior occurred when both `-unmovable` and -`always_on_top` arguments were used simultaneously. Close #193 

## Pop-up
### Improvements
* Added a new `-custom_width` argument to set a custom width for the pop-up UI. Close #133 
* Introduced a new `-buttonless` argument for displaying a pop-up UI without any visible destructive CTA (Call to Action) buttons. Close #179 
### Bug Fixes
* Fixed a problem with custom icon sizing in the pop-up UI, which previously caused text to be cropped. Close #189 

# [3.0.3 - 108] - 2023-09-06

## Onboarding
### Bug fixes
* Fixed an issue where the Onboarding UI incorrectly positioned the output file. #186 

# [3.0.2 - 107] - 2023-09-05

## General Updates
### Bug Fixes
* Resolved an issue with custom fonts in the `html` and `htmlwhitebox` accessory views on macOS 14 Sonoma. Closes #163  
* Resolved an issue that cause the wrong calculation of the size for the info section on pop-up and onboarding UIs.
* Other minor fixes and refactor of the codebase.

## Notification Banner/Alert
### Enhancements
*  Now the banner/alert UIs use emit sounds only if the Audio System Setting "Play user interface sound effects" is enabled.

## Onboarding
### Bug Fixes
* Fixed an issue with the Onboarding window size when using some specific accessory views. Closes #169 
* Resolved a bug that cause the wrong primary button label on sigle paged onboarding workflows. Closes #174
* Resolved a bug that cause the missing update of the information in the Onboarding output's file. Closes #170 

# [3.0.0 - 104] - 2023-07-24

## General Updates
### Improvements
* Migrated the UI from AppKit to SwiftUI for modernized UI experience and streamlined feature development. #110 
* Integrated SF Symbol support for icons. #113 
* Added `-background_panel` argument for defining a comprehensive background view across all screens/spaces. #89
* Introduced `-unmovable` argument to ensure the popup/onboarding UI remains stationary on the screen.  #152
* Introduced a new `datepicker` accessory view. #119
### Bug Fixes
* Resolved a bug causing incorrect interpretation of / in progress bar payloads.
* Fixed an issue where lengthy text would be cut off at the end when used with the checklist accessory view.
* Corrected a problem that returned the wrong code when the cmd+q keyboard shortcut was used. #138

## Pop-up
### Improvements
* Implemented a tracking feature for the "Play user interface sound effect" setting to prevent IBM Notifier from playing pop-up sounds when the option is disabled.
### Bug Fixes
* Resolved a bug causing wrong representation of the pop-up text when custom size of the icon were defined. #143

## Onboarding
### Improvements
* Enabled defining a Tertiary button on the onboarding page. #123
* Added the capability to set custom labels for onboarding buttons. #131 
* Integrated a feature to set a timeout for the onboarding UI. #154
* Developed a new onboarding progress bar mode to track the progress of onboarding UI. #109
### Deprecated
* Markdown support for Onboarding UI's subtitle and body texts on macOS 11 Big Sur

## Notes to the release
* We have updated our deployment target to macOS 11 Big Sur. This decision was made due to technological constraints with SwiftUI present in macOS 10.15 and earlier versions.

# [2.9.1 - 96] - 2022-10-03

## Pop-up
### Enhancements
* The default Pop-up UI icon resolution have been optimised - Close #116 
### Resolved in this build
* Fixed: `secureinput` accessory view appear higher than normal when used in some scenarios - Close #112 
* Fixed: main button still shows "Cancel" label when progress bar end - Close #128  
* Fixed: issue with the representation of UTF8 special characters in `html`/`htmlwhitebox` Accessory Views

## Alert/Banner
### Resolved in this build
* Fixed: Notification Center Alerts/Banners not pull attention away from keyboard when appears - Close #98 

## Onboarding
### Resolved in this build
* Fixed: duplication of the onboarding page content when window is minimised - Close #121  
* Fixed: missing update of common Onboarding UI progress bar - Close #114 

## SystemAlert
### Enhanchements
* New SystemAlert UI available - [Doc](https://github.com/IBM/mac-ibm-notifications/wiki/Usage)
