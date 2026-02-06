import Cocoa

final class AppDelegate: NSObject, NSApplicationDelegate {
    private var clipboardMonitor: ClipboardMonitor?
    private var hotKeyManager: HotKeyManager?

    func applicationDidFinishLaunching(_ notification: Notification) {
        PermissionService.checkAccessibility()

        clipboardMonitor = ClipboardMonitor()
        clipboardMonitor?.start()

        hotKeyManager = HotKeyManager()
        hotKeyManager?.register()
    }

    func applicationWillTerminate(_ notification: Notification) {
        clipboardMonitor?.stop()
        hotKeyManager?.unregister()
    }
}
