import SwiftUI
import Firebase
import FirebaseAuth
import FirebaseMessaging
import UserNotifications

@main
struct _MyHananeelCintaApp: App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @AppStorage("isLoggedIn") var isLoggedIn: Bool = false
    @State private var showSplash: Bool = true

    init() {
        FirebaseApp.configure()
        Messaging.messaging().delegate = MessagingDelegateHandler.shared
        UNUserNotificationCenter.current().delegate = NotificationDelegate.shared

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            print("Permission granted:", granted)
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                }
            }
        }
    }

    var body: some Scene {
        WindowGroup {
            ZStack {

                Group {
                    if isLoggedIn {
                        ContentView()
                    } else {
                        NavigationView {
                            LoginView()
                        }
                        .navigationViewStyle(StackNavigationViewStyle())
                    }
                }
                .opacity(showSplash ? 0 : 1)

                if showSplash {
                    ZStack {
                        LinearGradient(
                            colors: [
                                Color(red: 40/255, green: 40/255, blue: 40/255),
                                Color(red: 20/255, green: 20/255, blue: 20/255)
                            ],
                            startPoint: .top,
                            endPoint: .bottom
                        )
                        .ignoresSafeArea()

                        VStack(spacing: 16) {
                            Spacer()

                            Image("AppLogo")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 150, height: 150)
                                .clipShape(RoundedRectangle(cornerRadius: 24))
                                .shadow(color: .black.opacity(0.4), radius: 10, y: 5)
                                .scaleEffect(showSplash ? 1 : 0.85)
                                .opacity(showSplash ? 1 : 0)

                            Text("My Hananeel Cinta")
                                .foregroundColor(.orange)
                                .font(.system(size: 26, weight: .bold))
                                .opacity(showSplash ? 1 : 0)

                            Spacer()

                            VStack(spacing: 6) {
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .orange))

                                Text("Version 1.2")
                                    .foregroundColor(.orange.opacity(0.8))
                                    .font(.footnote)
                            }
                            .padding(.bottom, 30)
                        }
                        .transition(.opacity)
                    }
                    .zIndex(1)
                    .onAppear {
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1.6) {
                            withAnimation(.easeInOut(duration: 0.45)) {
                                showSplash = false
                            }
                        }
                    }
                }
            }
        }
    }
}

class MessagingDelegateHandler: NSObject, MessagingDelegate {
    static let shared = MessagingDelegateHandler()

    func messaging(_ messaging: Messaging, didReceiveRegistrationToken fcmToken: String?) {
        print("FCM Token:", fcmToken ?? "")
    }
}
