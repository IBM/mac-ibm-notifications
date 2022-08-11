# Version 2.8.0 Build 87

## Pop-up
### Enhanchements
* New warning button have been added to the Pop-up UI - [Doc](https://github.com/IBM/mac-ibm-notifications/wiki/Usage)
* `-popup_reminder` now respect the `-position` flag #80
* `checklist` accessory view now accept pre-selected values #85 - [Doc](https://github.com/IBM/mac-ibm-notifications/wiki/Pop-up-UI-Accessory-Views)
### Resolved in this build
* `-icon_width` doesn't properly set Pop-up Icon width
* `timer` accessory view issue with long text #106

## Alert/Banner
### Enhanchements
* New workflow to clean presented alerts/banners from Notification Center using `--resetBanners` and `--resetAlerts` special arguments #74 - [Doc](https://github.com/IBM/mac-ibm-notifications/wiki/Special-arguments)
