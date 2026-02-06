import SwiftUI
import ServiceManagement

struct ClipboardMenuView: View {
    @ObservedObject var history = ClipboardHistory.shared
    @State private var launchAtLogin = false

    var body: some View {
        if history.items.isEmpty {
            Text("No clipboard history")
                .foregroundColor(.secondary)
        } else {
            ForEach(Array(history.items.enumerated()), id: \.element.id) { index, item in
                Button(action: {
                    PasteService.paste(item.text)
                }) {
                    HStack {
                        Text(item.displayText)
                            .lineLimit(1)
                        Spacer()
                        if index < 9 {
                            Text("⌘⇧\(index + 1)")
                                .foregroundColor(.secondary)
                        } else if index == 9 {
                            Text("⌘⇧0")
                                .foregroundColor(.secondary)
                        }
                    }
                }
            }
        }

        Divider()

        Button("Clear History") {
            history.clear()
        }
        .disabled(history.items.isEmpty)

        Toggle("Launch at Login", isOn: $launchAtLogin)
            .onChange(of: launchAtLogin) { newValue in
                setLaunchAtLogin(newValue)
            }
            .onAppear {
                launchAtLogin = checkLaunchAtLogin()
            }

        Divider()

        Button("Quit MacClip") {
            NSApplication.shared.terminate(nil)
        }
        .keyboardShortcut("q")
    }

    private func setLaunchAtLogin(_ enabled: Bool) {
        if #available(macOS 13.0, *) {
            do {
                if enabled {
                    try SMAppService.mainApp.register()
                } else {
                    try SMAppService.mainApp.unregister()
                }
            } catch {
                NSLog("MacClip: Failed to set launch at login: \(error)")
            }
        }
    }

    private func checkLaunchAtLogin() -> Bool {
        if #available(macOS 13.0, *) {
            return SMAppService.mainApp.status == .enabled
        }
        return false
    }
}
