import Foundation

struct Plant: Identifiable, Codable {
    var id = UUID()
    var name: String
    var room: PlantRoom
    var light: LightCondition
    var wateringDays: WateringFrequency
    var waterAmount: WaterAmount
    var isWatered = false
}

enum PlantRoom: String, Codable, CaseIterable {
    case bedroom = "Bedroom"
    case livingRoom = "Living Room"
    case kitchen = "Kitchen"
    case balcony = "Balcony"
    case bathroom = "Bathroom"
}

enum LightCondition: String, Codable, CaseIterable {
    case fullSun = "Full Sun"
    case partialSun = "Partial Sun"
    case low = "Low Light"
    
    var icon: String {
        switch self {
        case .fullSun: return "sun.max"
        case .partialSun: return "sun.horizon"
        case .low: return "moon"
        }
    }
}

enum WateringFrequency: String, Codable, CaseIterable {
    case everyDay = "Every day"
    case everyTwoDays = "Every 2 days"
    case everyThreeDays = "Every 3 days"
    case weekly = "Once a week"
    case everyTenDays = "Every 10 days"
    case everyTwoWeeks = "Every 2 weeks"
}

enum WaterAmount: String, Codable, CaseIterable {
    case small = "20-50 ml"
    case medium = "50-100 ml"
    case large = "100-200 ml"
    case extraLarge = "200-300 ml"
}


