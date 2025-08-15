import SwiftUI

struct MainIconView: View {
    @EnvironmentObject private var pingManager: PingManager

    var body: some View {
        HStack(spacing: 4) {
            // The gradient circle (this part is unchanged)
            Circle()
                .fill(gradientForStatus())
                .frame(width: 16, height: 16)
                .shadow(color: .black.opacity(0.2), radius: 1)

            // The latency text
            if pingManager.showLatency, let pingTime = pingManager.lastPingTime {
                Text(pingTime)
                    .font(.system(size: pingManager.latencyFontSize, weight: .semibold))
                    // This now calls our new function to get the right color
                    .foregroundColor(textColorForStatus())
            }
        }
        .padding(.horizontal, 4)
    }

    private func gradientForStatus() -> LinearGradient {
        switch pingManager.pingStatus {
        case .unknown: return pingManager.unknownGradient
        case .success: return pingManager.successGradient
        case .failure: return pingManager.failureGradient
        }
    }
    
    // NEW: This function determines the text color based on the status
    private func textColorForStatus() -> Color {
        switch pingManager.pingStatus {
        case .unknown:
            // For idle, we can use a neutral system color
            return .primary
        case .success:
            // Use the top color of the success gradient
            return Color(data: pingManager.successColorTopData)
        case .failure:
            // Use the top color of the failure gradient
            return Color(data: pingManager.failureColorTopData)
        }
    }
}