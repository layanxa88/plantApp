import SwiftUI

struct ContentView: View {
    
    @StateObject var viewModel = PlantViewModel()
    
    @State private var showSheet = false
    @State private var showNoReminders = false
    
    var body: some View {
        ZStack {
            
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Text("My Plants 🌿")
                    .font(.system(size: 34, weight: .bold))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .padding(.horizontal)
                
                Divider()
                    .background(Color.gray)
                
                Spacer()
                
                Image("Image")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 164, height: 200)
                
                Text("Start your plant journey!")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text("Now all your plants will be in one place and\nwe will help you take care of them :) 🪴")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                    .multilineTextAlignment(.center)
                
                Spacer()
                
                Button {
                    showSheet = true
                } label: {
                    Text("Set Plant Reminder")
                        .font(.headline)
                        .foregroundColor(.white)
                        .frame(width: 280, height: 42)
                        .background(Color("AccentColor"))
                        .cornerRadius(12)
                }
                .padding(.bottom, 200)
            }
            .padding(.vertical)
            
            if showNoReminders {
                NoRemindersPage()
            }
            
            if !viewModel.plants.isEmpty {
                TodayRem(viewModel: viewModel)
            }
            
            if viewModel.allDone {
                DonePage(viewModel: viewModel)
            }
        }
        .sheet(isPresented: $showSheet, onDismiss: {
            if viewModel.plants.isEmpty {
                showNoReminders = true
            }
        }) {
            ReminderPage(viewModel: viewModel)
        }
        .preferredColorScheme(.dark)
        .onAppear {
            viewModel.requestPermission()
        }
    }
}

#Preview {
    ContentView()
}
