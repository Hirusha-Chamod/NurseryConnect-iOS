import Foundation
import SwiftData

// MARK: - Child Model
@Model
final class Child {
    var id: UUID
    var firstName: String
    var lastName: String
    var dateOfBirth: Date
    var allergies: String // e.g., "Nut allergy - EpiPen required"
    var assignedKeyworkerID: String // GDPR: Ensures we only fetch children for the logged-in keyworker
    
    // Relationships: If a child is deleted cascade delete their logs
    @Relationship(deleteRule: .cascade) var dailyLogs: [DailyLog] = []
    @Relationship(deleteRule: .cascade) var incidents: [Incident] = []
    
    init(firstName: String, lastName: String, dateOfBirth: Date, allergies: String = "None", assignedKeyworkerID: String) {
        self.id = UUID()
        self.firstName = firstName
        self.lastName = lastName
        self.dateOfBirth = dateOfBirth
        self.allergies = allergies
        self.assignedKeyworkerID = assignedKeyworkerID
    }
}

// MARK: - Daily Diary Model
@Model
final class DailyLog {
    var id: UUID
    var timestamp: Date
    var activityType: String 
    var details: String
    
    // Reference back to the child
    var child: Child?
    
    init(timestamp: Date = Date(), activityType: String, details: String) {
        self.id = UUID()
        self.timestamp = timestamp
        self.activityType = activityType
        self.details = details
    }
}

// MARK: - Incident Model
@Model
final class Incident {
    var id: UUID
    var dateOccurred: Date
    var location: String
    var incidentDescription: String
    var actionTaken: String
    

    var isReportedToParent: Bool
    
    // Reference back to the child
    var child: Child?
    
    init(dateOccurred: Date = Date(), location: String, incidentDescription: String, actionTaken: String, isReportedToParent: Bool = false) {
        self.id = UUID()
        self.dateOccurred = dateOccurred
        self.location = location
        self.incidentDescription = incidentDescription
        self.actionTaken = actionTaken
        self.isReportedToParent = isReportedToParent
    }
}
