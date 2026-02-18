import Cocoa
import SwiftUI

final class PasteHUD {
    static let shared = PasteHUD()
    private var panel: NSPanel?
    private var hideTask: DispatchWorkItem?

    func show() {
        DispatchQueue.main.async {
            self.hideTask?.cancel()

            if self.panel == nil {
                self.panel = Self.makePanel()
            }

            // Position above the current cursor location
            let mouse = NSEvent.mouseLocation
            self.panel?.setFrameOrigin(NSPoint(
                x: mouse.x - Self.panelSize.width / 2,
                y: mouse.y + 24
            ))

            self.panel?.alphaValue = 1
            self.panel?.orderFrontRegardless()

            let task = DispatchWorkItem {
                NSAnimationContext.runAnimationGroup { ctx in
                    ctx.duration = 0.25
                    self.panel?.animator().alphaValue = 0
                } completionHandler: {
                    self.panel?.orderOut(nil)
                }
            }
            self.hideTask = task
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75, execute: task)
        }
    }

    private static let panelSize = CGSize(width: 110, height: 36)

    private static func makePanel() -> NSPanel {
        let frame = CGRect(origin: .zero, size: panelSize)
        let panel = NSPanel(
            contentRect: frame,
            styleMask: [.borderless, .nonactivatingPanel],
            backing: .buffered,
            defer: false
        )
        let hosting = NSHostingController(rootView: PasteHUDView())
        hosting.view.frame = CGRect(origin: .zero, size: panelSize)
        panel.contentView = hosting.view
        panel.backgroundColor = .clear
        panel.isOpaque = false
        panel.level = .floating
        panel.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        panel.isMovable = false
        panel.hasShadow = true
        return panel
    }
}

private struct PasteHUDView: View {
    var body: some View {
        HStack(spacing: 5) {
            Image(systemName: "checkmark")
                .fontWeight(.semibold)
            Text("Pasted")
                .fontWeight(.medium)
        }
        .font(.system(size: 13))
        .foregroundColor(.white)
        .padding(.horizontal, 12)
        .padding(.vertical, 7)
        .background(Capsule().fill(Color.black.opacity(0.72)))
        .padding(4)
    }
}
