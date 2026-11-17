import SwiftUI

struct ReminderPage: View {
    
    @ObservedObject var viewModel: PlantViewModel
    var plant: Plant? = nil      // if a plant is passed = edit, if nil = add new
    @Environment(\.dismiss) var dismiss
    
    @State private var name = ""
    @State private var room: PlantRoom = .bedroom
    @State private var light: LightCondition = .fullSun
    @State private var wateringDays: WateringFrequency = .everyDay
    @State private var waterAmount: WaterAmount = .small
    
    var body: some View {
        VStack(spacing: 25) {
            
            HStack {
                Button { dismiss() } label: {
                    Image(systemName: "xmark")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.gray.opacity(0.3))
                        .clipShape(Circle())
                }
                Spacer()
                Text("Set Reminder").font(.headline)
                Spacer()
                Button {
                    if let plant = plant {
                        var newPlant = plant
                        newPlant.name = name
                        newPlant.room = room
                        newPlant.light = light
                        newPlant.wateringDays = wateringDays
                        newPlant.waterAmount = waterAmount
                        viewModel.updatePlant(newPlant)
                    } else {
                        viewModel.addPlant(name: name, room: room, light: light,
                                           wateringDays: wateringDays, waterAmount: waterAmount)
                    }
                    dismiss()
                } label: {
                    Image(systemName: "checkmark")
                        .foregroundStyle(.white)
                        .frame(width: 44, height: 44)
                        .background(Color.green.opacity(0.6))
                        .clipShape(Circle())
                }
            }
            
            HStack {
                Text("Plant Name")
                TextField("Pothos", text: $name).tint(.green)
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .clipShape(Capsule())
            
            VStack {
                HStack {
                    Label("Room", systemImage: "location")
                    Spacer()
                    Picker("", selection: $room) {
                        ForEach(PlantRoom.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                }
                Divider()
                HStack {
                    Label("Light", systemImage: "sun.max")
                    Spacer()
                    Picker("", selection: $light) {
                        ForEach(LightCondition.allCases, id: \.self) { item in
                            Label(item.rawValue, systemImage: item.icon).tag(item)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(25)
            
            VStack {
                HStack {
                    Label("Watering Days", systemImage: "drop")
                    Spacer()
                    Picker("", selection: $wateringDays) {
                        ForEach(WateringFrequency.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                }
                Divider()
                HStack {
                    Label("Water", systemImage: "drop")
                    Spacer()
                    Picker("", selection: $waterAmount) {
                        ForEach(WaterAmount.allCases, id: \.self) { item in
                            Text(item.rawValue).tag(item)
                        }
                    }
                }
            }
            .padding()
            .background(Color.gray.opacity(0.2))
            .cornerRadius(25)
            
            // Delete button shows only when editing
            if let plant = plant {
                Button {
                    viewModel.deletePlant(plant)
                    dismiss()
                } label: {
                    Text("Delete Reminder")
                        .foregroundColor(.red)
                        .frame(maxWidth: .infinity)
                        .padding()
                        .background(Color.gray.opacity(0.2))
                        .clipShape(Capsule())
                }
            }
            
            Spacer()
        }
        .tint(.gray)
        .padding()
        .onAppear {
            // When editing, fill the fields with the plant's data
            if let plant = plant {
                name = plant.name
                room = plant.room
                light = plant.light
                wateringDays = plant.wateringDays
                waterAmount = plant.waterAmount
            }
        }
        .preferredColorScheme(.dark)
    }
}

#Preview {
    ReminderPage(viewModel: PlantViewModel())
}
