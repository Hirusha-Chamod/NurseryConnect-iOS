import SwiftUI
import SwiftData

struct ChildDetailView: View {
    // We pass in the specific child selected from the roster
    let child: Child
    
    var body: some View {
        Form {
            // MARK: - Safety Information (FSA & Safeguarding Compliance)
            Section(header: Text("Safety & Health Alerts")) {
                LabeledContent("Allergies", value: child.allergies)
                    // High-contrast warning for severe allergies
                    .foregroundColor(child.allergies != "None" ? .red : .primary)
                    .bold(child.allergies != "None")
                
                LabeledContent("Date of Birth", value: child.dateOfBirth, format: .dateTime.year().month().day())
            }
            
            // MARK: - Core Feature Navigation
            Section(header: Text("Keyworker Actions")) {
                
                
                // Route 1: The Daily Diary (Feature 1)
                NavigationLink {
                    DailyDiaryView(child: child) // <--- Update this line!
                } label: {
                    Label("Log Daily Diary", systemImage: "book.pages.fill")
                        .foregroundColor(.blue)
                        .padding(.vertical, 4)
                }
                
                // Route 2: The Incident Report (Feature 2)
                NavigationLink {
                    IncidentReportView(child: child) // <--- Update this line!
                } label: {
                    Label("Report Incident", systemImage: "exclamationmark.triangle.fill")
                        .foregroundColor(.orange)
                        .padding(.vertical, 4)
                }
            }
        }
        .navigationTitle("\(child.firstName) \(child.lastName)")
        .navigationBarTitleDisplayMode(.inline)
    }
}
