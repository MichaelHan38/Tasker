import Foundation

class TodoItemStore {
    private var todoItems: [TodoItem] = [TodoItem(title: "Feed cats", isDone: false)]
    
    var count: Int {
        return todoItems.count
    }
    
    func item(forIndexPath indexPath: IndexPath) -> TodoItem? {
        return todoItems[indexPath.row]
    }
    
    func delete(atIndexPath indexPath: IndexPath) {
        todoItems.remove(at: indexPath.row)
    }
    
    func markDone(atIndexPath indexPath: IndexPath) {
        todoItems[indexPath.row].isDone = true
    }
    
    func insert(todoItem: TodoItem) -> IndexPath {
        todoItems.append(todoItem)
        
        return IndexPath(row:todoItems.count - 1, section: 0)
    }
}
