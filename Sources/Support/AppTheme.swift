import AppKit
import SwiftUI

extension AppAppearance {
    var preferredColorScheme: ColorScheme? {
        switch self {
        case .system:
            return nil
        case .light:
            return .light
        case .dark:
            return .dark
        }
    }

    var nsAppearanceName: NSAppearance.Name? {
        switch self {
        case .system:
            return nil
        case .light:
            return .aqua
        case .dark:
            return .darkAqua
        }
    }
}

struct AppTheme {
    static let brand = Color(red: 0.16, green: 0.49, blue: 0.22)
    static let brandStrong = Color(red: 0.15, green: 0.45, blue: 0.20)

    let colorScheme: ColorScheme

    var backgroundGradient: [Color] {
        switch colorScheme {
        case .dark:
            return [
                Color(red: 0.09, green: 0.14, blue: 0.11),
                Color(red: 0.08, green: 0.10, blue: 0.11),
            ]
        default:
            return [
                Color(red: 0.94, green: 0.98, blue: 0.93),
                Color(red: 0.99, green: 0.97, blue: 0.92),
            ]
        }
    }

    var surfaceCardFill: Color {
        switch colorScheme {
        case .dark:
            return Color(red: 0.12, green: 0.15, blue: 0.14).opacity(0.9)
        default:
            return Color.white.opacity(0.62)
        }
    }

    var surfaceCardStroke: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.08)
        default:
            return Color.white.opacity(0.55)
        }
    }

    var shadowColor: Color {
        switch colorScheme {
        case .dark:
            return Color.black.opacity(0.22)
        default:
            return Color.black.opacity(0.04)
        }
    }

    var rowFill: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.08)
        default:
            return Color.white.opacity(0.78)
        }
    }

    var rowHoverFill: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.14)
        default:
            return Color.white
        }
    }

    var rowStrongFill: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.11)
        default:
            return Color.white.opacity(0.8)
        }
    }

    var rowStrongHoverFill: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.16)
        default:
            return Color.white
        }
    }

    var inputFill: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.1)
        default:
            return Color.white.opacity(0.9)
        }
    }

    var capsuleFill: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.12)
        default:
            return Color.white.opacity(0.86)
        }
    }

    var detailCardFill: Color {
        switch colorScheme {
        case .dark:
            return Color(red: 0.15, green: 0.18, blue: 0.16).opacity(0.92)
        default:
            return Color(red: 0.94, green: 0.99, blue: 0.94).opacity(0.9)
        }
    }

    var subtleBrandFill: Color {
        switch colorScheme {
        case .dark:
            return Self.brand.opacity(0.22)
        default:
            return Self.brand.opacity(0.12)
        }
    }

    var detailStroke: Color {
        switch colorScheme {
        case .dark:
            return Self.brand.opacity(0.35)
        default:
            return Self.brand.opacity(0.22)
        }
    }

    var dragPreviewFill: Color {
        switch colorScheme {
        case .dark:
            return Color(red: 0.16, green: 0.19, blue: 0.18).opacity(0.96)
        default:
            return Color.white.opacity(0.95)
        }
    }

    var subtleBorder: Color {
        switch colorScheme {
        case .dark:
            return Color.white.opacity(0.12)
        default:
            return Self.brand.opacity(0.25)
        }
    }

    var destructiveFill: Color {
        switch colorScheme {
        case .dark:
            return Color.red.opacity(0.14)
        default:
            return Color.red.opacity(0.08)
        }
    }

    var destructiveStroke: Color {
        switch colorScheme {
        case .dark:
            return Color.red.opacity(0.4)
        default:
            return Color.red.opacity(0.3)
        }
    }
}