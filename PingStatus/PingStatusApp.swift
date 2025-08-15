import SwiftUI

@main
struct PingStatusApp: App {
    @StateObject private var pingManager = PingManager()

    var body: some Scene {
        MenuBarExtra {
            // The menu content remains the same
            AppMenuView()
                .environmentObject(pingManager)
        } label: {
            // *** THE MAIN FIX IS HERE ***
            // We render our SwiftUI view into an image and display that.
            // This is far more reliable than putting the view directly.
            if let image = MainIconView()
                            .environmentObject(pingManager)
                            .renderAsImage() {
                Image(nsImage: image)
            } else {
                // Provide a fallback SF Symbol just in case rendering fails
                Image(systemName: "circle.fill")
            }
        }
        .menuBarExtraStyle(.menu) // Stick with .menu for best compatibility

        Window("PingStatus Settings", id: "settings-window") {
                    SettingsView()
                        .environmentObject(pingManager) // Also pass the manager to settings
                }
                .windowResizability(.contentSize) // Make window non-resizable
    }
}
