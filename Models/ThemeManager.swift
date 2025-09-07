import SwiftUI

class ThemeManager: ObservableObject {
    @AppStorage("isDarkMode") var isDarkMode: Bool = false {
        didSet {
            updateAppearance()
        }
    }

    @AppStorage("accentColorHex") var accentColorHex: String = "#00D4AA" {
        didSet {
            updateAccentColor()
        }
    }

    @Published var accentColor: Color = Color.teal

    init() {
        updateAppearance()
        updateAccentColor()
    }

    func updateAppearance() {
        guard let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene,
              let window = windowScene.windows.first else { return }

        window.overrideUserInterfaceStyle = isDarkMode ? .dark : .light
    }

    func updateAccentColor() {
        accentColor = Color(hex: accentColorHex)
    }

    func setAccentColor(_ color: Color) {
        let hex = color.toHex()
        accentColorHex = hex ?? "#00D4AA"
        accentColor = color
    }

    static let predefinedColors: [String: Color] = [
        "Teal": Color.teal,
        "Blue": Color.blue,
        "Green": Color.green,
        "Orange": Color.orange,
        "Red": Color.red,
        "Purple": Color.purple,
        "Pink": Color.pink,
        "Indigo": Color.indigo,
        "Mint": Color.mint,
        "Brown": Color.brown
    ]
}

extension Color {
    func toHex() -> String? {
        let uiColor = UIColor(self)
        var red: CGFloat = 0
        var green: CGFloat = 0
        var blue: CGFloat = 0
        var alpha: CGFloat = 0

        guard uiColor.getRed(&red, green: &green, blue: &blue, alpha: &alpha) else {
            return nil
        }

        return String(format: "#%02lX%02lX%02lX",
                     lroundf(Float(red * 255)),
                     lroundf(Float(green * 255)),
                     lroundf(Float(blue * 255)))
    }
}
