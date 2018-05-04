# Agora iOS Tutorial for Swift - 1 to 1

The *Agora iOS Tutorial for Swift - 1 to 1* sample enables you to quickly get started in your development efforts to create an iOS app with real-time video calls, voice calls, and interactive broadcasting. With this sample app you can:

* Start and end audio/visual communication between two users.
* Join a communication channel.
* Mute or unmute audio.
* Enable or disable video.
* Choose between the front or rear camera.

## Prerequisites
- Xcode
- Some knowledge of Swift
- An Agora.io Developer Account

## Quick Start
This section shows you how to prepare, build, and run the sample application.

### Create an Account and Obtain an App ID
In order to build and run the sample application you must obtain an App ID as follows: 

1. Create a developer account at [agora.io](https://www.agora.io/). Once you finish the sign up process, you will be redirected to the Dashboard.
2. Navigate in the Dashboard tree on the left to **Projects** > **Project List**.
3. Locate the *Default Project* and copy the value for **App ID**.

### Obtain and Build the Sample Application 

1. Clone the [Agora iOS Tutorial for Swift - 1 to 1 Sample App for iOS repository](https://github.com/sidsharma27/Agora-iOS-Tutorial-Swift-1to1) from GitHub.
2. Open the project file **Agora iOS Tutorial.xcodeproj** in Xcode.
3. In the Project Navigator, navigate to **Agora iOS Tutorial** > **Agora iOS Tutorial** 
4. Open **VideoCallViewController.swift**.
5. Locate the following line and replace *<#Your App Id#>* with the App ID that you obtained from the Dashboard.

```let AppID: String = <#Your App Id#>                  // Tutorial Step 1```
6. Build and run the project. This should display the application on your iOS device or emulator.

## Creating the App
The following are the main steps that were used to create the sample:

* [Integrating the Agora SDK](#integrating-the-agora-sdk)
* [Setting Permissions for the Camera and Microphone](#setting-permissions-for-the-camera-and-microphone)
* [Preparing the Video Call View Controller](#preparing-the-video-call-view-controller)
* [Preparing the Set Channel View](#preparing-the-set-channel-view)
* [Initializing the Agora SDK](#initializing-the-agora-sdk)
* [Configuring the Video Mode](#configuring-the-video-mode)
* [Joining a Channel](#joining-a-channel)
* [Setting up Local Video](#setting-up-local-video)
* [Adding Delegate Methods](#adding-delegate-methods)
* [Adding Channel Selection](#adding-channel-selection)
* [Hanging Up and Ending the Call](#hanging-up-and-ending-the-call)
* [Muting Audio](#muting-audio)
* [Muting Video](#muting-video)

## Exploring the Project
The following subsections provide more detail about how the sample project was created and the purpose of the code and resources that were added.

For detail about the APIs used to develop this sample, see the [Agora.io Documentation](https://docs.agora.io/en/2.2).

### Integrating the Agora SDK
The sample's Xcode project is a *Single View Application*. 

To integrate the SDK into the project, a pod file was created in the same location as the Xcode project file using the following command in Terminal:

```bash
pod init
```

The new pod file was modified to include the *AgoraRtcEngine_iOS* pod:

```bash
target 'AgoraVideoQuickstart' do
  use_frameworks!
  pod 'AgoraRtcEngine_iOS'
end
```

The modified file was then installed using the following command in Termainal:

```bash
pod install
```

### Setting Permissions for the Camera and Microphone
In the `Info.plist` file, the privacy settings for the camera and microphone were set to **Video Chat** to allow the app to access them:
![Info_Plist.png](/Info_Plist.png)


### Exploring the Art Assets
The following icon assets for the user interface were added to the *Assets.xcassets* folder. These are used for the user interface buttons that the user will interact with:

* **hangUpButton**: an image of a red telephone for a *hang up* button.
* **localVideoMutedBg**: the background image for a video mute button.
* **muteButton**: a picture of a microphone to mute audio.
* **muteButtonSelected**: a picture of a microphone with a cross through it to indicate that the audio is muted.
* **switchCameraButton**: a picture of a camera and rotational arrows to switch between the two cameras.
* **switchCameraButtonSelected**: a highlighted picture of a camera and rotational arrows to indicate that the rear camera is in use.
* **videoMuteButton**: a picture of a camera to mute video.
* **videoMuteButtonSelected**: a picture of a camera highlighted to indicate that video is muted.
* **videoMuteButtonIndicator**: a picture of a camera crossed out to indicate the camera is off.

### Preparing the User Interface
The *Agora iOS Tutorial for Swift - 1 to 1* sample is based around the [model-view-controller](https://en.wikipedia.org/wiki/Model–view–controller) pattern. The *Main.storyboard* file defines the user interface and makes use of two view controllers: *VideoCallViewController.swift* and *SetChannelViewController.swift*.

#### Preparing the Video Call View Controller
*VideoCallViewController.swift* defines a view that handles a video call. Note that its file *VideoCallViewController.swift* was renamed from the default file name *ViewController.swift* to reflect the purpose of the view.

The main aspects of the Video Call View Controller on the storyboard are shown here:
![Storyboard_Setup2.png](/StoryboardSetup.png)

* *View*: a view which handles the main video feed. This view contains other views (described next).
* *remoteVideo* a view showing the remote, incoming video feed (i.e the video that the user will see).
* *remoteVideoMutedIndicator*: a view showing an icon indicating that remote video is muted.
* *localVideo*: a smaller view at the top right corner showing the local video feed.
* *localVideoMutedBg*: a gray background to indicate that local video is muted when the user pauses their video feed.
* *localVideoMutedIndicator* an icon which is overlaid and centered over the `localVideoMutedBg` view to indicate that local video is muted.
* *controlButtons*: a view that encapsulates four buttons: Pause Video, Audio Mute, Switch Camera, and Hang Up. Each button uses the art assets described above.

#### Preparing the Set Channel View
*SetChannelViewController.swift* defines a view that handles channel selection.

The main aspects of the Set Channel View Controller on the storyboard are shown here:
![Storyboard_Setup2.png](/StoryboardSetup2.png)

* A segue (`exitCall`) from `VideoCallViewController` to `SetChannelViewController` is called to end the video call once the user has pressed the *Hang Up* button.
* A text field for the user to input a channel name 
* A button to start the video call.
 
## Adding Agora Functionality
The following subsections describe how the Agora API is used to add Agora functionality to the app.

### Initializing the Agora SDK
The code samples in this section are from *VideoCallViewController.Swift*.

`AgoraRtcEngineKit` is the interface of the Agora API that provides communication functionality. Once imported, a singleton can be created by invoking [sharedEngine](https://docs.agora.io/en/2.2/product/Interactive%20Gaming/API%20Reference/game_ios?platform=iOS) during initialization, passing the application ID and a reference to self as the delegate. The Agora API uses delegates to inform the application about Agora engine runtime events (e.g. joining/leaving a channel, the addition of new participants, etc). 

In the sample project, a helper method called `initializeAgoraEngine()` contains this logic and is invoked by `viewDidLoad()`;


``` swift
import UIKit
import AgoraRtcEngineKit

var agoraKit: AgoraRtcEngineKit!            
let AppID: String = "Your-App-ID"
var channel:String? //Stores the user's desired channel name from (covered later in the tutorial)

func initializeAgoraEngine() {
    agoraKit = AgoraRtcEngineKit.sharedEngine(withAppId: AppID, delegate: self)
}

override func viewDidLoad() {   
    super.viewDidLoad(true);
    initializeAgoraEngine();
    ...
}
```

### Configuring the Video Mode
The next step is to enable video mode, configure the video encoding profile, and specify if the width and height can change when switching from portrait to landscape:

``` swift
func setupVideo() {
    agoraKit.enableVideo()  // Enables video mode.
    agoraKit.setVideoProfile(._VideoProfile_360P, swapWidthAndHeight: false) // Default video profile is 360P
}

override func viewDidLoad() {
    super.viewDidLoad();
    initializeAgoraEngine();
    setupVideo();  
    ...
}
```
In the sample, a helper method called `setupVideo()` contains this logic and is invoked by `viewDidLoad()`. It starts by enabling video with [enableVideo](https://docs.agora.io/en/2.2/product/Video/API%20Reference/communication_ios_video?platform=iOS). The video encoding profile is then set to 360p and the `swapWidthAndHeight` parameter is set to false via [setVideoProfile](https://docs.agora.io/en/2.2/product/Video/API%20Reference/communication_ios_video). Each profile includes a set of parameters such as: resolution, frame rate, bitrate, etc. If a device's camera does not support the specified resolution, the SDK automatically chooses a suitable camera resolution. However, the encoder resolution still uses the profile specified by `setVideoProfile()`. 

Since this configuration takes place before entering a channel, the end user will start in video mode rather than audio mode. If video mode were to be enabled enabled during a call, the app will switch from audio to video mode. 


### Joining a Channel
A helper method called `joinChannel()` invokes `agoraKit.joinChannel()` enables a user to join a specific channel:

``` swift
func joinChannel() {
    agoraKit.joinChannel(byKey: nil, channelName: "demoChannel1", info:nil, uid:0) {[weak self] (sid, uid, elapsed) -> Void in
        if let weakSelf = self {
            weakSelf.agoraKit.setEnableSpeakerphone(true)
           UIApplication.shared.isIdleTimerDisabled = true
       }
    }
}
```

The `channelName` parameter takes in the name of the channel to join, and the value of 0 for the `uid` parameter allows Agora to chose a random ID for the channel ID. 
The call to [agoraKit](https://docs.agora.io/en/2.2/product/Voice/API%20Reference/communication_mac_audio) enables the speakerphone when using Agora, and `UIApplication.shared.isIdleTimerDisabled` disables the application's idle timer to prevent the application from idling while the app is running.

**Note**: users in the same channel can talk to each other, however users with different app IDs cannot call each other (even if they join the same channel).

In the sample, the helper method `joinChannel()` is invoked by `viewDidLoad()`:

```override func viewDidLoad() {
    super.viewDidLoad();
    initializeAgoraEngine();
    setupVideo();  
    joinChannel();
    ...
}
```

### Setting up Local Video
The logic for the local video feed is contained within a helper method called `setupLocalVideo()` that is invoked by `viewDidLoad()`:

``` swift
func setupLocalVideo() {
    let videoCanvas = AgoraRtcVideoCanvas()
    videoCanvas.uid = 0
    videoCanvas.view = localVideo
    videoCanvas.renderMode = .render_Fit
    agoraKit.setupLocalVideo(videoCanvas)
}

override func viewDidLoad() {
    super.viewDidLoad(true);
    initializeAgoraEngine();
    setupVideo();
    setupLocalVideo();   
}
```

`setupLocalVideo()` creates an `AgoraRtcVideoCanvas` object for the video stream and initializes the following properties:
* **uid**: a value of 0 allows Agora to chose a random ID for the stream feed.
* **view**: set to the `localVideo` view from the storyboard.
* **renderMode**: set to `render_Fit` to ensure that if the video size is different than that of the display window, the video is resized proportionally to fit the window. 

The call to [setupLocalVideo](https://docs.agora.io/en/2.2/product/Interactive%20Broadcast/API%20Reference/communication_mac_video) then passes `AgoraRtcVideoCanvas` object that was just created.


### Adding Delegate Methods
The `VideoCallViewController` class extends `AgoraRtcEngineDelegate`:

``` swift
func rtcEngine(_ engine: AgoraRtcEngineKit!, firstRemoteVideoDecodedOfUid uid:UInt, size:CGSize, elapsed:Int) {
    if (remoteVideo.isHidden) {
        remoteVideo.isHidden = false
    }
    let videoCanvas = AgoraRtcVideoCanvas()
    videoCanvas.uid = uid
    videoCanvas.view = remoteVideo
    videoCanvas.renderMode = .render_Adaptive
    agoraKit.setupRemoteVideo(videoCanvas)
}
func rtcEngine(_ engine: AgoraRtcEngineKit!, didOfflineOfUid uid:UInt, reason:AgoraRtcUserOfflineReason) {
    self.remoteVideo.isHidden = true
}
func rtcEngine(_ engine: AgoraRtcEngineKit!, didVideoMuted muted:Bool, byUid:UInt) {
    remoteVideo.isHidden = muted
    remoteVideoMutedIndicator.isHidden = !muted
}
```

The `rtcEngine(engine: AgoraRtcEngineKit, firstRemoteVideoDecodedOfUid uid: UInt, size: CGSize, elapsed: Int)` delegate method is invoked once connected with another user and the first remote video frame is received and decoded. This method performs the followoing:
* checks if the `remoteVideo` view is hidden and unhides it if it is hidden.
* initializes the `AgoraRtcVideoCanvas` object.
* sets the `uid` property to 0 to allow Agora to chose a random UID for the stream feed. 
* sets the `view` property to the `remoteVideo` view from the storyboard.
* sets `renderMode` to `render_Fit` to ensure that if the video size is different than that of the display window, the video is resized proportionally to fit the window. 
* invokes `agoraKit.setupRemoteVideo(videoCanvas)` passing in the `AgoraRtcVideoCanvas` object that was just created.

The `rtcEngine(_engine:  AgoraRtcEngineKit, didOfflineOfUid uid: UInt, reason: AgoraRtcUserOfflineReason)` delegate is invoked when another user leaves the channel. This method sets the `remoteVideo` view to be hidden when a user leaves the call.

The `rtcEngine(engine: AgoraRtcEngineKit, didVideoMuted muted: UInt, byUid: UInt)` is invoked when a remote user pauses their stream. This method toggles the remote video user inteface elements.


## Adding Other Functionality

### Adding Channel Selection
The *Set Channel View Controller* allows the user to specify the channel they wish to join through a textbox for the channel name and a button to start the call. The text field was added as an outlet and the button was added as an action. The logic to handle this in the sample is implemented in `SetChannelViewController.swift`:

``` swift
@IBOutlet weak var channelName: UITextField!

@IBAction func startCall(_ sender: UIButton) {
    if (channelName.text?.isEmpty)! {
        self.performSegue(withIdentifier: "startCall", sender: self)
    } else {
        print("Enter Channel Name")
    }
}

override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    if let viewController = segue.destination as? VideoCallViewController {
        viewController.channel = channelName.text!
    }
}
```

`startCall()` performs the following:
* If the text field contains a value, the segue `startCall` navigates the user to the `VideoChatViewController` within the `IBAction` for the button.
* If the text field does not contain a value, prompt the user to enter some text for the channel name. 

The `prepare(for segue:)` method is invoked to obtain the name of the channel and to pass it to the `VideoChatViewController`.

### Hanging Up and Ending the Call
*Video Call View Controller* contains a helper function called `leaveChannel()` with the logic to leave the current video call (channel). This is invoked by the `IBAction` for the *Hang-Up* button:

```swift
@IBAction func didClickHangUpButton(_ sender: UIButton) {
    leaveChannel()
}

func leaveChannel() {
    agoraKit.leaveChannel(nil)
    hideControlButtons()
    UIApplication.shared.isIdleTimerDisabled = false
    remoteVideo.removeFromSuperview()
    localVideo.removeFromSuperview()
    agoraKit = nil
}

func hideControlButtons() {
    controlButtons.isHidden = true
}
```

`leaveChannel()` performs the following:
* invokes `agoraKit.leaveChannel()` to leave the channel
* invokes the helper method `hideControlButtons()` to hide the `controlButtons` view containing the bottom buttons.
* re-enables the application's idle timer.
* removes both the local and remote video views.
* sets `agoraKit` to `nil` to remove the reference to the `AgoraRtcEngineKit` object.


### Muting Audio
To allow the user to mute audio, the `IBAction` for the mute button invokes `agoraKit.muteLocalAudioStream()` passing in `sender.isSelected`:

```swift
@IBAction func didClickMuteButton(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    agoraKit.muteLocalAudioStream(sender.isSelected)
    resetHideButtonsTimer()
}
```

Once muted the helper method `resetHideButtonsTimer()` is invoked to cancel any view perform requests and to ensure the control buttons are hidden:

```swift
func resetHideButtonsTimer() {
    VideoCallViewController.cancelPreviousPerformRequests(withTarget: self)
    perform(#selector(hideControlButtons), with:nil, afterDelay:3)
```}

### Muting Video
To allow the user to mute local video (i.e. to prevent video of the current user from being broadcast to other users), the `IBAction` for the *video button* invokes [muteLocalVideoStream](https://docs.agora.io/en/2.2/product/Interactive%20Broadcast/API%20Reference/communication_mac_video#mute-a-specified-remote-audio-stream-muteremoteaudiostream):

```swift
@IBAction func didClickVideoMuteButton(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    agoraKit.muteLocalVideoStream(sender.isSelected)
    localVideo.isHidden = sender.isSelected
    localVideoMutedBg.isHidden = !sender.isSelected
    localVideoMutedIndicator.isHidden = !sender.isSelected
    resetHideButtonsTimer()
}
```

Once muted, the views related to the local view are hidden and the helper method `resetHideButtonsTimer()` is invoked to cancel any *perform* requests and to ensure the control buttons are hidden.

### Switching Cameras
To enable the user to choose between the front and rear cameras, an `IBAction` for the *camera switch button* invokes [switchCamera](https://docs.agora.io/en/2.2/product/Interactive%20Broadcast/Solutions/live_plus_ios?platform=iOS#id3) to add the camera switch functionality:  

```swift
@IBAction func didClickSwitchCameraButton(_ sender: UIButton) {
    sender.isSelected = !sender.isSelected
    agoraKit.switchCamera()
    resetHideButtonsTimer()
}
```


### Hiding Local and Remote Video Views
To hide all the image views that are meant to appear when either the remote or local video feeds are paused, the sample defines the `hideVideoMuted()' helper method. This method is invoked from `viewDidLoad()` to ensure the videos are hidden on startup:

```swift
func hideVideoMuted() {
    remoteVideoMutedIndicator.isHidden = true
    localVideoMutedBg.isHidden = true
    localVideoMutedIndicator.isHidden = true
}
```


### Keeping the Interface Clean
For a refined user experience, the sample hides the view containing the buttons after three seconds, to make the user interface appear cleaner. The sample uses a helper method called `setupButtons()` which calls the `hideControlButtons()` function after three seconds, and is invoked by `viewDidLoad()`:

```swift
func setupButtons() {
    perform(#selector(hideControlButtons), with:nil, afterDelay:3)
    let tapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(VideoChatViewController.viewTapped))
    view.addGestureRecognizer(tapGestureRecognizer)
    view.isUserInteractionEnabled = true
}
```

The sample uses a tap gesture recognizer (of type: `UITabGestureRecognizer`) as part of the view which performs the action of calling the `viewTapped()` function:
```swift
func viewTapped() {
    if (controlButtons.isHidden) {
        controlButtons.isHidden = false;
        perform(#selector(hideControlButtons), with:nil, afterDelay:3)
    }
}
```

## Conclusion
If you have any questions, please feel free to reach out via [e-mail](mailto:sid.sharma@agora.io) or [Twitter](https://twitter.com/sidsharma_27).

