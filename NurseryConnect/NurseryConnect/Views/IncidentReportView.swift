import SwiftUI
import SwiftData

struct IncidentReportView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss // Used to close the screen after saving
    
    let child: Child // The child this incident belongs to
    
    // State variables to hold the form data before saving
    @State private var dateOccurred: Date = Date()
    @State private var location: String = ""
    @State private var incidentDescription: String = ""
    @State private var actionTaken: String = ""
    
    // 🔥 Your EYFS Compliance Upgrade!
    @State private var isReportedToParent: Bool = false
    
    var body: some View {
        Form {
            Section(header: Text("Incident Details")) {
                DatePicker("Date & Time", selection: $dateOccurred)
                
                TextField("Location (e.g., Outdoor Play Area)", text: $location)
                
                // A larger text box for the description
                TextField("Description of Incident", text: $incidentDescription, axis: .vertical)
                    .lineLimit(3...6)
            }
            
            Section(header: Text("Response & First Aid")) {
                TextField("Action Taken / First Aid Applied", text: $actionTaken, axis: .vertical)
                    .lineLimit(2...4)
            }
            
            // MARK: - Regulatory Compliance Section
            Section(header: Text("EYFS Compliance"), footer: Text("EYFS statutory framework requires parents to be notified of accidents on the same day.")) {
                Toggle(isOn: $isReportedToParent) {
                    VStack(alignment: .leading) {
                        Text("Reported to Parent")
                            .font(.headline)
                        Text(isReportedToParent ? "Notification confirmed." : "Pending notification.")
                            .font(.caption)
                            .foregroundColor(isReportedToParent ? .green : .red)
                    }
                }
                .tint(.green)
            }
            
            Section {
                Button(action: saveIncident) {
                    Text("Submit Incident Report")
                        .frame(maxWidth: .infinity, alignment: .center)
                        .bold()
                        .foregroundColor(.white)
                }
                .listRowBackground(isFormValid ? Color.red : Color.gray)
                .disabled(!isFormValid)
            }
        }
        .navigationTitle("Report Incident")
        .navigationBarTitleDisplayMode(.inline)
    }
    
    // MARK: - Validation
    // Ensures the keyworker doesn't submit an empty report
    private var isFormValid: Bool {
        !location.isEmpty && !incidentDescription.isEmpty && !actionTaken.isEmpty
    }
    
    // MARK: - Save Logic
    private func saveIncident() {
        let newIncident = Incident(
            dateOccurred: dateOccurred,
            location: location,
            incidentDescription: incidentDescription,
            actionTaken: actionTaken,
            isReportedToParent: isReportedToParent
        )
        
        // Link the incident to the specific child
        newIncident.child = child
        
        // Save to local database
        modelContext.insert(newIncident)
        
        // Go back to the previous screen
        dismiss()
    }
}
