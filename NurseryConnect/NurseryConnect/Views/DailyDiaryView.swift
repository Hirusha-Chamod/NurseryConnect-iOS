import SwiftUI
import SwiftData

struct DailyDiaryView: View {
    @Environment(\.modelContext) private var modelContext
    let child: Child
    
    // 🔥 Your MVP Upgrade: State variable to drive the Date Filter
    @State private var filterDate: Date = Date()
    @State private var showingAddEntrySheet = false
    
    // Advanced Swift Concept: Computed property to dynamically filter logs
    var filteredLogs: [DailyLog] {
        child.dailyLogs.filter { log in
            Calendar.current.isDate(log.timestamp, inSameDayAs: filterDate)
        }.sorted { $0.timestamp > $1.timestamp } // Sort newest first
    }
    
    var body: some View {
        VStack {
            // MARK: - The Date Filter UI
            DatePicker(
                "Filter by Date",
                selection: $filterDate,
                displayedComponents: .date
            )
            .datePickerStyle(.compact)
            .padding()
            .background(Color(UIColor.secondarySystemBackground))
            .cornerRadius(10)
            .padding(.horizontal)
            
            // MARK: - The Filtered List
            List {
                if filteredLogs.isEmpty {
                    ContentUnavailableView(
                        "No Entries",
                        systemImage: "doc.text.magnifyingglass",
                        description: Text("No diary logs found for this date.")
                    )
                } else {
                    ForEach(filteredLogs) { log in
                        VStack(alignment: .leading, spacing: 6) {
                            HStack {
                                Text(log.activityType)
                                    .font(.headline)
                                    .foregroundColor(.blue)
                                Spacer()
                                Text(log.timestamp, format: .dateTime.hour().minute())
                                    .font(.caption)
                                    .foregroundColor(.secondary)
                            }
                            Text(log.details)
                                .font(.subheadline)
                        }
                        .padding(.vertical, 4)
                    }
                    .onDelete(perform: deleteLog)
                }
            }
        }
        .navigationTitle("Daily Diary")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: { showingAddEntrySheet = true }) {
                    Image(systemName: "plus")
                }
            }
        }
        // MARK: - The Slide-Up Form
        .sheet(isPresented: $showingAddEntrySheet) {
            AddDiaryEntryView(child: child)
        }
    }
    
    private func deleteLog(offsets: IndexSet) {
        for index in offsets {
            let logToDelete = filteredLogs[index]
            modelContext.delete(logToDelete)
        }
    }
}

// MARK: - Add Entry Sub-View
struct AddDiaryEntryView: View {
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss
    
    let child: Child
    
    @State private var activityType: String = "Meal"
    @State private var details: String = ""
    
    // Categories matching the EYFS Case Study requirements
    let categories = ["Arrival Check-In", "Activity", "Sleep / Nap", "Meal", "Nappy / Toilet", "Wellbeing Check", "Departure"]
    
    var body: some View {
        NavigationStack {
            Form {
                Section(header: Text("Log Details")) {
                    Picker("Activity Type", selection: $activityType) {
                        ForEach(categories, id: \.self) { category in
                            Text(category).tag(category)
                        }
                    }
                    
                    TextField("Add details (e.g., Ate full portion, Slept 1hr)", text: $details, axis: .vertical)
                        .lineLimit(3...6)
                }
            }
            .navigationTitle("New Diary Entry")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancel") { dismiss() }
                }
                ToolbarItem(placement: .confirmationAction) {
                    Button("Save") {
                        saveEntry()
                    }
                    .disabled(details.isEmpty)
                }
            }
        }
    }
    
    private func saveEntry() {
        let newLog = DailyLog(activityType: activityType, details: details)
        newLog.child = child // Establish the relationship in SwiftData
        modelContext.insert(newLog)
        dismiss()
    }
}
