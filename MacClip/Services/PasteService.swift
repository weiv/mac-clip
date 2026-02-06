import Cocoa
import Carbon.HIToolbox

enum PasteService {
    /// Shared flag: set to true before writing to pasteboard so ClipboardMonitor ignores the change.
    static var isOwnChange = false

    static func paste(_ text: String) {
        // Write the text to the system pasteboard
        isOwnChange = true
        let pasteboard = NSPasteboard.general
        pasteboard.clearContents()
        pasteboard.setString(text, forType: .string)

        // Clear the flag after enough time for ClipboardMonitor to see and skip it
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            isOwnChange = false
        }

        // Delay to allow the menu to close and the previous app to regain focus
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
            simulateCmdV()
        }
    }

    private static func simulateCmdV() {
        let source = CGEventSource(stateID: .hidSystemState)

        let keyDown = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: true)
        keyDown?.flags = .maskCommand

        let keyUp = CGEvent(keyboardEventSource: source, virtualKey: CGKeyCode(kVK_ANSI_V), keyDown: false)
        keyUp?.flags = .maskCommand

        keyDown?.post(tap: .cghidEventTap)
        keyUp?.post(tap: .cghidEventTap)
    }
}
