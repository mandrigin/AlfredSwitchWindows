# Swift Windows Switcher

## Catalina Users

Make sure that Alfred is added to "Security & Privacy -> Screen Recording"

![](/catalina.png)

## * * *

My little "weekend" project.
Alfred workflow to switch between open windows in the system and Safari tabs.

![](/demo_concise.gif)

## Features
- Switch between the open windows using Alfred
- Switch between the Safari tabs using Alfred
- Very quick comparing to the alternative implementations because of the native search implementation.

## Releases

You can download the ready-to-use `.workflow` files from [the releases page](https://github.com/mandrigin/AlfredSwitchWindows/releases).

## Source code

You can start exploring the source code at [main.swift](EnumWindows/main.swift)

### `ScriptingBridge` in Swift

It turns out, that `ScriptingBridge` implementation is not fully compatible with Swift.

(Classes like `SafariApplication` are not imported, so we can't use them).

One of the possible solutions to this issue is demonstrated in [BrowserApplication.swift](EnumWindows/BrowserApplication.swift)
(used for both Safari and Chrome automation)

**UPD:** There is a better solution using `optional` protocol methods:
```swift
@objc fileprivate enum PlayerState: NSInteger {
    case stopped = 0x6b505353
    case playing = 0x6b505350
    case paused = 0x6b505370
    case fastForwarding = 0x6b505346
    case rewinding = 0x6b505352
};

@objc fileprivate protocol iTunesBridge {
    @objc optional var isRunning: Bool { get }
    @objc optional var playerState: PlayerState { get }
    @objc optional func pause() -> Void
}

extension SBApplication: iTunesBridge{}

guard let app = SBApplication(bundleIdentifier: "com.apple.iTunes") as? iTunesBridge else {
   return
}

let isPlaying = app.playerState == .playing

NSLog("isPlaying: \(isPlaying)")
```

## License

Copyright 2017 © Igor Mandrigin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
