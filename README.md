# IRIS integrate QuickStart app<!-- omit from toc -->

The IRIS integrate QuickStart app is intended to show developers how to integrate the [IRIS integrate iOS framework](https://github.com/SighticAnalytics/iris-integrate-ios).

## Contents<!-- omit from toc -->

- [Overview](#overview)
- [IRIS integrate documentation](#iris-integrate-documentation)
- [API key](#api-key)
- [App signing](#app-signing)
- [Run app](#run-app)
- [App flow](#app-flow)
  - [StartView](#startview)
  - [ScanView](#scanview)
  - [InferenceView](#inferenceview)
  - [ResultView](#resultview)
  - [FeedbackView](#feedbackview)
  - [ErrorView](#errorview)

## Overview

* The QuickStart app is written in Swift/SwiftUI.
* It adds the [IRIS integrate iOS framework](https://github.com/SighticAnalytics/iris-integrate-ios) as a Swift Package Manager dependency.

## IRIS integrate documentation

* IRIS integrate documentation is [available here](https://sighticanalytics.github.io/iris-integrate-ios/documentation/irisintegrate/).

## API key

* The IRIS integrate framework requires an API key.
* Add your API key in the `@main` entry point in `IRISintegrateQuickstart.swift`.

## App signing

1. Open `IRISintegrateQuickstart.xcodeproj` in Xcode.
2. Navigate to the Signing and Capabilities tab for the `IRISintegrateQuickstart` target.
3. Change _team_ to your team.
4. Change _Bundle identifier_ to something unique.
5. Check _Automatically manage signing_.

## Run app

1. Open `IRISintegrateQuickstart.xcodeproj` in Xcode.
2. Select a device as destination. Please note that IRIS integrate does not run on an iOS Simulator.
3. Run `⌘R` the app.

## App flow

The following sections describe the [IRIS integrate user interface flow](https://sighticanalytics.github.io/iris-integrate-ios/documentation/irisintegrate/phases/) as implemented by the QuickStart app.

### StartView

`StartView` contains a button to go to the `ScanView`. It also allows you to configure properties passed into `SighticView` in `ScanView`:

* Whether to show the instructions.
* Whether to allow the server to save data from the scan. The data sent to server contains facial features of the app user. It does not contain a video that can identify the user.

![StartView](images/startview.png)

### ScanView

`ScanView` is a container for `SighticView`. `SighticView` is part of the [IRIS integrate iOS framework](https://github.com/SighticAnalytics/iris-integrate-ios) and goes through the following phases:

1. Alignment: A view that helps the user achieve the correct positioning of their phone and head.<br>
   ![ScanView - Alignment](images/scanview-alignment.png)
2. Scan: A view that displays an animated dot that the user should follow with their eyes.<br>
  ![ScanView - Scan](images/scanview-scan.png)

When the scan has finished `SighticView` calls the completion handler with a [`Result`]([https:://todo](https://developer.apple.com/documentation/swift/result)) value containing either `SighticRecording` or `SighticRecordingError`. These are passed to `InferenceView` and `ErrorView` respectively.

```swift
SighticView( ... ) { result in
    switch result {
    case .success(let recording):
        // Use recording.performInference() to send the recording for analysis
    case .failure(let error):
        // Use error to present that something went wrong
    }
}
```

### InferenceView

`InferenceView` takes a `SighticRecording` and sends it for analysis to the Sightic backend. Again, a `Result` value is returned, this time containing either `SighticInference` or `SighticError`. These are passed on to `ResultView` and `ErrorView` respectively.

```swift
let recording: SighticRecording

switch await recording.performInference( ... ) {
case .success(let inference):
    // Use inference to present scan results
case .failure(let error):
    // Use error to present that something went wrong
}
```

![InferenceView](images/inferenceview.png)

### ResultView

`ResultView` displays the result contained in `SighticInference`. It optionally allows the user to open `FeedbackView` or return to `StartView`

The SighticInference value contains the inference result in the `hasImpairment: Bool` property.

```swift
let inference: SighticInference

Text(inference.hasImpairment
    ? "The scan result is positive."
    : "The scan result is negative."
)
```

SighticInference also contains `hasAlcoholImpairment: Bool` and `hasCannabisImpairment: Bool?`. `hasCannabisImpairment` is `nil` if the API key does not support cannabis detection.

![ResultView](images/resultview.png)

### FeedbackView

The `SighticInference` value also contains a `sendFeedback` function for sending feedback on the inference result to Sightic Analytics. This view is presented if the user opted to send feedback in `ResultView`.

```swift
let inference: SighticInference

do {
    try await inference.sendFeedback(
        isAgreeing ? .agree : .disagree,
        comment: comment
    )
    // Feedback was sent successfully
} catch {
    // Failed to send feedback
}
```

I

![FeedbackView](images/feedbackview.png)

### ErrorView

This view is presented if an error occured during the scan or when performing inference.

![ErrorView](images/errorview.png)

> Note: While charging the phone may get too hot to perform the scan. This can often be the case while developing since you will usually have a cable connected for testing and debugging. In the field this is a very rare occurence.
