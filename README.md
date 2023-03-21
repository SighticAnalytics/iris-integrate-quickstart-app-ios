# QuickStart app for the Sightic Analytics iOS SDK<!-- omit from toc -->

The purpose of this app is to show developers how to integrate the [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) in their project.

## Contents<!-- omit from toc -->

- [SDK Overview](#sdk-overview)
- [SDK Requirements](#sdk-requirements)
- [SDK API key](#sdk-api-key)
- [How to use the SDK in your app](#how-to-use-the-sdk-in-your-app)
  - [Add Swift package](#add-swift-package)
  - [Camera usage description](#camera-usage-description)
  - [Add the SighticInferenceView](#add-the-sighticinferenceview)
  - [SighticInferenceView shows instruction screens](#sighticinferenceview-shows-instruction-screens)
  - [SighticInferenceView shows alignment screen](#sighticinferenceview-shows-alignment-screen)
  - [SighticInferenceView shows test screen](#sighticinferenceview-shows-test-screen)
  - [App receives a SighticInferenceRecordingResult in completion handler from SighticInferenceView](#app-receives-a-sighticinferencerecordingresult-in-completion-handler-from-sighticinferenceview)
  - [App makes a performInference request on the SighticInferenceRecording](#app-makes-a-performinference-request-on-the-sighticinferencerecording)
  - [App optionally sends feedback to Sightic Analytics regarding result](#app-optionally-sends-feedback-to-sightic-analytics-regarding-result)
- [How to use SighticStatus provided by the SDK](#how-to-use-sighticstatus-provided-by-the-sdk)
- [How to optionally let app users try out the test without sending it for analysis](#how-to-optionally-let-app-users-try-out-the-test-without-sending-it-for-analysis)
- [Translations using custom strings](#translations-using-custom-strings)
  - [Providing strings to the SDK](#providing-strings-to-the-sdk)
- [How to check if my device is supported](#how-to-check-if-my-device-is-supported)
- [App overview](#app-overview)
- [SDK API key in the QuickStart apps](#sdk-api-key-in-the-quickstart-apps)
- [Configure signing](#configure-signing)
- [Run app](#run-app)
- [App flow](#app-flow)
  - [StartView](#startview)
  - [TestView](#testview)
  - [WaitingView](#waitingview)
  - [ResultView](#resultview)
  - [ErrorView](#errorview)
  - [FeedbackView](#feedbackview)
- [Add SDK as xcframework instead of Swift Package](#add-sdk-as-xcframework-instead-of-swift-package)
- [How to update table of contents for this README](#how-to-update-table-of-contents-for-this-readme)

## SDK Overview

The SDK provides a view named `SighticInferenceView` that you must add to your app. The SDK goes through the following phases:
1. **Instruction screens**<br>The instruction screens shows the app user how to perform the test. The instruction screens can be disabled through a parameter to the `SighticInferenceView` init method.
2. **Alignment screen**<br>The purpose of the alignment view is to make sure the face of the app user is positioned correctly in front of the screen. `SighticInferenceView` presents an alignment view with a face mesh to provide the app user with visual clues on how to position their device and face. The app can subscribe to alignment status updates from the SDK by providing a closure. The app should use the alignment status updates to show hints and a countdown as overlays on the `SighticInferenceView`. The QuickStart app shows an example of how to do this.
3. **Test screen**<br>A green moving dot is presented to the app user during the test phase. The app user must follow the dot with their eyes.
4. **Recording object**<br>The `SighticInferenceView` provides the app with the recorded data. The app sends the recorded data to the Sightic Analytics server for analysis. The data sent to server contains features extracted from the face of the app user. The data does not contain a video stream that can be used to identify the user.
5. **Result object**<br>The app will receive a boolean value back from the Sightic Analytics server that contains the result of the analysis.
6. **Feedback**<br>The app can optionally collect feedback from the user whether they deem the result correct and send this information to Sightic Analytics. The information is used by Sightic Analytics to improve our model.

![SDK phases](images/sdk-overview-phases.png)

## SDK Requirements

* Platforms
  * iOS 15 or later
  * iPhone 12 or later including iPhone SE 2020 and later
* Programming languages
  * Swift 5
  * No Objective-C support
* Package managers
  * [Swift Package Manager](https://www.swift.org/package-manager/)
  * No CocoaPods support
  * No Carthage support

## SDK API key

The SDK requires an API key in order to provide the app with a result. Please get in touch with [Sightic Analytics](https://www.sighticanalytics.com/contact) to retrieve a key.

## How to use the SDK in your app

### Add Swift package

Add `SighticAnalytics` as a Swift package to your app using the URL https://github.com/SighticAnalytics/sightic-sdk-ios.

You can also [add the SDK as a xcframework](https://github.com/SighticAnalytics/sightic-sdk-quickstart-app-ios#add-sdk-as-xcframework-instead-of-swift-package).

### Camera usage description

The SDK needs access to the device's camera, thus you must add a [camera usage description](https://developer.apple.com/documentation/bundleresources/information_property_list/nscamerausagedescription) to your app in the [Info.plist](https://developer.apple.com/documentation/bundleresources/information_property_list/managing_your_app_s_information_property_list).

Another option is to set the camera usage description in your build settings if you have enabled automatic generation of an Info.plist file ([GENERATE_INFOPLIST_FILE](https://developer.apple.com/documentation/xcode/build-settings-reference)).

![Camera usage description in Xcode](images/xcode-camera-usage-description.png)

![Automatically Generate Info plist in Xcode](images/xcode-generate-info-plist.png)

### Add the SighticInferenceView

1. Add the SwiftUI view `SighticInferenceView` somewhere in your app. You must let the view occupy the **whole** screen.
2. The app shall provide `SighticInferenceView` with:
   * An API key
   * A bool named `showInstructions` stating whether to show instructions the app user.
   * A bool named `includeFakeTest` stating whether to show a circling dot before the real test sequence starts. The purpose is to make the app user aware that the test has started and that they should start following the moving green dot with their eyes. This part of the test is not recorded. One possibility is to only set this flag to `true` for app users doing the test for the first time. The test sequence is prolonged with approximately two seconds when this flag is set to `true`.
   * A closure to receive `SighticStatus` updates. The updates should be used by the app to add alignment hints as overlays on the alignment screen as shown below.
   * A completion handler of type `(SighticInferenceRecordingResult) -> ()`.

### SighticInferenceView shows instruction screens

The instruction screens provided by the SDK show the app user how to perform the test. You can disable those views using a parameter to the init method of `SighticInferenceView` and create instructions with your own design instead. The animated icons can be accessed separately by adding the view `SighticInstructionView` (SwiftUI only) to your own instruction view. The different kinds of instructions are described in the enum `SighticInstruction`.

You can customize the colors of the image, by setting the `faceOutlineColor` and `annotationsColor` properties. The following example uses green with 50% opacity for the outline, and yellow for annotations.

```swift
SighticInstructionView(
   instruction: .holdPhoneInFrontOfFace,
   faceOutlineColor: .green.opacity(0.5),
   annotationsColor: .yellow
)
```

![Example showing custom instruction view colors](images/instruction_view_custom_colors.jpg)

Please include the following information when informing the app user about the test:

* Tell the app user to hold their phone straight in front of their face
* Tell the app user to follow the green dot with their eyes during the test
* Tell the app user to hold the phone still during the test
* Tell the app user to avoid talking during the test
* Tell the app user to keep their eyes open during the test

The images below show what the instruction views provided by the SDK look like.

![Instruction phase - Hold phone straight](images/instruction-view-hold-phone-straight.png)

![Instruction phase - Do not talk](images/instruction-view-do-not-talk.png)

![Instruction phase - Follow the dot](images/instruction-view-follow-dot.png)

### SighticInferenceView shows alignment screen

The alignment screen helps the app user position their face in front of the screen. The face mesh will become green when the SDK deems the app user face to be in the correct position.

The app shall add alignment hints and a countdown as overlays on the alignment screen using the `SighticStatus` callback. The QuickStart app code shows an example of how this can be done:
* See `AlignmentHintViewController` for the UIKit variant.
* See `AlignmentHintView` for the SwiftUI variant.

![Alignment phase - Place face in mask](images/alignment-view-place-face-in-mask.png)
![Alignment phase - Hold phone closer](images/alignment-view-hold-phone-closer.png)
![Alignment phase - Countdown](images/alignment-view-countdown.png)

### SighticInferenceView shows test screen

A green moving dot is presented during the test phase. The app user is supposed to follow the dot with their eyes and keep the phone still. The SDK records the face of the user during the test phase.

![Test phase](images/test-view.png)

### App receives a SighticInferenceRecordingResult in completion handler from SighticInferenceView

1. The `SighticInferenceView` triggers the completion handler back to the app to indicate that the recording has finished.
2. The app receives a `SighticInferenceRecordingResult` object through the callback.
3. `SighticInferenceRecordingResult` is a result type that is either a success containing `SighticInferenceRecording` or a failure containing a `SighticError`.

### App makes a performInference request on the SighticInferenceRecording

1. `SighticInferenceRecording` implements a function named `performInference(allowToSave: Bool)`.
2. The app shall call the `performInference` method to send the recorded data to the `Sightic Analytics` server for analysis.
3. By setting the parameter `allowToSave` to `true`, you can give the server permission to save the inference input data. This can then be used to improve the application. Most importantly, the inference input data is anonymized and does not contain any personal information, nor can it be used to identify a real person, or the device that was used to collect the data.
4. `performInference` is an async function and will return a `SighticInferenceResult` object when done.
5. `SighticInferenceResult` is a result type that contains either a `SighticInference` or a `SighticError`.
6. The `SighticInference` object contains a `bool` property named `hasImpairment` that can be used by the app to present the result.

![Call graph - perform inference](images/call-graph-perform-inference.png)

### App optionally sends feedback to Sightic Analytics regarding result

1. `SighticInference` implements a function named `sendFeedback`.
2. The app can optionally call `sendFeedback` to provide `Sightic Analytics` with feedback regarding the inference result.

## How to use SighticStatus provided by the SDK

The SDK provides `SighticStatus` information to make it possible for the app to create its own alignment screen. `SighticStatus` is an enum that contains `SighticAlignmentStatus`. It also shows when countdown is ongoing and when the test itself has started. The app must remove its alignment overlay when the test starts.

## How to optionally let app users try out the test without sending it for analysis

You can let your app users try out the Sightic Analytics test without sending the recording for analysis to the Sightic backend. One possibility is to let new app users do this. To make them familiar with how the test works.

Follow the instructions in section [How to use the SDK in your app](#how-to-use-the-sdk-in-your-app) but skip the steps starting from section [App makes a performInference request on the SighticInferenceRecording](#app-makes-a-performinference-request-on-the-sighticinferencerecording) to do this.

## Translations using custom strings

A number of user-visible strings can be customized by the host application, by implementing the protocol `SighticStrings` and provide it to the `SighticInferenceView`. This could for example be used to add support for more languages. The host application is then expected to return a non-nil string for each property defined by the protocol. The protocol is documented with a brief comment of what the string is supposed to say.

If a `nil` value is returned, the SDK will fall back to a default value based on the current language setting. For this to work properly it is important that the returned value is `nil`, and not any other default value.

To add custom strings, do the following:

* Create a new type that implements `protocol SighticStrings` (a struct for example).
* Return a custom string for each property.
* Assign an instance to the static property `SighticAnalytics.Strings.customStrings` somewhere in your app's initialization phase.

For example:

```swift
struct MyStrings: SighticStrings {
    
    var alignHoldCloser: String? {
        let str = NSLocalizedString("sightic-align-hold-closer", comment: "")
        return str != "sightic-align-hold-closer" ? str : nil // nil if not found
    }
    
    // ... repeat for every property ...
}
```

### Providing strings to the SDK

```swift
@main
struct MyApp: App {
    init() {
        SighticAnalytics.Strings.customStrings = MyStrings()
    }
    
    var body: some Scene {
      WindowGroup {
        ContentView()
      }
    }
```

## How to check if my device is supported

This code sample checks if the current device is supported, through a backend call.

```swift
do {
    guard try await SighticSupportedDevices().isCurrentSupported else {
      // Handle the case where the current phone model is not supported
    }

    // Continue with test
}
catch {
    print("Error while checking for supprted devices: \(error)")
}
```

## App overview

* There is one QuickStart app variant for UIKit based apps in the folder `SighticQuickstartUIKit`.
* There is one QuickStart app variant for SwiftUI based apps in the folder `SighticQuickstartSwiftUI`.
* The deployment target is set to iOS 15 for both the SwiftUI and the UIKit variants.
* Both variants add [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) as a Swift Package.

## SDK API key in the QuickStart apps

You must provide an API key to the SDK in order to run the QuickStart apps successfully:
* `SighticQuickstartUIKit`: Add the API key to the `AppDelegate.swift`.
* `SighticQuickstartSwiftUI`: Add the API key to `SighticQuickstartSwiftUIApp.swift`.

## Configure signing

The steps below use names from the SwiftUI variant.

1. Open `SighticQuickstartSwiftUI/SighticQuickstartSwiftUI.xcodeproj` with Xcode.
2. Navigate to the Signing and Capabilities pane for the `SighticQuickstartSwiftUI` target.
3. Change _team_ to your team.
4. Change _Bundle identifier_ to something unique.
5. Check _Automatically manage signing_.

## Run app

1. Select the _SighticQuickstartSwiftUI_ or _SighticQuickstartUIKit_ scheme in Xcode depending on what variant you are running.
2. Select a Simulator or Device as destination. Please observe that the test can only be run on a device.
3. Run `⌘R` the app.

## App flow

The SwiftUI and UIKit Quickstart variants have similar flow. The screenshots below are from the SwiftUI variant.

### StartView

The `StartView` contains a button to go to the `TestView`. It also allows you to configure the `SighticInferenceView`:

* Whether to show the instruction screens
* Whether to allow the server to save the recording from the test. The data sent to server contains features extracted from the face of the app user. The data does not contain a video stream that can be used to identify the user.

![Start view](images/start-view.png)

### TestView

The `TestView` is a container for the `SighticInferenceView`. The `SighticInferenceView` is part of [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) and performs the following phases:

1. Shows an instruction view to the user.<br>
   ![Instruction view](images/instruction-view-hold-phone-straight.png)
2. Shows alignment view to help the user position the phone and their head correctly. The QuickStart app overlays the default alignment screen with alignment hints and a countdown using information in the `SighticStatus` closure.<br>
   ![Test in progress view - Positioning camera](images/alignment-view-hold-phone-closer.png)
3. A dot is shown to the user while the test itself is running. The user is supposed to follow the dot with their eyes.<br>
  ![Test in progress view - Moving dot](images/test-view.png)

The `SighticInferenceView` triggers a callback to the app to indicate that the recording has finished. The app receives a `SighticInferenceRecordingResult` object through the callback. `SighticInferenceRecordingResult` is a result type that is either a success containing `SighticInferenceRecording` or a failure containing a `SighticError`. `SighticInferenceRecording` implements a function named `performInference`. The app shall call the `performInference` method to send the recorded data to the Sightic Analytics server for analysis. The data sent to server contains features extracted from the face of the app user. The data does not contain a video stream that can be used to identify the user.

### WaitingView

The analysis by the Sightic server may take a couple of seconds. The QuickStart app shows `WaitingView` to inform the app user about the status.

![Waiting for analysis view](images/waiting-view.png)

### ResultView

The `performInference` is an async function and will return a `SighticInferenceResult` object when done. `SighticInferenceResult` is a result type that contains either a `SighticInference` or a `SighticError`. The `SighticInference` object contains a `bool` property named `hasImpairment` that can be used by the app to present the result. The QuickStart app shows the raw value of `hasImpairment`.

![Result view](images/result-view.png)

### ErrorView

An error view is shown if something goes wrong when doing the test. The test is aborted and an error is shown.

![Error view](images/error-view.png)

### FeedbackView

A feedback view is shown to give the app user the possibility to provide feedback on the inference result. The user can provide a boolean value whether they agree with the result and also provide free text feedback.

![Feedback view](images/feedback-view.png)

## Add SDK as xcframework instead of Swift Package

You can add the [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) as a xcframework to your app instead of as a Swift Package:

1. Remove `SighticAnalytics` Swift Package on the _Package Dependencies_ pane of the _SighticQuickstart_ project.
   ![Remove Swift Package](images/7-xcframework-quickstart-remove-swift-package.png)
2. Goto https://github.com/SighticAnalytics/sightic-sdk-ios/releases
3. Scroll to the release you would like to use.
4. Download the file `SighticAnalytics.xcframework.zip`.<br>
   ![Download zip file](images/8-xcframework-quickstart-app-download-xcframework-zip.png)
5. Unpack the zip file<br>
   ![Unpack zip file](images/9-xcframework-quickstart-app-unpack-xcframeowrk-zip.png)
6. Drag `SighticAnalytics.xcframework` into your app project in Xcode.<br>
   ![Copy xcframework to Xcode project](images/10-xcframework-quickstart-app-drag-xcframework-to-app.png)
7. Add `SighticAnalytics` as a framework in the General pane of the `SighticQuickstartUIKit` target.<br>
   ![Add xcframework as Framework in Xcode](images/11-xcframework-quickstart-app-add-xcframework-as-dependency.png)

## How to update table of contents for this README

The extension [Markdown All in One](https://marketplace.visualstudio.com/items?itemName=yzhang.markdown-all-in-one) for [VSCode](https://code.visualstudio.com/) can [generate a table of contents](https://github.com/yzhang-gh/vscode-markdown#table-of-contents).