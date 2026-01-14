import UIKit
import FirebaseMessaging

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNS token received")

        Messaging.messaging().token { token, error in
            print("FCM Token:", token ?? "")
        }
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNS error:", error.localizedDescription)
    }
}
