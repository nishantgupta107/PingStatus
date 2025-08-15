import SwiftUI

struct SettingsView: View {
    // (Existing @AppStorage properties remain)
    @AppStorage("destinationIP") private var destinationIP: String = "8.8.8.8"
    @AppStorage("isEnabled") private var isEnabled: Bool = true
    @AppStorage("successColorTop") private var successColorTopData: Data = Color.green.toData()
    @AppStorage("successColorBottom") private var successColorBottomData: Data = Color.blue.toData()
    @AppStorage("failureColorTop") private var failureColorTopData: Data = Color.red.toData()
    @AppStorage("failureColorBottom") private var failureColorBottomData: Data = Color.orange.toData()
    
    // NEW: @AppStorage for text settings
    @AppStorage("showLatency") private var showLatency: Bool = true
    @AppStorage("latencyFontSize") private var latencyFontSize: Double = 12.0
    @AppStorage("latencyColorData") private var latencyColorData: Data = Color.primary.toData()
    
    var body: some View {
        Form {
            // (Existing General Settings and Color Configuration Sections remain the same)
            Section {
                            Toggle("Enable Ping", isOn: $isEnabled)
                            
                            HStack {
                                Text("Destination IP:")
                                TextField("e.g., 8.8.8.8", text: $destinationIP)
                                    .textFieldStyle(.roundedBorder)
                            }
                        } header: {
                            Text("General Settings")
                        }

                        Section {
                            ColorPicker("Success (Top)", selection: Binding(
                                get: { Color(data: successColorTopData) },
                                set: { successColorTopData = $0.toData() }
                            ), supportsOpacity: false)
                            
                            ColorPicker("Success (Bottom)", selection: Binding(
                                get: { Color(data: successColorBottomData) },
                                set: { successColorBottomData = $0.toData() }
                            ), supportsOpacity: false)
                            
                            ColorPicker("Failure (Top)", selection: Binding(
                                get: { Color(data: failureColorTopData) },
                                set: { failureColorTopData = $0.toData() }
                            ), supportsOpacity: false)
                            
                            ColorPicker("Failure (Bottom)", selection: Binding(
                                get: { Color(data: failureColorBottomData) },
                                set: { failureColorBottomData = $0.toData() }
                            ), supportsOpacity: false)
                            
                        } header: {
                            Text("Color Configuration")
                        }

            // NEW: Section for Latency Text
            Section(header: Text("Latency Display")) {
                Toggle("Show Latency Text", isOn: $showLatency)
                
                ColorPicker("Text Color", selection: Binding(
                    get: { Color(data: latencyColorData) },
                    set: { latencyColorData = $0.toData() }
                ), supportsOpacity: false)
                
                Stepper("Font Size: \(Int(latencyFontSize))pt", value: $latencyFontSize, in: 8...24)
            }
        }
        .padding()
        .frame(width: 350)
    }
}
