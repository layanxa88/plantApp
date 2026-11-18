import SwiftUI

struct ContentView: View {

    @StateObject var viewModel = PlantViewModel()

    @State private var showSheet = false
    @State private var showNoReminders = false

    var body: some View {
        ZStack {
            Color.black.ignoresSafeArea()

            // 1. إذا فيه وردات وكلها مسقية -> All Done Page
            if !viewModel.plants.isEmpty && viewModel.allDone {
                DonePage(viewModel: viewModel)

            }
            // 2. إذا فيه وردات باقي ما انسقت -> Main Page (TodayRem)
            else if !viewModel.plants.isEmpty {
                TodayRem(viewModel: viewModel)

            }
            // 3. إذا قفل صفحة الإضافة بـ X وما أضاف شيء، أو حذف كل ورداته -> NoRemindersPage
            else if showNoReminders {
                NoRemindersPage(viewModel: viewModel)

            }
            // 4. أول واجهة تظهر للمستخدم الجديد (Start Page)
            else {
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
            }
        }
        // فتح صفحة إضافة التذكير
        .sheet(isPresented: $showSheet, onDismiss: {
            // إذا ضغط X والقائمة لسا فاضية -> يروح لـ NoRemindersPage
            if viewModel.plants.isEmpty {
                showNoReminders = true
            }
        }) {
            ReminderPage(viewModel: viewModel)
        }
        // مراقبة الحذف: أول ما تنحذف آخر وردة وتصير القائمة 0 -> يروح لـ NoRemindersPage
        .onChange(of: viewModel.plants.count) { oldCount, newCount in
            if newCount == 0 {
                showNoReminders = true
            }
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

