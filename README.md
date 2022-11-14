# QuickStart app for the Sightic Analytics iOS SDK

The purpose of this app is to show developers how to integrate the [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) in their project.

## App overview

* There is one QuickStart app variant for UIKit based apps in the folder `SighticQuickstartUIKit`.
* There is one QuickStart app variant for SwiftUI based apps in the folder `SighticQuickstartSwiftUI`.
* The deployment target is set to iOS 15 for both the SwiftUI and the UIKit variants.
* Both variants adds [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) as a Swift Package.

## App flow

The SwiftUI and UIKit Quickstart variants have similar flow. The screenshots below are from the UIKit variant.

### StartViewController

The `StartViewController` contains a button to go to the `TestViewController`.

![Start view](images/1-quickstart-app-start-view.jpeg)

### TestViewController

The `TestViewController` is a container for the `SighticInferenceView`. The `SighticInferenceView` is part of [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) and performs the following steps:
1. Shows an instruction view to the user.<br>
   ![Instruction view](images/2-quickstart-app-instruction-view.jpeg)
1. The next step is to help the user position the phone and their head correctly.<br>
   ![Test in progress view - Positioning camera](images/3-quickstart-app-test-in-progress-a.jpeg)
1. A dot is shown to the user while the test itself is running. The user is supposed to follow the dot with their eyes.<br>
  ![Test in progress view - Moving dot](images/4-quickstart-app-test-in-progress-b.jpeg)

The `SighticInferenceView` triggers a callback to the app to indicate that the recording has finished. The app receives a `SighticRecordingResult` object through the callback. `SighticRecordingResult` is a result type that contains either a `SighticRecording` or a `SighticError`. `SighticRecording` implements a function named `performInference`. The app shall call the `performInference` method to send the recorded data to the `Sightic` server for analysis.

### WaitingViewController

The analysis by the Sightic server may take a couple of seconds. The QuickStart app shows `WaitingViewController` to inform the app user about the status.

![Waiting for analysis view](images/5-quickstart-app-waiting-for-analsysis.jpeg)

### ResultViewController

The `performInference` is an async function and will return a `SighticInferenceResult` object when done. `SighticInferenceResult` is a result type that contains either a `SighticInference` or a `SighticError`. The `SighticInference` object contains a `bool` property named `hasImpairment` and an `Int` property named `confidence` betwen 0 to 100 that can be used by the app to present the result. The QuickStart app shows the raw value of `hasImpairment` and `confidence`.

![Result view](images/6-quickstart-app-result-view.jpeg)

## Configure signing

The steps below use names from the SwiftUI variant.

1. Open `SighticQuickstartSwiftUI/SighticQuickstartSwiftUI.xcodeproj` with Xcode.
1. Navigate to the Signing and Capabilites pane for the `SighticQuickstartSwiftUI` target.
1. Change _team_ to your team.
1. Change _Bundle identifier_ to something unique.
1. Check _Automatically manage signing_.

## Run

1. Select the _SighticQuickstartSwiftUI_ or _SighticQuickstartUIKit_ scheme in Xcode depending on what variant you are running.
1. Select a Simulator or Device as destination. Please observe that the test can only be run on a device. A replacement view will be instead of the test by the SDK when running on a simulator so that the flow of the app can be tested.
1. Run `⌘R` the app.

## Add SDK as xcframework instead of Swift Package

You can add the [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) as a xcframework to your app instead of as a Swift Package:

1. Remove `SighticAnalytics` Swift Package on the _Package Denedencies_ pane of the the _SighticQuickstart_ project.
   ![Remove Swift Package](images/7-xcframework-quickstart-remove-swift-package.png)
1. Goto https://github.com/SighticAnalytics/sightic-sdk-ios/releases
1. Scroll to the release you would like to use.
1. Download the file `SighticAnalytics.xcframework.zip`.<br>
   ![Download zip file](images/8-xcframework-quickstart-app-download-xcframework-zip.png)
1. Unpack the zip file<br>
   ![Unpack zip file](images/9-xcframework-quickstart-app-unpack-xcframeowrk-zip.png)
1. Drag `SighticAnalytics.xcframework` into your app projext in Xcode.<br>
   ![Copy xcframework to Xcode project](images/10-xcframework-quickstart-app-drag-xcframework-to-app.png)
1. Add `SighticAnalytics` as a framework in the General pane of the `SighticQuickstart` target.<br>
   ![Add xcframework as Framework in Xcode](images/11-xcframework-quickstart-app-add-xcframework-as-dependency.png)