//
//  ActivateView.swift
//  HMTrading
//
//  Created by Kirill Kubarskiy on 17.05.23.
//

import SwiftUI
import UserNotifications

struct ActivateView: View {
    @State private var notificationAuthorizationStatus = UNAuthorizationStatus.notDetermined
    @State private var isActivated = false

    var body: some View {
        Group {
            if isActivated {
                MainView()
            } else {
                VStack {


                    Spacer()

                    Button(action: activateNow) {
                        Text("Activate now")
                            .foregroundColor(.white)
                            .frame(height: 54)
                            .frame(maxWidth: .infinity)
                            .background(Color(hex: "#35B972"))
                            .cornerRadius(12)
                    }
                    .padding()
                }
                .onAppear {
                    requestNotificationAuthorization()
                }
                .background(Image("bg"))
            }
        }
    }

    private func requestNotificationAuthorization() {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { granted, error in
            if let error = error {
                print("Notification authorization failed: \(error)")
            } else {
                notificationAuthorizationStatus = granted ? .authorized : .denied
            }
        }
    }

    private func activateNow() {
        isActivated = true
    }
}



struct ActivateView_Previews: PreviewProvider {
    static var previews: some View {
        ActivateView()
    }
}
