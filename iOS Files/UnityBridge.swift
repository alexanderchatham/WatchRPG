import Foundation
import WatchConnectivity

@objc public class UnityBridge: NSObject {
    @objc public static func sendEventToWatch(_ eventName: String) {
        if WCSession.default.isReachable {
            WCSession.default.sendMessage(["event": eventName], replyHandler: nil, errorHandler: nil)
        }
    }
}
