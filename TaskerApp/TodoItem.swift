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
        // format a TodoItem's date into a string
        let formatter = DateFormatter()
        formatter.timeZone = .current
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        let date = formatter.string(from: todoItem.date)
        
        // Insert todoItem to existing DailyTodo. Otherwise create a new DailyTodo with one element: todoItem
        if var allTodos = dailyTaskDict[date] {
            // prevent multiple tasks with the same name that day
            if let _ = allTodos.list[todoItem.title] {
                print(self.dailyTaskDict[date]?.list ?? "a" as String)
                return
            } else {
                // Force unwrap because data[key] can never be empty when this part executes
                self.dailyTaskDict[date]!.list[todoItem.title] = todoItem
            }
            
        } else {
            dailyTaskDict[date] = DailyTodo(list: [todoItem.title: todoItem])
        }
        print(self.dailyTaskDict[date]?.list ?? "Not Found" as String)
    }
}
