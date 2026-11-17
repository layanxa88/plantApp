import SwiftUI

struct TodayRem: View {
    
    @ObservedObject var viewModel: PlantViewModel
    @State private var showSheet = false
    @State private var selectedPlant: Plant?   
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 20) {
                
                Text("My Plants 🌱")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Divider()
                    .background(Color.gray)
                
                Text("Your plants are waiting for a sip 💦")
                    .foregroundColor(.white)
                
                // Progress bar (scaleEffect makes it thicker)
                ProgressView(value: viewModel.progress)
                    .tint(Color("AccentColor"))
                    .scaleEffect(x: 1, y: 2.5)
                    .padding(.horizontal)
                
                // Plants list
                List(viewModel.plants) { plant in
                    HStack(spacing: 15) {
                        
                        // The circle
                        Button {
                            viewModel.toggleWatered(plant)
                        } label: {
                            Image(systemName: plant.isWatered ? "checkmark.circle.fill" : "circle")
                                .font(.title)
                                .foregroundColor(plant.isWatered ? .green : .white)
                        }
                        .buttonStyle(.plain)   // so only the circle is tappable here
                        
                        VStack(alignment: .leading, spacing: 6) {
                            
                            Label("in \(plant.room.rawValue)", systemImage: "location")
                                .font(.caption)
                                .foregroundColor(.gray)
                            
                            Text(plant.name)
                                .font(.title)
                                .foregroundColor(.white)
                            
                            HStack {
                                Label(plant.light.rawValue, systemImage: plant.light.icon)
                                    .foregroundColor(.yellow)
                                    .padding(6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                                
                                Label(plant.waterAmount.rawValue, systemImage: "drop")
                                    .foregroundColor(.white)
                                    .padding(6)
                                    .background(Color.gray.opacity(0.2))
                                    .cornerRadius(8)
                            }
                            .font(.caption)
                        }
                        .labelStyle(.titleAndIcon)
                        
                        Spacer()
                    }
                    .opacity(plant.isWatered ? 0.5 : 1)   // watered plants look faded
                    .contentShape(Rectangle())            // whole row is tappable
                    .onTapGesture {
                        selectedPlant = plant             // opens the edit sheet
                    }
                    // Swipe left to delete
                    .swipeActions {
                        Button(role: .destructive) {
                            viewModel.deletePlant(plant)
                        } label: {
                            Image(systemName: "trash")
                        }
                    }
                    .listRowBackground(Color.black)
                    .listRowSeparatorTint(Color.gray.opacity(0.5))
                    .alignmentGuide(.listRowSeparatorLeading) { _ in 0 }
                }
                .listStyle(.plain)
            }
            .padding(.vertical)
            
            // + button to add a plant
            Button {
                showSheet = true
            } label: {
                Image(systemName: "plus")
                    .foregroundColor(.white)
                    .frame(width: 44, height: 44)
                    .background(Color("AccentColor"))
                    .clipShape(Circle())
            }
            .padding()
        }
        // Add sheet
        .sheet(isPresented: $showSheet) {
            ReminderPage(viewModel: viewModel)
        }
        // Edit sheet
        .sheet(item: $selectedPlant) { plant in
            ReminderPage(viewModel: viewModel, plant: plant)
        }
    }
}

#Preview {
    let viewModel = PlantViewModel()
    viewModel.addPlant(name: "Monstera", room: .kitchen, light: .fullSun, wateringDays: .everyDay, waterAmount: .small)
    viewModel.addPlant(name: "Pothos", room: .bedroom, light: .fullSun, wateringDays: .everyDay, waterAmount: .small)
    return TodayRem(viewModel: viewModel)
}
