import Foundation

struct TodoItem {
    let date: Date
    let title: String
    var isDone: Bool
}

struct DailyTodo {
    var list: [String : TodoItem]
}

class TodoDict {
    // dailyTaskDict is a dictionary that groups and maps daily todo items
    var dailyTaskDict: [String: DailyTodo] = [:]
    
    func put(todoItem: TodoItem) {
        let date = shortenDate(todoItem.date)
        
        // Insert todoItem to existing DailyTodo. Otherwise
        // create a new DailyTodo with the todoItem as the only element
        if var dailyTodos = dailyTaskDict[date] {
            
            // prevent multiple tasks with the same name on the same day
            if let _ = dailyTodos.list[todoItem.title] {
                print(self.dailyTaskDict[date]?.list ?? "a" as String)
                return
            } else {
                // Force unwrap because dailyTaskDict[date] can never be empty when this part executes
                self.dailyTaskDict[date]!.list[todoItem.title] = todoItem
            }
            
        } else {
            dailyTaskDict[date] = DailyTodo(list: [todoItem.title: todoItem])
        }
        print(self.dailyTaskDict[date]?.list ?? "Not Found" as String)
    }
    
    func get(todosOn date: String) {
        
    }
    
    func delete(_ todoItem: TodoItem ) {
        
    }
    
    func markDone(_ todoItem: TodoItem) {
        
    }

}

// shortenDate converts a Date object into a "mm/dd/yy" formatted string
private func shortenDate(_ date: Date) -> String {
    let formatter = DateFormatter()
    formatter.timeZone = .current
    formatter.dateStyle = .short
    formatter.timeStyle = .none
    
    return formatter.string(from: date)
}
