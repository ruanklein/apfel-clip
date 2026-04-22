import SwiftUI

struct HotkeyRecorderView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var config: HotkeyConfig
    @State private var isRecording = false
    @State private var localMonitor: Any?

    private var theme: AppTheme {
        AppTheme(colorScheme: colorScheme)
    }

    var body: some View {
        Button {
            if isRecording {
                stopRecording()
            } else {
                startRecording()
            }
        } label: {
            HStack(spacing: 6) {
                if isRecording {
                    Image(systemName: "record.circle")
                        .foregroundStyle(.red)
                    Text("Press shortcut...")
                        .font(.caption.weight(.medium))
                        .foregroundStyle(.red)
                } else {
                    Text(config.displayLabel)
                        .font(.system(size: 13, weight: .semibold, design: .rounded))
                        .foregroundStyle(AppTheme.brand)
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isRecording ? theme.destructiveFill : theme.rowStrongFill)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .stroke(isRecording ? theme.destructiveStroke : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(.plain)
        .onDisappear {
            stopRecording()
        }
    }

    private func startRecording() {
        isRecording = true
        localMonitor = NSEvent.addLocalMonitorForEvents(matching: .keyDown) { event in
            if event.keyCode == 53 { // Escape
                stopRecording()
                return nil
            }
            if let newConfig = HotkeyConfig.from(event: event) {
                config = newConfig
                stopRecording()
            }
            return nil
        }
    }

    private func stopRecording() {
        isRecording = false
        if let monitor = localMonitor {
            NSEvent.removeMonitor(monitor)
            localMonitor = nil
        }
    }
}
