import SwiftUI

struct NoRemindersPage: View {
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
                
                Text("No reminders set yet..")
                    .font(.headline)
                    .foregroundColor(.gray)
                
                Spacer()
            }
            .padding(.vertical)
        }
    }
}

#Preview {
    NoRemindersPage()
}
