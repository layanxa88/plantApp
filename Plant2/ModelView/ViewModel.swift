import Foundation
import Combine
import UserNotifications

class PlantViewModel: ObservableObject {

    // Every time the list changes, it is saved automatically
    @Published var plants: [Plant] = [] {
        didSet { save() }
    }

    private let saveKey = "savedPlants"

    // Load saved plants when the app starts
    init() {
        load()
    }

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
        // تم التأكد من عدم رجوع true إذا كانت القائمة فارغة بالأساس
        if plants.isEmpty { return false }
        return progress == 1
    }
    
    var wateredCount: Int {
        plants.filter { $0.isWatered }.count
    }
    
    // Pending plants first, watered plants at the bottom
    var sortedPlants: [Plant] {
        plants.filter { !$0.isWatered } + plants.filter { $0.isWatered }
    }

    // MARK: - Saving

    private func save() {
        if let data = try? JSONEncoder().encode(plants) {
            UserDefaults.standard.set(data, forKey: saveKey)
        }
    }

    private func load() {
        guard let data = UserDefaults.standard.data(forKey: saveKey),
              let saved = try? JSONDecoder().decode([Plant].self, from: data) else {
            return
        }
        plants = saved
    }

    // MARK: - Notifications

    func requestPermission() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound]) { granted, error in
            print("Notifications allowed:", granted)
        }
    }

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
        case.weekly:
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

    func cancelNotification(_ plant: Plant) {
        UNUserNotificationCenter.current()
            .removePendingNotificationRequests(withIdentifiers: [plant.id.uuidString])
    }
}
