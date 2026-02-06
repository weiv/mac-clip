import Cocoa
import ApplicationServices

enum PermissionService {
    static func checkAccessibility() {
        let options = [kAXTrustedCheckOptionPrompt.takeUnretainedValue(): true] as CFDictionary
        let trusted = AXIsProcessTrustedWithOptions(options)
        if !trusted {
            NSLog("MacClip: Accessibility permission not granted. Paste simulation will not work.")
        }
    }
}
