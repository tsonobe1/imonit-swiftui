import Foundation
import Combine

/// Represents a goal with its associated properties and hierarchy.
class Goal: ObservableObject, Identifiable {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
    var parentGoal: Goal?
    @Published var childGoals: [Goal] = []

    /// Initializes a new goal with specified properties.
    /// - Parameters:
    ///   - title: The title of the goal.
    ///   - description: The description of the goal.
    ///   - startDate: The start date of the goal.
    ///   - endDate: The end date of the goal.
    init(title: String, description: String, startDate: Date, endDate: Date) {
        self.title = title
        self.description = description
        self.startDate = startDate
        self.endDate = endDate
    }

    /// Adds a child goal to the list of child goals.
    /// - Parameter goal: The child goal to be added.
    func addChildGoal(_ goal: Goal) {
        childGoals.append(goal)
        goal.parentGoal = self
    }
}

/// Stores and manages a collection of goals.
class GoalsData: ObservableObject {
    @Published var goals: [Goal] = []

    /// Initializes GoalsData with a collection of goals.
    /// - Parameter goals: The initial collection of goals.
    init(goals: [Goal]) {
        self.goals = goals
    }
}

/// Creates a nested goal structure with specified parameters.
func createNestedGoals(maxDepth: Int, maxPerLevel: Int, currentDepth: Int = 0) -> Goal {
    let title = "Lorem ipsum dolor sit amet, consectetur adipiscing elit \(currentDepth + 1)"
    let description = "But I must explain to you how all this mistaken idea of denouncing pleasure and praising pain was born and I will give you a complete account of the system, and expound the actual teachings of the great explorer of the truth \(currentDepth + 1)"
    let startDate = Date()
    let endDate = Date(timeIntervalSinceNow: 86400 * Double(currentDepth + 1))
    
    let newGoal = Goal(title: title, description: description, startDate: startDate, endDate: endDate)
    
    if currentDepth < maxDepth {
        let childCount = Int.random(in: 0...maxPerLevel)
        for _ in 0..<childCount {
            let childGoal = createNestedGoals(maxDepth: maxDepth, maxPerLevel: maxPerLevel, currentDepth: currentDepth + 1)
            newGoal.addChildGoal(childGoal)
        }
    }
    
    return newGoal
}

/// Creates a collection of top-level goals.
func createTopLevelGoals(count: Int, maxDepth: Int, maxPerLevel: Int) -> [Goal] {
    return (0..<count).map { _ in
        createNestedGoals(maxDepth: maxDepth, maxPerLevel: maxPerLevel)
    }
}




struct Schedule {
    var title: String
    var description: String
    var startDate: Date
    var endDate: Date
}

func createEvents() -> [Schedule] {
    var schedules = [Schedule]()
    
    // イベント1
    let event1 = Schedule(
        title: "誕生日パーティー",
        description: "友達の誕生日パーティー",
        startDate: Date(timeIntervalSinceNow: 3600), // 1時間後
        endDate: Date(timeIntervalSinceNow: 7200)    // 2時間後
    )
    
    // イベント2
    let event2 = Schedule(
        title: "会議",
        description: "プロジェクトの進捗についての会議",
        startDate: Date(timeIntervalSinceNow: 86400), // 1日後
        endDate: Date(timeIntervalSinceNow: 90000)    // 1日と1時間後
    )
    
    // イベント3
    let event3 = Schedule(
        title: "ディナー1",
        description: "家族ディナー1",
        startDate: Date(timeIntervalSinceNow: 43200), // 12時間後
        endDate: Date(timeIntervalSinceNow: 46800)    // 13時間後
    )
    
    let event4 = Schedule(
        title: "ディナー2",
        description: "家族ディナー2",
        startDate: Date(timeIntervalSinceNow: 7200), // 12時間後
        endDate: Date(timeIntervalSinceNow: 10800)    // 13時間後
    )
    
    let event5 = Schedule(
        title: "ディナー3",
        description: "家族ディナー3",
        startDate: Date(timeIntervalSinceNow: 10800), // 12時間後
        endDate: Date(timeIntervalSinceNow: 14400)    // 13時間後
    )
    
    let event6 = Schedule(
        title: "ディナー4",
        description: "家族ディナー4",
        startDate: Date(timeIntervalSinceNow: 19800), // 12時間後
        endDate: Date(timeIntervalSinceNow: 21600)    // 13時間後
    )
    
    // イベントを配列に追加
    schedules.append(contentsOf: [event1, event2, event3,event4,event5,event6])
    
    return schedules
}
