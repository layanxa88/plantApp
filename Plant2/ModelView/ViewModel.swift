import Foundation
import Combine
import UserNotifications

class PlantViewModel: ObservableObject {
    
    @Published var plants: [Plant] = []
    
    func addPlant(name: String, room: PlantRoom, light: LightCondition, wateringDays: WateringFrequency, waterAmount: WaterAmount) {
        let newPlant = Plant(
            name: name,
            room: room,
            light: light,
            wateringDays: wateringDays,
            waterAmount: waterAmount
        )
        plants.append(newPlant)
        scheduleNotification(newPlant)
    }
    
    func toggleWatered(_ plant: Plant) {
        if let index = plants.firstIndex(where: { item in item.id == plant.id }) {
            plants[index].isWatered.toggle()
        }
    }
    
    func updatePlant(_ plant: Plant) {
        if let index = plants.firstIndex(where: { item in item.id == plant.id }) {
            plants[index] = plant
            scheduleNotification(plant)
        }
    }
    
    func deletePlant(_ plant: Plant) {
        cancelNotification(plant)
        plants.removeAll { item in item.id == plant.id }
    }
    
    // Progress of watered plants (0 to 1) for the progress bar
    var progress: Double {
        if plants.isEmpty { return 0 }
        
        var done = 0
        for plant in plants {
            if plant.isWatered {
                done += 1
            }
        }
        return Double(done) / Double(plants.count)
    }
    
    var allDone: Bool {
        progress == 1
    }
    
    
    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("Notifications allowed:", granted)
        }
    }
    
    // Schedule a reminder for the plant
    func scheduleNotification(_ plant: Plant) {
        
        let content = UNMutableNotificationContent()
        content.title = "Planto"
        content.body = "Hey! let's water your \(plant.name) 🌱"
        content.sound = .default
        
        // Repeat interval in seconds
        let seconds: Double
        switch plant.wateringDays {
        case .everyDay:
            seconds = 86400
        case .everyTwoDays:
            seconds = 172800
        case .everyThreeDays:
            seconds = 259200
        case .weekly:
            seconds = 604800
        case .everyTenDays:
            seconds = 864000
        case .everyTwoWeeks:
            seconds = 1209600
        }
        
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: seconds, repeats: true)
        let request = UNNotificationRequest(identifier: plant.id.uuidString,
                                            content: content,
                                            trigger: trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // Cancel the plant's reminder
    func cancelNotification(_ plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }
}
