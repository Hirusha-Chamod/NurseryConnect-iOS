import SwiftUI
import SwiftData

@main
struct NurseryConnectApp: App {
    var body: some Scene {
        WindowGroup {
            ChildListView()
        }
        // This is the magic line! It creates the local SQLite database for these models.
        .modelContainer(for: [Child.self, DailyLog.self, Incident.self])
    }
}
