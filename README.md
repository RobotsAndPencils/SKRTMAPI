# SKRTMAPI has been consolidated into [SlackKit](https://www.github.com/pvzig/SlackKit)

A module for connecting to the [Slack Real Time Messaging API](https://api.slack.com/rtm).

## Installation

### CocoaPods

Add SKRTMAPI to your pod file:

```
use_frameworks!
pod 'SKRTMAPI'
```
and run

```
# Use CocoaPods version >= 1.4.0
pod install
```

### Carthage

Add SKRTMAPI to your Cartfile:

```
github "SlackKit/SKRTMAPI"
```
and run

```
carthage bootstrap
```

Drag the built `SKRTMAPI.framework` into your Xcode project.

### Swift Package Manager

Add SKRTMAPI to your Package.swift

```swift
import PackageDescription
  
let package = Package(
	dependencies: [
		.package(url: "https://github.com/pvzig/SKRTMAPI.git", .upToNextMinor(from: "4.1.0"))
	]
)
```

Run `swift build` on your application’s main directory.

To use the library in your project import it:

```swift
import SKRTMAPI
```

## Usage
Initialize an instance of `SKRTMAPI` with a Slack auth token:

```swift
let rtm = SKRTMAPI(token: "xoxb-SLACK_AUTH_TOKEN")
rtm.connect()
```

If your bot doesn't need any state information when you connect, pass `false` for the `withInfo` parameter:

```swift
let rtm = SKRTMAPI(token: "xoxb-SLACK_AUTH_TOKEN")
rtm.connect(withInfo: false)
```

Customize the connection with `RTMOptions`:

```swift
let options = RTMOptions(simpleLatest: false, noUnreads: false, mpimAware: true, pingInterval: 30, timeout: 300, reconnect: true)
let rtm = SKRTMAPI(token: "xoxb-SLACK_AUTH_TOKEN", options: options)
rtm.connect()
```

Provide your own web socket implementation by conforming to `RTMWebSocket`:

```swift
public protocol RTMWebSocket {
    init()
    var delegate: RTMDelegate? { get set }
    func connect(url: URL)
    func disconnect()
    func sendMessage(_ message: String) throws
}
```

```swift
let rtmWebSocket = YourRTMWebSocket()
let rtm = SKRTMAPI(token: "xoxb-SLACK_AUTH_TOKEN", rtm: rtmWebSocket)
rtm.connect()
```
