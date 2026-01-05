import SwiftUI

@main
struct Mizan: App {
    @UIApplicationDelegateAdaptor(appdelegate.self) var delegate
    
    var body: some Scene {
        WindowGroup {
            mainview()
                .preferredColorScheme(.dark)
        }
    }
}

class appdelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        locationservice.shared.request()
        notificationservice.shared.request()
        return true
    }
}
