import SwiftUI

// Helper extensions to convert Color to Data and back, for use with AppStorage.
extension Color {
    func toData() -> Data {
        do {
            let color = NSColor(self)
            return try NSKeyedArchiver.archivedData(withRootObject: color, requiringSecureCoding: false)
        } catch {
            print("Error converting color to data: \(error)")
            return Data()
        }
    }
    
    init(data: Data) {
        do {
            if let nsColor = try NSKeyedUnarchiver.unarchivedObject(ofClass: NSColor.self, from: data) {
                self.init(nsColor: nsColor)
                return
            }
        } catch {
            print("Error converting data to color: \(error)")
        }
        self = .primary // Fallback color
    }
}
