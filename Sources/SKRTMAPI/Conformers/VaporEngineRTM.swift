//
//  VaporEngineRTM.swift
//
// Copyright © 2017 Peter Zignego. All rights reserved.
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.

#if os(Linux)
import Foundation
import WebSocket

public class VaporEngineRTM: RTMWebSocket {
    public weak var delegate: RTMDelegate?

    public required init() {}

    private var websocket: WebSocket?

    public func connect(url: URL) {
        do {
            let worker = MultiThreadedEventLoopGroup(numberOfThreads: 1)
            let scheme: HTTPScheme
            switch url.scheme {
                case "https"?: scheme = .https
                case "ws"?: scheme = .ws
                case "wss"?: scheme = .wss
                default: scheme = .http
            }
            let websocket = try HTTPClient.webSocket(scheme: scheme, hostname: url.host!, port: url.port, path: url.path, on: worker).wait()
            self.websocket = websocket

            self.delegate?.didConnect()

            websocket.onText { ws, text in
                self.delegate?.receivedMessage(text)
            }

            websocket.onCloseCode { _ in
                self.delegate?.disconnected()
            }
        } catch {
            print("Error connecting to \(url.absoluteString): \(error)")
        }
    }

    public func disconnect() {
        self.websocket?.close()
    }

    public func sendMessage(_ message: String) throws {
        guard let websocket = websocket else { throw SlackError.rtmConnectionError }
        websocket.send(message)
    }
}
#endif
