import Foundation
import CoreData

struct TodoItem {
    let date: Date
    let title: String
    var isDone: Bool
}

class TodoItemStore {
    private var todoItems: [TodoItem] = [
//        TodoItem(title: "Feed cats", isDone: false),
    ]
    
    private lazy var container: NSPersistentContainer = {
        let container = NSPersistentContainer(name: "TodoItems")
        container.loadPersistentStores{ (_, error: Error?) in
            if let error = error {
                fatalError("Could not load persistence stores")
            }
        }
        return container
    }()
    
    var count: Int {
        return todoItems.count
    }
    
    func load() {
        let request = TodoItemEntity.fetchRequest()
        
        let context = container.viewContext
        
        do {
            let results = try context.fetch(request)
            let todoItems: [TodoItem] = results.compactMap { (todoItemEntry : TodoItemEntity) in
                guard let title = todoItemEntry.title, let date = todoItemEntry.date
                else {
                    return nil
                }
                return TodoItem(date: date, title: title, isDone: todoItemEntry.isDone)
            }
            self.todoItems = todoItems
        } catch {
            print(error)
        }
    }
    
    func item(forIndexPath indexPath: IndexPath) -> TodoItem? {
        return todoItems[indexPath.row]
    }
    
    func delete(atIndexPath indexPath: IndexPath) {
        let title = todoItems[indexPath.row].title
        todoItems.remove(at: indexPath.row)
        
        // Save changes to core data
        var todoItem: TodoItemEntity!
        let context = container.viewContext
        
        let fetchTodoItem: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        fetchTodoItem.predicate = NSPredicate(format: "title == %@", title)
        
        let results = try? context.fetch(fetchTodoItem)
        if results?.count == 1 {
            
        }
        todoItem = results?.first
        context.delete(todoItem)
//        todoItem.isDone = !todoItem.isDone
        do {
            try context.save()
        } catch {}
    }
    
    func markDone(atIndexPath indexPath: IndexPath) {
        todoItems[indexPath.row].isDone = !todoItems[indexPath.row].isDone
        let title = todoItems[indexPath.row].title
        
        // Save changes to core data
        var todoItem: TodoItemEntity!
        let context = container.viewContext
        
        let fetchTodoItem: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        fetchTodoItem.predicate = NSPredicate(format: "title == %@", title)
        
        let results = try? context.fetch(fetchTodoItem)
        if results?.count == 1 {
            
        }
        todoItem = results?.first
        todoItem.isDone = !todoItem.isDone
        do {
            try context.save()
        } catch {}
    }
    
    func insert(todoItem: TodoItem) -> IndexPath {
        todoItems.append(todoItem)
        
        let context = container.viewContext
        
        let managedObject = TodoItemEntity(context: context)
        managedObject.date = todoItem.date
        managedObject.title = todoItem.title
        managedObject.isDone = todoItem.isDone
        
        do {
            try context.save()
        } catch {
            
        }
        
        return IndexPath(row:todoItems.count - 1, section: 0)
    }
    
    private func save() {
        
        
    }
}
