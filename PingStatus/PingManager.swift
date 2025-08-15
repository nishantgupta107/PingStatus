import SwiftUI
import Combine

// (PingStatus enum remains the same)
enum PingStatus {
    case unknown
    case success
    case failure
}


@MainActor
class PingManager: ObservableObject {
    @Published var pingStatus: PingStatus = .unknown
    // NEW: Published property to hold the latency in milliseconds
    @Published var lastPingTime: String? = nil

    // --- AppStorage Properties ---
    @AppStorage("destinationIP") var destinationIP: String = "8.8.8.8"
    @AppStorage("pingInterval") private var pingInterval: Double = 2.0
    @AppStorage("isEnabled") private var isEnabled: Bool = true {
        didSet {
            if !isEnabled { lastPingTime = nil }
            resetTimer()
        }
    }

    // Gradient Colors
    @AppStorage("successColorTop") private var successColorTopData: Data = Color.green.toData()
    @AppStorage("successColorBottom") private var successColorBottomData: Data = Color.blue.toData()
    @AppStorage("failureColorTop") private var failureColorTopData: Data = Color.red.toData()
    @AppStorage("failureColorBottom") private var failureColorBottomData: Data = Color.orange.toData()
    @AppStorage("unknownColorTop") private var unknownColorTopData: Data = Color.gray.toData()
    @AppStorage("unknownColorBottom") private var unknownColorBottomData: Data = Color.secondary.toData()
    
    // NEW: Latency Text Settings
    @AppStorage("showLatency") var showLatency: Bool = true
    @AppStorage("latencyFontSize") var latencyFontSize: Double = 12.0
    @AppStorage("latencyColorData") var latencyColorData: Data = Color.primary.toData()

    // Computed properties to easily get and set the colors for the UI.
        var successGradient: LinearGradient {
            LinearGradient(colors: [Color(data: successColorTopData), Color(data: successColorBottomData)], startPoint: .top, endPoint: .bottom)
        }
        var failureGradient: LinearGradient {
            LinearGradient(colors: [Color(data: failureColorTopData), Color(data: failureColorBottomData)], startPoint: .top, endPoint: .bottom)
        }
        var unknownGradient: LinearGradient {
            LinearGradient(colors: [Color(data: unknownColorTopData), Color(data: unknownColorBottomData)], startPoint: .top, endPoint: .bottom)
        }

    private var timer: AnyCancellable?

    init() {
        resetTimer()
    }

    private func resetTimer() {
        timer?.cancel()
        guard isEnabled else {
            pingStatus = .unknown
            return
        }
        timer = Timer.publish(every: pingInterval, on: .main, in: .common)
            .autoconnect()
            .sink { [weak self] _ in
                self?.performPing()
            }
    }

    private func performPing() {
        guard isEnabled, !destinationIP.isEmpty else {
            pingStatus = .unknown
            lastPingTime = nil
            return
        }

        let task = Process()
        let pipe = Pipe() // Create a pipe to capture output
        
        task.executableURL = URL(fileURLWithPath: "/sbin/ping")
        task.arguments = ["-c", "1", "-t", "1", destinationIP]
        task.standardOutput = pipe // Redirect standard output to the pipe
        task.standardError = pipe // Also redirect error output

        do {
            try task.run()
            task.waitUntilExit()
            
            // Read the output data
            let data = pipe.fileHandleForReading.readDataToEndOfFile()
            let output = String(data: data, encoding: .utf8) ?? ""

            if task.terminationStatus == 0 {
                pingStatus = .success
                // Parse the output to find the time
                lastPingTime = parsePingTime(from: output)
            } else {
                pingStatus = .failure
                lastPingTime = nil
            }
        } catch {
            print("Ping failed to run: \(error)")
            pingStatus = .failure
            lastPingTime = nil
        }
    }
    
    // NEW: Function to parse the ping output with regex
    private func parsePingTime(from output: String) -> String? {
        do {
            let regex = try NSRegularExpression(pattern: "time=([0-9.]+) ms")
            if let match = regex.firstMatch(in: output, range: NSRange(output.startIndex..., in: output)) {
                if let range = Range(match.range(at: 1), in: output) {
                    let timeValue = Double(output[range]) ?? 0.0
                    return String(format: "%.0fms", timeValue) // Format as integer ms
                }
            }
        } catch {
            print("Regex error: \(error)")
        }
        return nil // Return nil if no time was found
    }
}
