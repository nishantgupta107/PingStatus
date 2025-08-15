import SwiftUI

struct AppMenuView: View {
    @EnvironmentObject private var pingManager: PingManager
    // This is used to programmatically open our settings window.
    @Environment(\.openWindow) private var openWindow

    var body: some View {
        VStack(spacing: 12) {
            Text("Ping Status")
                .font(.headline)

            HStack {
                Text("Status:")
                Text(statusText)
                    .fontWeight(.bold)
            }

            Text("Pinging \(pingManager.destinationIP)")
                .font(.caption)
                .foregroundColor(.secondary)

            Divider()

            Button("Settings...") {
                // This command opens the window with the ID we defined in the main App file.
                openWindow(id: "settings-window")
            }

            Button("Quit") {
                NSApplication.shared.terminate(nil)
            }
        }
        .padding(12)
    }
    
    private var statusText: String {
        switch pingManager.pingStatus {
        case .unknown: return "Idle"
        case .success: return "Success"
        case .failure: return "Failed"
        }
    }
}
