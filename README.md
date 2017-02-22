# Swift Windows Switcher

Alfred workflow to switch between open windows in the system and Safari tabs.

## Features
- Switch between the open windows using Alfred
- Switch between the Safari tabs using Alfred
- Very quick comparing to the alternative implementations because of the native search implementation.

## Source code

You can start exploring the source code at [main.swift](EnumWindows/main.swift)

### `ScriptingBridge` in Swift

It turns out, that `ScriptingBridge` implementation is not fully compatible with Swift.

(Classes like `SafariApplication` are not imported, so we can't use them).

One of the possible solutions to this issue is demonstrated in [SafariApplication.swift](EnumWindows/SafariApplication.swift)

## License 

Copyright 2017 © Igor Mandrigin

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
