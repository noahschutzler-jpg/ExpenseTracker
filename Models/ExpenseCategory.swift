import Foundation

enum ExpenseCategory: String, CaseIterable, Identifiable, Codable {
    case foodAndDining = "Food & Dining"
    case fuel = "Fuel"
    case vehicleMaintenance = "Vehicle Maintenance"
    case rentMortgage = "Rent/Mortgage"
    case shopping = "Shopping"
    case entertainment = "Entertainment"
    case utilities = "Utilities"
    case healthcare = "Healthcare"
    case travel = "Travel"
    case other = "Other"

    var id: String { rawValue }

    var icon: String {
        switch self {
        case .foodAndDining: return "ðŸ½ï¸"
        case .fuel: return "â›½"
        case .vehicleMaintenance: return "ðŸ”§"
        case .rentMortgage: return "ðŸ "
        case .shopping: return "ðŸ›ï¸"
        case .entertainment: return "ðŸŽ¬"
        case .utilities: return "ðŸ’¡"
        case .healthcare: return "âš•ï¸"
        case .travel: return "âœˆï¸"
        case .other: return "ðŸ“¦"
        }
    }

    var color: String {
        switch self {
        case .foodAndDining: return "#FF6B6B"
        case .fuel: return "#4ECDC4"
        case .vehicleMaintenance: return "#45B7D1"
        case .rentMortgage: return "#96CEB4"
        case .shopping: return "#FFEAA7"
        case .entertainment: return "#DDA0DD"
        case .utilities: return "#98D8C8"
        case .healthcare: return "#F7DC6F"
        case .travel: return "#BB8FCE"
        case .other: return "#85C1E9"
        }
    }

    static var defaultCategories: [ExpenseCategory] {
        [.foodAndDining, .fuel, .vehicleMaintenance, .rentMortgage, .shopping, .entertainment, .utilities, .healthcare, .travel, .other]
    }
}
