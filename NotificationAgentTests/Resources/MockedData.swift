//
//  MochedModel.swift
//  NotificationAgentTests
//
//  Created by Simone Martorelli on 7/15/20.
//  Copyright © 2020 IBM Inc. All rights reserved
//  SPDX-License-Identifier: Apache2.0
//
//  swiftlint:disable line_length

import Foundation

struct MockedData {
    // MARK: Dictionaries

    static let correctFormatDictionaries: [[String: Any]] = [
        // No buttons no accessory view
        ["type": "popup",
        "title": "Test_Title",
        "subtitle": "Test_subtitle"],
        // No buttons no title no subtitle with accessory view
        ["type": "popup",
        "accessory_view_type": "text",
        "accessory_view_payload": "Test_accessory_view"],
        // Multiple buttons
        ["type": "popup",
        "title": "Test_Title",
        "subtitle": "Test_subtitle",
        "main_button_label": "Button One",
        "secondary_button_label": "Button_Two",
        "secondary_button_cta_type": "link",
        "secondary_button_cta_payload": "https://www.google.com"],
        // One help button
        ["type": "popup",
        "title": "Test_Title",
        "subtitle": "Test_subtitle",
        "main_button_label": "Button_One",
        "secondary_button_label": "Button_Two",
        "secondary_button_cta_type": "link",
        "secondary_button_cta_payload": "https://www.google.com",
        "help_button_cta_type": "infopopup",
        "help_button_cta_payload": "test_text"],
        // Destructive tertiary button
        ["type": "popup",
         "title": "Test_Title",
         "subtitle": "Test_subtitle",
         "main_button_label": "Button_One",
         "secondary_button_label": "Button_Two",
         "secondary_button_cta_type": "link",
         "secondary_button_cta_payload": "https://www.google.com",
         "tertiary_button_label": "Button_Three",
         "tertiary_button_cta_type": "exitlink",
         "tertiary_button_cta_payload": "https://www.google.com"]
    ]

    static let wrongFormatDictionaries: [[String: Any]] = [
        // Only type
        ["type": "popup"],
        ["type": "banner"],
        // No element
        [:]
    ]

    // MARK: - Argument lists

    static let correctArgumentLists: [[String]] = [
        // No buttons no accessory view
        ["path",
         "--isRunningTestForCommandLine",
         "-type", "popup",
         "-title", "Test_Title",
         "-subtitle", "Test_subtitle"],
        // No buttons no title no subtitle with accessory view
        ["path",
         "--isRunningTestForCommandLine",
         "-type", "popup",
         "-accessory_view_type", "text",
         "-accessory_view_payload", "Test_accessory_view"],
        // Multiple buttons
        ["path",
         "--isRunningTestForCommandLine",
         "-type", "popup",
         "-title", "Test_Title",
         "-subtitle", "Test_subtitle",
         "-main_button_label", "Button One",
         "-secondary_button_label", "Button_Two",
         "-secondary_button_cta_type", "link",
         "-secondary_button_cta_payload", "https://www.google.com"],
        // One help button
        ["path",
         "--isRunningTestForCommandLine",
         "-type", "popup",
         "-title", "Test_Title",
         "-subtitle", "Test_subtitle",
         "-main_button_label", "Button_One",
         "-main_button_cta_type", "policy",
         "-main_button_cta_payload", "testpolicy",
         "-secondary_button_label", "Button_Two",
         "-secondary_button_cta_type", "link",
         "-secondary_button_cta_payload", "https://www.google.com",
         "-help_button_cta_type", "infopopup",
         "-help_button_cta_payload", "test_text"],
        // Destructive tertiary button
        ["path",
         "--isRunningTestForCommandLine",
         "-type", "popup",
         "-title", "Test_Title",
         "-subtitle", "Test_subtitle",
         "-main_button_label", "Button_One",
         "-main_button_cta_type", "policy",
         "-main_button_cta_payload", "testpolicy",
         "-secondary_button_label", "Button_Two",
         "-secondary_button_cta_type", "link",
         "-secondary_button_cta_payload", "https://www.google.com",
         "-tertiary_button_label", "Button_Three",
         "-tertiary_button_cta_type", "exitlink",
         "-tertiary_button_cta_payload", "https://www.google.com"]
    ]

    static let wrongArgumentLists: [[String]] = [
        // Only type
        ["path",
         "--isRunningTestForCommandLine",
         "-type", "popup"],
        ["path",
         "--isRunningTestForCommandLine",
         "-type", "banner"],
        // No element
        ["path",
         "--isRunningTestForCommandLine"]
    ]

    // MARK: - URLs

    static let correctURLs: [URL] = [
        // Popups
        URL(string: "macatibm:shownotification?type=popup&subtitle=Here%20is%20a%20list%20of%20the%20software%20that%20was%20installed%20by%20Mac@IBM.%20All%20items%20in%20this%20list%20will%20be%20removed.%20You%20will%20need%20to%20contact%20the%20helpline%20and%20request%20an%20exemption%20if%20you%20need%20to%20keep%20any%20of%20the%20applications.%20Clicking%20Remove%20will%20unistall%20all%20checked%20applications.&accessory_view_type=whitebox&accessory_view_payload=VPN%20%5CnIBM%20WIFI%20%5CnNotes%20%5CnFireFox%20%5CnSlack%20%5CnICLA%20%5CnFileZilla&main_button_label=Remove&main_button_cta_type=none&main_button_cta_payload=User%20Selected%20Remove&secondary_button_label=Cancel&secondary_button_cta_type=none&secondary_button_cta_payload=User%20Selected%20Cancel")!,
        URL(string: "macatibm:shownotification?type=popup&title=IBM%20Notes%20Data%20Migration&subtitle=Before%20opening%20IBM%20Notes%20for%20the%20first%20time,%20please%20drag%20into%20the%20'IBM%20Notes%20Data'%20folder%20the%20following%20documents:%20%5Cn%20%5Cn1)%20ID%20file:%20eg%20shortname.id%20%20%20%20%20%20%20%20%20%3C--%20%20%20%20%20%20%20%20Definitely%20%5Cn2)%20desktop*.ndk%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C--%20%20%20%20%20%20%20%20If%20you%20have%20it%20%5Cn3)%20names.nsf%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C--%20%20%20%20%20%20%20%20If%20you%20have%20it%20%5Cn4)%20bookmark.nsf%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C--%20%20%20%20%20%20%20%20If%20you%20have%20it%20%5Cn5)%20user.dic%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C--%20%20%20%20%20%20%20%20If%20you%20have%20it%20%5Cn6)%20Archive%20folder%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C--%20%20%20%20%20%20%20%20If%20you%20have%20it%20%5Cn7)%20*.nsf%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%20%3C--%20%20%20%20%20%20%20%20If%20you%20have%20it&accessory_view_type=timer&accessory_view_payload=300&main_button_label=Close&secondary_button_label=Open%20Notes&secondary_button_cta_type=link&secondary_button_cta_payload=/Applications/IBM%20Notes.app")!,
        URL(string: "macatibm:shownotification?type=popup&title=FileVault%20is%20Disabled&subtitle=Your%20computer%20is%20not%20ITCS300%20compliant.%20We%20will%20neet%20to%20restart%20your%20computer%20to%20enable%20encryption.%20%5CnWould%20you%20like%20to%20restart%20now?&main_button_label=Yes&main_button_cta_type=none&main_button_cta_payload=User%20Selected%20Yes&secondary_button_label=No&secondary_button_cta_type=none&secondary_button_cta_payload=User%20Selected%20No")!,
        URL(string: "macatibm:shownotification?type=popup&title=Your%20Mac%20is%20now%20secure%20and%20configured%20to%20IBM's%20ITCS300&subtitle=Do%20you%20want%20the%20Mac@IBM%20App%20Store%20to%20automatically%20install%20the%20most%20commonly%20used%20software%20programs?%20This%20will%20install%20applications%20such%20as%20Sametime,%20VPN%20Client,%20Firefox%20ESR,%20and%20Crashplan%20Enterprise%20Backup.&main_button_label=Yes&main_button_cta_type=none&main_button_cta_payload=User%20Selected%20Yes&secondary_button_label=No&secondary_button_cta_type=none&secondary_button_cta_payload=User%20Selected%20No")!,
        URL(string: "macatibm:shownotification?type=popup&accessory_view_type=whitebox&accessory_view_payload=Before%20you%20download%20CrashPlan%20Client,%20please%20read%20the%20following%20IBM%20requirements%20and%20ensure%20that%20you%20comply%20with%20them.%20If%20you%20are%20unable%20to%20comply%20with%20these%20requirements,%20do%20not%20install%20this%20software.%20%5Cn%20%5CnImportant%20Notice%20to%20All%20Users%20%5Cn%20%5CnCrashPlan%20is%20a%20data%20back-up%20solution%20from%20IBM's%20supplier,%20Code42,%20the%20use%20of%20which%20is%20optional.%20%5Cn%20%5CnData%20that%20is%20selected%20by%20users%20to%20be%20backed%20up%20in%20CrashPlan%20is%20encrypted.%20As%20the%20encryption%20keys%20reside%20solely%20with%20IBM%20in%20the%20United%20States,%20Code%2042%20cannot%20access%20the%20backed-up%20data.%20Data%20of%20users%20located%20in%20the%20Americas%20will%20be%20backed-up%20in%20the%20United%20States;%20data%20of%20users%20located%20in%20the%20EU/EEA%20will%20be%20backed%20up%20in%20The%20Netherlands;%20data%20of%20users%20located%20in%20Asia/Pacific%20will%20be%20backed%20up%20in%20Australia.%20%5Cn%20%5CnIf%20your%20system%20contains%20data%20that%20is%20prohibited%20from%20being%20stored%20in%20a%20given%20location%20or%20in%20any%20foreign%20country,%20consider%20whether%20backing%20up%20such%20data%20to%20CrashPlan%20would%20put%20IBM%20in%20breach%20of%20these%20requirements.%20If%20so,%20or%20if%20you%20are%20unsure,%20do%20not%20back%20up%20this%20data%20to%20Crashplan%20and%20instead%20exclude%20this%20data%20from%20your%20backup%20selection.%20You%20may%20find%20further%20instructions%20as%20to%20how%20to%20prevent%20certain%20data%20from%20being%20backed-up%20at%20https://ibm.biz/crashplan_change_selection.%20%5Cn%20%5CnInformation%20about%20alternative%20back-up%20solutions%20for%20such%20data%20can%20be%20found%20at%20https://ibm.biz/ibm_backup_guidelines.%20Any%20related%20questions%20should%20be%20directed%20to%20crashpl@us.ibm.com.%20%5Cn%20%5CnNote%20that%20IBM%20Employee%20Information%20(EI)%20can%20be%20backed%20up%20in%20CrashPlan.%20Additional%20guidance%20on%20PI/SPI%20can%20be%20found%20at%20https://w3.the.ibm.com/mac/%23/support/crashplan_backup/overview.%20%5Cn%20%5CnBy%20pushing%20the%20button%20above%20you%20agree%20to%20the%20processing%20of%20your%20back-up%20data%20as%20described%20above.&main_button_label=Agree&main_button_cta_type=none&main_button_cta_payload=User%20Agreeded&secondary_button_label=Exit&secondary_button_cta_type=none&secondary_button_cta_payload=Button%20Exit%20was%20pushed")!,
        URL(string: "macatibm:shownotification?type=popup&subtitle=Mac@IBM%20will%20begin%20to%20configure%20your%20system")!,
        URL(string: "macatibm:shownotification?type=popup&subtitle=The%20application%20Bluepages%20is%20currently%20running.%20Click%20Continue%20to%20try%20auto%20closing%20(otherwise%20Quit%20by%20hand)&main_button_label=Continue&main_button_cta_type=none&main_button_cta_payload=App%20%20is%20not%20running&secondary_button_label=Cancel")!,
        // Notifications
        URL(string: "macatibm:shownotification?type=banner&title=IBM%20Policy%20Engine&subtitle=Removing%20cached%20IBM%20preferred%20networks...")!,
        URL(string: "macatibm:shownotification?type=banner&title=New%20Updates%20Available&subtitle=Please%20open%20the%20Mac@IBM%20App%20Store&main_button_label=Open&main_button_cta_type=link&main_button_cta_payload=/Applications/Mac@IBM%20App%20Store.app&secondary_button_label=Close")!
    ]

    /// Use this urls to test the app from the mac terminal.
    static let correctURLsForTerminal: [URL] = [
        // Popups
        URL(string: "macatibm:shownotification?type=popup&subtitle=Here is a list of the software that was installed by Mac@IBM. All items in this list will be removed. You will need to contact the helpline and request an exemption if you need to keep any of the applications. Clicking Remove will unistall all checked applications.&accessory_view_type=whitebox&accessory_view_payload=VPN \nIBM WIFI \nNotes \nFireFox \nSlack \nICLA \nFileZilla&main_button_label=Remove&main_button_cta_type=none&main_button_cta_payload=User Selected Remove&secondary_button_label=Cancel&secondary_button_cta_type=none&secondary_button_cta_payload=User Selected Cancel")!,
        URL(string: "macatibm:shownotification?type=popup&title=IBM Notes Data Migration&subtitle=Before opening IBM Notes for the first time, please drag into the 'IBM Notes Data' folder the following documents: \n \n1) ID file: eg shortname.id         <--        Definitely \n2) desktop*.ndk                         <--        If you have it \n3) names.nsf                             <--        If you have it \n4) bookmark.nsf                         <--        If you have it \n5) user.dic                    <--        If you have it \n6) Archive folder                 <--        If you have it \n7) *.nsf                         <--        If you have it&accessory_view_type=timer&accessory_view_payload=300&main_button_label=Close&secondary_button_label=Open Notes&secondary_button_cta_type=link&secondary_button_cta_payload=/Applications/IBM Notes.app")!,
        URL(string: "macatibm:shownotification?type=popup&title=FileVault is Disabled&subtitle=Your computer is not ITCS300 compliant. We will neet to restart your computer to enable encryption. \nWould you like to restart now?&main_button_label=Yes&main_button_cta_type=none&main_button_cta_payload=User Selected Yes&secondary_button_label=No&secondary_button_cta_type=none&secondary_button_cta_payload=User Selected No")!,
        URL(string: "macatibm:shownotification?type=popup&title=Your Mac is now secure and configured to IBM's ITCS300&subtitle=Do you want the Mac@IBM App Store to automatically install the most commonly used software programs? This will install applications such as Sametime, VPN Client, Firefox ESR, and Crashplan Enterprise Backup.&main_button_label=Yes&main_button_cta_type=none&main_button_cta_payload=User Selected Yes&secondary_button_label=No&secondary_button_cta_type=none&secondary_button_cta_payload=User Selected No")!,
        URL(string: "macatibm:shownotification?type=popup&accessory_view_type=whitebox&accessory_view_payload=Before you download CrashPlan Client, please read the following IBM requirements and ensure that you comply with them. If you are unable to comply with these requirements, do not install this software. \n \nImportant Notice to All Users \n \nCrashPlan is a data back-up solution from IBM's supplier, Code42, the use of which is optional. \n \nData that is selected by users to be backed up in CrashPlan is encrypted. As the encryption keys reside solely with IBM in the United States, Code 42 cannot access the backed-up data. Data of users located in the Americas will be backed-up in the United States; data of users located in the EU/EEA will be backed up in The Netherlands; data of users located in Asia/Pacific will be backed up in Australia. \n \nIf your system contains data that is prohibited from being stored in a given location or in any foreign country, consider whether backing up such data to CrashPlan would put IBM in breach of these requirements. If so, or if you are unsure, do not back up this data to Crashplan and instead exclude this data from your backup selection. You may find further instructions as to how to prevent certain data from being backed-up at https://ibm.biz/crashplan_change_selection. \n \nInformation about alternative back-up solutions for such data can be found at https://ibm.biz/ibm_backup_guidelines. Any related questions should be directed to crashpl@us.ibm.com. \n \nNote that IBM Employee Information (EI) can be backed up in CrashPlan. Additional guidance on PI/SPI can be found at https://w3.the.ibm.com/mac/#/support/crashplan_backup/overview. \n \nBy pushing the button above you agree to the processing of your back-up data as described above.&main_button_label=Agree&main_button_cta_type=none&main_button_cta_payload=User Agreeded&secondary_button_label=Exit&secondary_button_cta_type=none&secondary_button_cta_payload=Button Exit was pushed")!,
        URL(string: "macatibm:shownotification?type=popup&subtitle=Mac@IBM will begin to configure your system")!,
        URL(string: "macatibm:shownotification?type=popup&subtitle=The application Bluepages is currently running. Click Continue to try auto closing (otherwise Quit by hand)&main_button_label=Continue&main_button_cta_type=none&main_button_cta_payload=App $appName is not running&secondary_button_label=Cancel")!,
        // Notifications
        URL(string: "macatibm:shownotification?type=banner&title=IBM Policy Engine&subtitle=Removing cached IBM preferred networks...")!,
        URL(string: "macatibm:shownotification?type=banner&title=New Updates Available&subtitle=Please open the Mac@IBM App Store&main_button_label=Open&main_button_cta_type=link&main_button_cta_payload=/Applications/Mac@IBM App Store.app&secondary_button_label=Close")!
    ]

    static let faultyURLs: [URL] = [
        URL(string: "macatibm:shownotification?type=popup")!,
        URL(string: "macatibm:shownotification?type=banner")!,
        URL(string: "macatibm:shownotification")!
    ]
}
