import SwiftUI
import Combine
import ComposableArchitecture
import Log4swift

@main
struct Main: App {
    let store: Store<AppState, AppAction>

    init() {
        let IDDLogLogFileName: String? = {
            if UserDefaults.standard.bool(forKey: "standardLog") {
                // Log4swift.getLogger("Application").info("Starting as normal process (not a daemon) ...")
                return nil
            } else {
                // Log4swift.getLogger("Application").info("Starting as daemon ...")
                return URL(fileURLWithPath: NSHomeDirectory()).appendingPathComponent("Library/Logs/iFont.log").path
            }
        }()

        // IDDLogLoadConfigFromPath(Bundle.main.path(forResource: "IDDLog", ofType: "plist"))
        Log4swiftConfig.configureLogs(defaultLogFile: IDDLogLogFileName, lock: "IDDLogLock")
        
        Log4swift[Self.self].info("starting app")
        self.store = AppState.liveStore
    }

    var body: some Scene {
        WindowGroup {
            AppView(store: store)
        }
    }
}
