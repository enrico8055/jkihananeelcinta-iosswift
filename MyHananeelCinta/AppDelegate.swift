import UIKit
import FirebaseMessaging
import UserNotifications
import FirebaseDatabase
import FirebaseAuth

final class AppDelegate: NSObject, UIApplicationDelegate {

    func application(_ application: UIApplication,
                     didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {

        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if granted {
                DispatchQueue.main.async {
                    UIApplication.shared.registerForRemoteNotifications()
                    // schedule notif harian
                    self.scheduleDailyRandomVerse()
                }
            }
        }
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Messaging.messaging().apnsToken = deviceToken
        print("APNS token received")
        Messaging.messaging().token { token, error in
            
            guard let token = token else { return }
            print("FCM Token:", token)
            self.saveFCMToken(token)
            
        }
        
        // topik pastor_message
        Messaging.messaging().subscribe(toTopic: "pastor_message") { error in
            if let error = error {
                print("Subscribe error:", error)
            } else {
                print("Subscribed to topic: pastor_message")
            }
        }
        
        // topik device_ios
        Messaging.messaging().subscribe(toTopic: "device_ios") { error in
            if let error = error {
                print("Subscribe error:", error)
            } else {
                print("Subscribed to topic: device_ios")
            }
        }
    }
    
    func saveFCMToken(_ token: String) {
        guard let uid = Auth.auth().currentUser?.uid else {
            print("No user logged in yet")
            return
        }

        Database.database().reference()
            .child("users")
            .child(uid)
            .updateChildValues([
                "fcmToken": token
            ])
    }

    func application(_ application: UIApplication,
                     didFailToRegisterForRemoteNotificationsWithError error: Error) {
        print("APNS error:", error.localizedDescription)
    }
    
    func scheduleDailyRandomVerse() {
        let center = UNUserNotificationCenter.current()
        
        center.removePendingNotificationRequests(withIdentifiers:
            (0...6).map { "dailyVerse_\($0)" }
        )
        
        let verses: [String] = [
            "Kasihilah sesamamu manusia seperti dirimu sendiri. (Mat 22:39)",
            "Segala perkara dapat kutanggung di dalam Dia yang memberi kekuatan. (Flp 4:13)",
            "Percayalah kepada Tuhan dengan segenap hatimu. (Ams 3:5)",
            "Berbahagialah orang yang membawa damai. (Mat 5:9)",
            "Janganlah takut, sebab Aku menyertai engkau. (Yes 41:10)",
            "Berikanlah dan kamu akan menerima. (Luk 6:38)",
            "Tuhan adalah gembalaku, takkan kekurangan aku. (Mzm 23:1)",
            "Hendaklah kamu murah hati, sama seperti Bapamu. (Luk 6:36)",
            "Bersukacitalah senantiasa. (1Tes 5:16)",
            "Serahkanlah segala kekuatiranmu kepada-Nya, sebab Ia memelihara kamu. (1Ptr 5:7)",
            "Mintalah, maka akan diberikan kepadamu. (Mat 7:7)",
            "Damai sejahtera-Ku Kuberikan kepadamu. (Yoh 14:27)",
            "Bertekunlah dalam doa. (Rom 12:12)",
            "Hendaklah kamu kuat dan teguh hati. (1Kor 16:13)",
            "Kasih tidak berkesudahan. (1Kor 13:8)",
            "Carilah dahulu Kerajaan Allah. (Mat 6:33)",
            "Aku datang supaya mereka mempunyai hidup. (Yoh 10:10)",
            "Hidup ini adalah kesempatan untuk melayani. (Gal 5:13)",
            "Hendaklah kamu menjadi terang dunia. (Mat 5:14)",
            "Bersyukurlah dalam segala hal. (1Tes 5:18)",
            "Tetaplah bertekun, jangan menyerah. (Gal 6:9)",
            "Kasih itu sabar, kasih itu murah hati. (1Kor 13:4)",
            "Berjalanlah dalam terang-Nya. (1Yoh 1:7)",
            "Hendaklah hatimu tidak gelisah. (Yoh 14:1)",
            "Setiap hari adalah anugerah dari Tuhan. (Mzm 118:24)",
            "Tuhan adalah perlindunganmu. (Mzm 91:2)",
            "Berpeganglah pada firman-Nya. (Yos 1:8)",
            "Aku memberi kamu kekuatan baru setiap hari. (Yes 40:31)",
            "Janganlah menilai, supaya kamu tidak dinilai. (Mat 7:1)",
            "Kasih itu menutupi segala kesalahan. (1Ptr 4:8)",
            "Biarlah damai Kristus memerintah di hatimu. (Kol 3:15)",
            "Janganlah takut akan hari esok. (Mat 6:34)",
            "Tuhan adalah terang dan keselamatanmu. (Mzm 27:1)",
            "Setiap yang meminta akan menerima. (Mat 7:8)",
            "Hendaklah kamu rendah hati. (Yak 4:10)",
            "Hidup ini singkat, gunakan untuk kebaikan. (Yak 4:14)",
            "Jangan menunda perbuatan baik. (Gal 6:10)",
            "Berikanlah tanpa mengharap balasan. (Luk 6:35)",
            "Hendaklah kamu menjadi garam bumi. (Mat 5:13)",
            "Segala perkara bekerja bersama untuk kebaikan. (Rom 8:28)",
            "Aku senantiasa menyertaimu. (Mat 28:20)",
            "Berpegang pada iman, jangan goyah. (1Kor 15:58)",
            "Kasih Allah sempurna dan kekal. (1Yoh 4:16)",
            "Janganlah bersedih, karena Tuhan dekat. (Mzm 34:18)",
            "Setiap yang berdoa akan didengar. (Mat 21:22)",
            "Berikanlah maaf kepada yang bersalah kepadamu. (Mat 6:14)",
            "Hendaklah kamu hidup kudus. (1Ptr 1:16)",
            "Segala sesuatu yang engkau lakukan, lakukan dengan kasih. (1Kor 16:14)",
            "Jangan takut menghadapi tantangan. (Yes 41:13)",
            "Allah adalah perlindunganmu di saat susah. (Mzm 46:1)",
            "Janganlah kamu kuatir akan hari esok. (Mat 6:34)",
            "Segala yang engkau lakukan, lakukan untuk Tuhan. (Kol 3:23)",
            "Kasihilah musuhmu. (Mat 5:44)",
            "Berpegang pada janji Tuhan. (Ibr 10:23)",
            "Tuhan adalah gembala yang baik. (Yoh 10:11)",
            "Jangan menyerah dalam kesulitan. (Gal 6:9)",
            "Berbahagialah orang yang lapar dan haus akan kebenaran. (Mat 5:6)",
            "Jangan menghakimi orang lain. (Mat 7:1)",
            "Percaya kepada Tuhan dalam segala hal. (Ams 3:5)",
            "Setiap yang meminta akan menerima. (Luk 11:10)",
            "Hidup ini adalah kesempatan untuk memuliakan Tuhan. (1Kor 10:31)",
            "Bersukacitalah selalu di dalam Tuhan. (Fil 4:4)",
            "Hendaklah kamu saling mengasihi. (Yoh 13:34)",
            "Segala perkara dapat dilakukan dengan Dia yang memberi kekuatan. (Fil 4:13)",
            "Bertolonglah satu sama lain. (Gal 6:2)",
            "Janganlah membalas kejahatan dengan kejahatan. (1Ptr 3:9)",
            "Berikanlah yang terbaik dalam segala hal. (Kol 3:23)",
            "Hidup ini adalah pemberian Tuhan. (Mzm 139:13)",
            "Percayalah, Ia menyertai engkau selalu. (Ibr 13:5)",
            "Berpeganglah pada imanmu, jangan goyah. (1Kor 16:13)",
            "Jangan cemas menghadapi masalah. (Fil 4:6)",
            "Berdoalah tanpa henti. (1Tes 5:17)",
            "Berikanlah kepada yang membutuhkan. (Luk 6:30)",
            "Setiap yang memberi akan diberkati. (Ams 11:25)",
            "Kasih itu tidak memandang kesalahan. (1Kor 13:7)",
            "Bersyukurlah dalam segala hal. (1Tes 5:18)",
            "Segala perkara bekerja untuk kebaikanmu. (Rom 8:28)",
            "Berjalanlah di jalan-Nya. (Mzm 119:105)",
            "Hendaklah kamu menjadi terang dunia. (Mat 5:14)",
            "Aku adalah jalan, kebenaran, dan hidup. (Yoh 14:6)",
            "Jangan takut, sebab Aku menyertai engkau. (Yes 41:10)",
            "Berikanlah maaf kepada yang bersalah kepadamu. (Mat 6:14)",
            "Kasih itu sabar dan murah hati. (1Kor 13:4)",
            "Percayalah kepada Tuhan dengan segenap hatimu. (Ams 3:5)",
            "Janganlah menilai orang lain. (Mat 7:1)",
            "Tuhan adalah perlindungan dan kekuatanmu. (Mzm 46:1)",
            "Bersukacitalah dalam Tuhan selalu. (Fil 4:4)",
            "Jangan kuatir menghadapi hari esok. (Mat 6:34)",
            "Berpegang pada firman-Nya. (Yos 1:8)",
            "Segala yang engkau lakukan, lakukan untuk kemuliaan Tuhan. (Kol 3:23)",
            "Jangan membalas kejahatan. (1Ptr 3:9)",
            "Berikan kasihmu tanpa batas. (1Yoh 4:7)",
            "Bertolonglah kepada yang membutuhkan. (Gal 6:2)",
            "Setiap hari adalah anugerah Tuhan. (Mzm 118:24)",
            "Tuhan senantiasa menyertai orang benar. (Mzm 34:7)",
            "Janganlah takut, percayalah kepada-Nya. (Yes 41:10)",
            "Hidup ini adalah kesempatan untuk melayani. (Gal 5:13)",
            "Kasihilah musuhmu dan berdoalah bagi mereka. (Mat 5:44)",
            "Bersukacitalah senantiasa. (1Tes 5:16)",
            "Berjalanlah dalam terang Kristus. (1Yoh 1:7)",
            "Mintalah dan akan diberikan kepadamu. (Mat 7:7)",
            "Damai sejahtera-Ku Kuberikan kepadamu. (Yoh 14:27)",
            "Bertekunlah dalam doa. (Rom 12:12)",
            "Hidup kudus di dalam Tuhan. (1Ptr 1:16)",
            "Kasih itu tidak berkesudahan. (1Kor 13:8)",
            "Carilah Kerajaan Allah terlebih dahulu. (Mat 6:33)",
            "Aku datang supaya mereka mempunyai hidup. (Yoh 10:10)",
            "Hendaklah kamu rendah hati. (Yak 4:10)",
            "Segala perkara dapat kukerjakan di dalam Dia yang memberi kekuatan. (Fil 4:13)",
            "Jangan takut menghadapi tantangan. (Yes 41:13)",
            "Allah adalah perlindungan di saat kesusahan. (Mzm 46:1)",
            "Bersyukurlah dalam segala hal. (1Tes 5:18)",
            "Setiap yang berdoa akan didengar. (Mat 21:22)",
            "Berikan maaf kepada yang bersalah kepadamu. (Mat 6:14)",
            "Berpegang pada janji Tuhan. (Ibr 10:23)",
            "Hidup ini adalah pemberian Tuhan. (Mzm 139:13)",
            "Segala yang engkau lakukan, lakukan dengan kasih. (1Kor 16:14)",
            "Berikan yang terbaik dalam segala hal. (Kol 3:23)",
            "Berjalanlah di jalan-Nya dengan teguh. (Mzm 119:105)",
            "Hidup ini singkat, gunakan untuk kebaikan. (Yak 4:14)",
            "Percaya kepada Tuhan dalam segala hal. (Ams 3:5)",
            "Segala perkara bekerja untuk kebaikan. (Rom 8:28)",
            "Berjalanlah dalam terang-Nya. (1Yoh 1:7)",
            "Bersukacitalah senantiasa di dalam Tuhan. (Fil 4:4)",
            "Segala yang memberi akan diberkati. (Ams 11:25)",
            "Bertolonglah satu sama lain. (Gal 6:2)",
            "Kasih itu menutupi segala kesalahan. (1Ptr 4:8)",
            "Berserah kepada Tuhan, Ia memelihara. (Mzm 55:22)",
            "Percaya dan jangan takut. (Yes 41:10)",
            "Setiap hari adalah kesempatan baru. (Mzm 118:24)",
            "Hidup ini adalah anugerah Tuhan. (Mzm 136:1)",
            "Bersukacitalah, karena Tuhan itu baik. (Mzm 100:5)",
            "Hendaklah kamu menjadi terang bagi sesamamu. (Mat 5:14)",
            "Jangan takut menghadapi masa depan. (Yes 41:13)",
            "Berpegang pada firman Tuhan. (Yos 1:8)",
            "Segala perkara dapat dilakukan dengan-Nya. (Fil 4:13)",
            "Jangan menghakimi, tapi kasihi. (Mat 7:1)",
            "Bersyukurlah dan berikan maaf. (Col 3:13)",
            "Berjalanlah dengan iman, jangan goyah. (1Kor 16:13)",
            "Berikan kasihmu kepada semua orang. (1Yoh 4:11)",
            "Segala perkara bekerja untuk kebaikanmu. (Rom 8:28)",
            "Hidup ini singkat, gunakan untuk memuliakan Tuhan. (1Kor 10:31)",
            "Percayalah kepada Tuhan setiap saat. (Ams 3:5)",
            "Bertolonglah kepada mereka yang membutuhkan. (Gal 6:2)",
            "Jangan takut, karena Ia menyertai selalu. (Yes 41:10)",
            "Kasihilah musuhmu, berdoalah bagi mereka. (Mat 5:44)",
            "Segala perkara yang kamu lakukan, lakukan dengan kasih. (1Kor 16:14)",
            "Bersukacitalah selalu di dalam Tuhan. (Fil 4:4)",
            "Jangan cemas menghadapi hari esok. (Mat 6:34)",
            "Hidup ini adalah kesempatan untuk melayani sesama. (Gal 5:13)",
            "Berikan yang terbaik dalam pekerjaanmu. (Kol 3:23)",
            "Hendaklah kamu rendah hati dan sabar. (Yak 4:10)",
            "Berjalanlah dalam terang Kristus. (1Yoh 1:7)",
            "Mintalah, maka akan diberikan kepadamu. (Mat 7:7)",
            "Damai sejahtera-Ku Kuberikan kepadamu. (Yoh 14:27)",
            "Bertekunlah dalam doa. (Rom 12:12)",
            "Hidup kudus dan jangan menyerah. (1Ptr 1:16)",
            "Kasih itu sempurna dan abadi. (1Kor 13:8)",
            "Carilah Kerajaan Allah terlebih dahulu. (Mat 6:33)",
            "Aku datang supaya mereka mempunyai hidup. (Yoh 10:10)"
        ]
        
        for day in 0...6 {
            let content = UNMutableNotificationContent()
            content.title = "Ayat Untukmu Hari Ini :)"
            content.body = verses[day % verses.count]
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 8
            dateComponents.minute = 0
            
            // jadwalkan per hari berbeda
            let calendar = Calendar.current
            let targetDate = calendar.date(byAdding: .day, value: day, to: Date())!
            dateComponents.day = calendar.component(.day, from: targetDate)
            dateComponents.month = calendar.component(.month, from: targetDate)
            dateComponents.year = calendar.component(.year, from: targetDate)
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: false)
            let request = UNNotificationRequest(
                identifier: "dailyVerse_\(day)",
                content: content,
                trigger: trigger
            )
            
            center.add(request) { error in
                if let error = error {
                    print("Error scheduling day \(day): \(error)")
                }
            }
        }
    }
}
