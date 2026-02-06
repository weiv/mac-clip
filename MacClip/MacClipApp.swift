import SwiftUI

@main
struct MacClipApp: App {
    @NSApplicationDelegateAdaptor(AppDelegate.self) var appDelegate

    var body: some Scene {
        MenuBarExtra("MacClip", systemImage: "doc.on.clipboard") {
            ClipboardMenuView()
        }
    }
}
