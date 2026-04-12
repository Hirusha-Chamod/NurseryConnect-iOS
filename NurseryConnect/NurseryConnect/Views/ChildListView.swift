import SwiftUI
import SwiftData

struct ChildListView: View {
    // 1. The Context: Used to insert or delete data
    @Environment(\.modelContext) private var modelContext
    
    // For this MVP, we simulate that "Sarah" (ID: KW-001) is the logged-in Keyworker
    let currentKeyworkerID = "KW-001"
    
    // 2. The Query: Fetches children from the local database
    @Query private var assignedChildren: [Child]
    
    // 3. GDPR Data Minimisation: We override the initialization to filter the query.
    // The Keyworker ONLY sees children assigned to them.
    init() {
        let filterID = "KW-001"
        _assignedChildren = Query(filter: #Predicate<Child> { child in
            child.assignedKeyworkerID == filterID
        }, sort: \.firstName)
    }
    
    var body: some View {
        NavigationStack {
            List {
                if assignedChildren.isEmpty {
                    ContentUnavailableView("No Children Assigned", systemImage: "person.2.slash", description: Text("Tap the + button to add a test child to your roster."))
                } else {
                    ForEach(assignedChildren) { child in
                        
                        // Wires up the Navigation to the Hub Screen (ChildDetailView)
                        NavigationLink(destination: ChildDetailView(child: child)) {
                            VStack(alignment: .leading, spacing: 4) {
                                Text("\(child.firstName) \(child.lastName)")
                                    .font(.headline)
                                
                                // Highlighting allergies ensures compliance with FSA safety guidelines
                                Text("Allergies: \(child.allergies)")
                                    .font(.subheadline)
                                    .foregroundColor(child.allergies == "None" ? .secondary : .red)
                                    .bold(child.allergies != "None")
                            }
                            .padding(.vertical, 4)
                        }
                        
                    }
                    .onDelete(perform: deleteChild) // Swipe to delete functionality
                }
            }
            .navigationTitle("My Room Roster")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: addMockChild) {
                        Image(systemName: "plus.circle.fill")
                            .font(.title2)
                    }
                }
            }
        }
    }
    
    // MARK: - MVP Testing Helpers
    
    private func addMockChild() {
        // Creates a mock child assigned to this keyworker to test the UI
        let newChild = Child(
            firstName: "Leo",
            lastName: "Smith",
            dateOfBirth: Calendar.current.date(byAdding: .year, value: -3, to: Date()) ?? Date(),
            allergies: "Dairy Intolerance",
            assignedKeyworkerID: currentKeyworkerID
        )
        modelContext.insert(newChild) // Saves to SwiftData!
    }
    
    private func deleteChild(offsets: IndexSet) {
        for index in offsets {
            modelContext.delete(assignedChildren[index])
        }
    }
}

#Preview {
    ChildListView()
        // Adds an in-memory database just for the Xcode Preview canvas
        .modelContainer(for: [Child.self, DailyLog.self, Incident.self], inMemory: true)
}
