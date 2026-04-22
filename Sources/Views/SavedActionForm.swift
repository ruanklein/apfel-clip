import SwiftUI

// MARK: - Icon catalog

enum SavedActionIconCatalog {
    static let `default` = "wand.and.stars"
    static let all: [String] = [
        // Writing
        "pencil", "pencil.and.outline", "square.and.pencil", "text.cursor",
        "textformat", "textformat.abc", "bold", "italic",
        // Transform
        "wand.and.stars", "wand.and.rays", "sparkles", "arrow.2.squarepath",
        "arrow.triangle.2.circlepath", "shuffle", "tornado", "staroflife",
        // Language / Communication
        "globe", "globe.americas.fill", "translate", "character.bubble",
        "quote.bubble", "message", "envelope", "megaphone",
        // Analysis
        "magnifyingglass", "doc.text.magnifyingglass", "checklist", "checkmark.seal",
        "exclamationmark.triangle", "ladybug", "shield", "lock.shield",
        // Code
        "chevron.left.forwardslash.chevron.right", "terminal", "curlybraces", "function",
        "number", "barcode", "qrcode", "cpu",
        // Utility
        "scissors", "scissors.badge.ellipsis", "list.bullet", "list.number",
        "bookmark", "tag", "folder", "doc.on.doc",
    ]
}

// MARK: - Icon grid (used inline when expanded)

private struct IconGridView: View {
    @Environment(\.colorScheme) private var colorScheme
    @Binding var selectedIcon: String
    private let columns = Array(repeating: GridItem(.flexible(), spacing: 6), count: 8)

    private var theme: AppTheme {
        AppTheme(colorScheme: colorScheme)
    }

    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 6) {
                ForEach(SavedActionIconCatalog.all, id: \.self) { symbol in
                    iconCell(symbol)
                }
            }
            .padding(4)
        }
        .frame(maxHeight: 188)
    }

    private func iconCell(_ symbol: String) -> some View {
        let isSelected = symbol == selectedIcon
        return Button {
            withAnimation(.easeInOut(duration: 0.12)) { selectedIcon = symbol }
        } label: {
            ZStack {
                RoundedRectangle(cornerRadius: 8, style: .continuous)
                    .fill(isSelected ? theme.subtleBrandFill : theme.rowFill)
                    .overlay(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .stroke(isSelected ? AppTheme.brand : Color.clear, lineWidth: 1.5)
                    )
                Image(systemName: symbol)
                    .font(.system(size: 15, weight: isSelected ? .semibold : .regular))
                    .foregroundStyle(isSelected ? AppTheme.brand : Color.primary)
            }
            .frame(width: 36, height: 36)
            .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
    }
}

// MARK: - Save/edit form

struct SavedActionFormView: View {
    @Environment(\.colorScheme) private var colorScheme
    enum Mode {
        case create(prompt: String)
        case edit(action: SavedCustomAction)
    }

    let mode: Mode
    let onSave: (String, String, Set<ContentType>) -> Void
    let onCancel: () -> Void
    let generateName: (() async -> String?)?

    @State private var name: String
    @State private var selectedIcon: String
    @State private var selectedTypes: Set<ContentType>
    @State private var isIconGridVisible = false
    @State private var isGeneratingName = false

    private var theme: AppTheme {
        AppTheme(colorScheme: colorScheme)
    }

    init(
        mode: Mode,
        generateName: (() async -> String?)? = nil,
        onSave: @escaping (String, String, Set<ContentType>) -> Void,
        onCancel: @escaping () -> Void
    ) {
        self.mode = mode
        self.generateName = generateName
        self.onSave = onSave
        self.onCancel = onCancel
        switch mode {
        case .create:
            _name = State(initialValue: "")
            _selectedIcon = State(initialValue: SavedActionIconCatalog.default)
            _selectedTypes = State(initialValue: [.text])
        case .edit(let action):
            _name = State(initialValue: action.name)
            _selectedIcon = State(initialValue: action.icon)
            _selectedTypes = State(initialValue: action.contentTypes)
        }
    }

    private var promptPreview: String {
        switch mode {
        case .create(let prompt): return prompt
        case .edit(let action): return action.prompt
        }
    }

    private var isEditMode: Bool {
        if case .edit = mode { return true }
        return false
    }

    private var isValid: Bool {
        !name.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty && !selectedTypes.isEmpty
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 12) {

            // Prompt preview
            VStack(alignment: .leading, spacing: 4) {
                Text("Prompt")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                Text(promptPreview)
                    .font(.caption)
                    .foregroundStyle(.secondary)
                    .lineLimit(2)
                    .truncationMode(.tail)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(8)
                    .background(
                        RoundedRectangle(cornerRadius: 8, style: .continuous)
                            .fill(theme.rowFill)
                    )
            }

            // Icon button + Name field on same row
            HStack(alignment: .bottom, spacing: 10) {
                // Prominent icon button — always visible, tap to toggle grid
                VStack(spacing: 4) {
                    Button {
                        withAnimation(.easeInOut(duration: 0.15)) { isIconGridVisible.toggle() }
                    } label: {
                        ZStack {
                            RoundedRectangle(cornerRadius: 10, style: .continuous)
                                .fill(isIconGridVisible ? theme.subtleBrandFill : theme.inputFill)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10, style: .continuous)
                                        .stroke(isIconGridVisible ? AppTheme.brand : theme.subtleBorder, lineWidth: 1.5)
                                )
                            Image(systemName: selectedIcon)
                                .font(.system(size: 20, weight: .semibold))
                                .foregroundStyle(AppTheme.brand)
                        }
                        .frame(width: 48, height: 48)
                    }
                    .buttonStyle(.plain)
                    Text(isIconGridVisible ? "Close" : "Icon")
                        .font(.caption2)
                        .foregroundStyle(AppTheme.brand)
                }

                // Name field
                VStack(alignment: .leading, spacing: 4) {
                    HStack(spacing: 6) {
                        Text("Action name")
                            .font(.caption.weight(.semibold))
                            .foregroundStyle(.secondary)
                        if isGeneratingName {
                            ProgressView()
                                .controlSize(.mini)
                                .tint(AppTheme.brand)
                            Text("Naming…")
                                .font(.caption2)
                                .foregroundStyle(AppTheme.brand)
                        }
                    }
                    TextField(isGeneratingName ? "" : "e.g. Translate to Italian", text: $name)
                        .textFieldStyle(.plain)
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .fill(isGeneratingName ? theme.rowFill : theme.inputFill)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 8, style: .continuous)
                                .stroke(!name.isEmpty ? AppTheme.brand.opacity(0.4) : Color.clear, lineWidth: 1)
                        )
                        .frame(height: 36)
                        .disabled(isGeneratingName)
                }
            }
            .task {
                guard case .create = mode, let generateName else { return }
                isGeneratingName = true
                if let suggested = await generateName() {
                    let trimmed = suggested.trimmingCharacters(in: .whitespacesAndNewlines)
                    if !trimmed.isEmpty { name = trimmed }
                }
                isGeneratingName = false
            }

            // Icon grid — expands inline on demand
            if isIconGridVisible {
                IconGridView(selectedIcon: $selectedIcon)
                    .transition(.move(edge: .top).combined(with: .opacity))
            }

            // Content type toggles
            VStack(alignment: .leading, spacing: 6) {
                Text("Triggers for")
                    .font(.caption.weight(.semibold))
                    .foregroundStyle(.secondary)
                HStack(spacing: 6) {
                    ForEach(ContentType.allCases, id: \.self) { type in
                        contentTypeToggle(type)
                    }
                }
            }

            // Buttons
            HStack {
                Button(isEditMode ? "Cancel edit" : "Cancel") { onCancel() }
                    .buttonStyle(.bordered)
                Spacer()
                Button(isEditMode ? "Save changes" : "Save Action") {
                    onSave(name, selectedIcon, selectedTypes)
                }
                .buttonStyle(.borderedProminent)
                .tint(AppTheme.brandStrong)
                .disabled(!isValid)
            }
        }
        .padding(12)
        .background(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .fill(theme.detailCardFill)
        )
        .overlay(
            RoundedRectangle(cornerRadius: 14, style: .continuous)
                .stroke(theme.detailStroke, lineWidth: 1)
        )
    }

    private func contentTypeToggle(_ type: ContentType) -> some View {
        let isSelected = selectedTypes.contains(type)
        return Button {
            withAnimation(.easeInOut(duration: 0.1)) {
                if isSelected { selectedTypes.remove(type) } else { selectedTypes.insert(type) }
            }
        } label: {
            Label(type.rawValue, systemImage: type.icon)
                .font(.caption.weight(.semibold))
                .padding(.horizontal, 8)
                .padding(.vertical, 5)
                .background(
                    Capsule()
                        .fill(isSelected ? AppTheme.brand : theme.rowFill)
                )
                .foregroundStyle(isSelected ? .white : Color.primary)
        }
        .buttonStyle(.plain)
    }
}
