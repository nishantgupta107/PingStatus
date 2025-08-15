import SwiftUI

struct MainIconView: View {
    @EnvironmentObject private var pingManager: PingManager

    var body: some View {
        HStack(spacing: 4) {
            // The gradient circle
            Circle()
                .fill(gradientForStatus())
                .frame(width: 16, height: 16)
                .shadow(color: .black.opacity(0.2), radius: 1)

            // The latency text, which only appears if enabled and available
            if pingManager.showLatency, let pingTime = pingManager.lastPingTime {
                Text(pingTime)
                    .font(.system(size: pingManager.latencyFontSize, weight: .semibold))
                    .foregroundColor(Color(data: pingManager.latencyColorData))
            }
        }
        // Add padding to prevent the view from being clipped
        .padding(.horizontal, 4)
    }

    private func gradientForStatus() -> LinearGradient {
        switch pingManager.pingStatus {
        case .unknown: return pingManager.unknownGradient
        case .success: return pingManager.successGradient
        case .failure: return pingManager.failureGradient
        }
    }
}
