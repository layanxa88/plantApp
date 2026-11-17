import SwiftUI

struct DonePage: View {
    @ObservedObject var viewModel: PlantViewModel
    @State private var showSheet = false
    
    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()
            
            VStack(spacing: 25) {
                
                Text("My Plants 🌱")
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
                
                Text("All Done! 🎉")
                    .font(.title2)
                    .bold()
                    .foregroundColor(.white)
                
                Text("All Reminders Completed")
                    .font(.subheadline)
                    .foregroundColor(.gray)
                
                Spacer()
                Spacer()
            }
            .padding(.vertical)
            
            // Add button (bottom right)
            VStack {
                Spacer()
                HStack {
                    Spacer()
                    Button {
                        showSheet = true
                    } label: {
                        Image(systemName: "plus")
                            .font(.title2)
                            .foregroundColor(.white)
                            .frame(width: 50, height: 50)
                            .background(Color("AccentColor"))
                            .clipShape(Circle())
                    }
                    .padding(.trailing, 20)
                    .padding(.bottom, 30)
                }
            }
        }
        .sheet(isPresented: $showSheet) {
            ReminderPage(viewModel: viewModel)
        }
    }
}

#Preview {
    DonePage(viewModel: PlantViewModel())
}
