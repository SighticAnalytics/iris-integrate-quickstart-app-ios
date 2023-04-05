# QuickStart apps for the Sightic Analytics iOS SDK<!-- omit from toc -->

The QuickStart apps show developers how to integrate the [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios).

## Contents<!-- omit from toc -->

- [Overview](#overview)
- [SDK documentation](#sdk-documentation)
- [API key](#api-key)
- [App signing](#app-signing)
- [Run app](#run-app)
- [App flow](#app-flow)
  - [StartView](#startview)
  - [TestView](#testview)
  - [WaitingView](#waitingview)
  - [ResultView](#resultview)
  - [ErrorView](#errorview)
  - [FeedbackView](#feedbackview)

## Overview

* There is one QuickStart app for [UIKit](https://developer.apple.com/documentation/uikit) based apps in the folder `SighticQuickstartUIKit`.
* There is one QuickStart app for [SwiftUI](https://developer.apple.com/documentation/swiftui/) based apps in the folder `SighticQuickstartSwiftUI`.
* The deployment target is set to iOS 15.
* The QuickStart apps add [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) as a Swift Package.

## SDK documentation

SDK documentation is available at https://sighticanalytics.github.io/sightic-sdk-ios/documentation/sighticanalytics/. [Add to your app](https://sighticanalytics.github.io/sightic-sdk-ios/documentation/sighticanalytics/addtoapp) shows how to integrate the SDK.

## API key

The SDK requires and API key:
* `SighticQuickstartUIKit`: Add the API key to the `AppDelegate.swift`.
* `SighticQuickstartSwiftUI`: Add the API key to `SighticQuickstartSwiftUIApp.swift`.

## App signing

1. Open `SighticQuickstartSwiftUI/SighticQuickstartSwiftUI.xcodeproj` or `SighticQuickstartUIKit/SighticQuickstartUIKit.xcodeproj` in Xcode.
2. Navigate to the Signing and Capabilities pane for the `SighticQuickstartSwiftUI` or `SighticQuickstartUIKit` target.
3. Change _team_ to your team.
4. Change _Bundle identifier_ to something unique.
5. Check _Automatically manage signing_.

## Run app

1. Select the _SighticQuickstartSwiftUI_ or _SighticQuickstartUIKit_ scheme in Xcode.
2. Select a device as destination. The test cannot be run on a simulator.
3. Run `⌘R` the app.

## App flow

The SwiftUI and UIKit Quickstart apps have similar flow. The screenshots below are from the SwiftUI variant.

### StartView

The `StartView` contains a button to go to the `TestView`. It also allows you to configure `SighticInferenceView`:

* Whether to show the instructions.
* Whether to allow the server to save data from the test. The data sent to server contains facial features of the app user. It does not contain a video that can identify the user.

![Start view](images/start-view.png)

### TestView

The `TestView` is a container for `SighticInferenceView`. `SighticInferenceView` is part of [Sightic Analytics iOS SDK](https://github.com/SighticAnalytics/sightic-sdk-ios) and performs the following phases:

1. Shows instructions.<br>
   ![Instruction view](images/instruction-view-hold-phone-straight.png)
2. Shows alignment view to help the user position the phone and head. The QuickStart app overlays the view with alignment hints and a countdown using information in the `SighticStatus` closure.<br>
   ![Test in progress view - Positioning camera](images/alignment-view-hold-phone-closer.png)
3. A dot is visible while the test itself is running. The user follows the dot with their eyes.<br>
  ![Test in progress view - Moving dot](images/test-view.png)

The `SighticInferenceView` triggers a callback with `SighticInferenceRecordingResult` to the app when the recording has finished. `SighticInferenceRecordingResult` contains `SighticInferenceRecording` or `SighticError`. `SighticInferenceRecording` implements the `performInference` function. Call `performInference` to send anonymized data to the Sightic Analytics server for analysis.

### WaitingView

The analysis by the Sightic server takes a couple of seconds. The QuickStart app shows `WaitingView` to inform the app user about the status.

![Waiting for analysis view](images/waiting-view.png)

### ResultView

`performInference` is an async function and returns `SighticInferenceResult`. `SighticInferenceResult` contains `SighticInference` or `SighticError`. `SighticInference` contains a `bool` named `hasImpairment` with the result. The QuickStart app shows the value of `hasImpairment`.

![Result view](images/result-view.png)

### ErrorView

The test is aborted if something goes wrong.

![Error view](images/error-view.png)

### FeedbackView

The SDK accepts free text and a boolean for user feedback.

![Feedback view](images/feedback-view.png)