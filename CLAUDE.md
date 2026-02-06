# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Overview

mac-clip is a native macOS clipboard management app. It lives in the menu bar, monitors the system clipboard, maintains the last 10 copied text items in memory, and lets users paste previous items via click or keyboard shortcuts (Cmd+Shift+1 through Cmd+Shift+0).

## Architecture

- **SwiftUI + MenuBarExtra** (macOS 13+), `.menu` style for native dropdown
- **Non-sandboxed** — required for `CGEventPost` (paste simulation)
- **Timer-based clipboard polling** — checks `NSPasteboard.general.changeCount` every 0.5s
- **HotKey library** ([soffes/HotKey](https://github.com/soffes/HotKey)) for global shortcut registration
- **`ClipboardHistory` singleton** (`ObservableObject`) shared across the app

### Key Files

```
MacClip/
├── MacClipApp.swift           # @main, MenuBarExtra scene, AppDelegate adaptor
├── AppDelegate.swift          # Init services, permission check
├── Models/
│   ├── ClipboardItem.swift    # Identifiable struct (id, text, copiedAt, displayText)
│   └── ClipboardHistory.swift # ObservableObject singleton, @Published items
├── Services/
│   ├── ClipboardMonitor.swift # Timer polling, changeCount tracking
│   ├── PasteService.swift     # Pasteboard write + CGEvent Cmd+V simulation
│   ├── HotKeyManager.swift    # 10 HotKey instances for Cmd+Shift+1-0
│   └── PermissionService.swift# AXIsProcessTrustedWithOptions check/prompt
└── Views/
    └── ClipboardMenuView.swift# Menu items, Clear History, Launch at Login, Quit
```

## Build Commands

```bash
# Build
xcodebuild -project MacClip.xcodeproj -scheme MacClip -configuration Debug build

# Run
open "$(xcodebuild -project MacClip.xcodeproj -scheme MacClip -showBuildSettings 2>/dev/null | grep ' BUILT_PRODUCTS_DIR' | awk '{print $3}')/MacClip.app"
```

## Requirements

- macOS 13.0+
- Xcode 15+
- Accessibility permission (for paste simulation via CGEvent)
