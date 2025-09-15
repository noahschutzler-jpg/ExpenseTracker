import Foundation

enum RecurrenceFrequency: String, CaseIterable, Identifiable {
    case daily = "Daily"
    case weekly = "Weekly"
    case biweekly = "Bi-weekly"
    case monthly = "Monthly"
    case custom = "Custom"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .daily: return "📅"
        case .weekly: return "📆"
        case .biweekly: return "🗓️"
        case .monthly: return "📊"
        case .custom: return "⚙️"
        }
    }
    
    var description: String {
        switch self {
        case .daily: return "Every day"
        case .weekly: return "Every week"
        case .biweekly: return "Every 2 weeks"
        case .monthly: return "Every month"
        case .custom: return "Custom interval"
        }
    }
}
