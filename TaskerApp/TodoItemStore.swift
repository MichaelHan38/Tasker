import Foundation
import CoreData

struct TodoItem {
    let date: Date
    let title: String
    var isDone: Bool
}

class TodoItemStore {
    private var todoItems: [TodoItem] = []
    private static var _model: NSManagedObjectModel?
    
    
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
    
    func load(todoItemsOn date: Date) {
        // Set date for querying
        let calendar = Calendar.current
        let today = date
        let startDate = calendar.startOfDay(for: today)
        let endDate = calendar.date(byAdding: DateComponents(day: 1), to: startDate)
        
        let request: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        request.predicate = NSPredicate(format: "date >= %@ AND date <= %@", argumentArray: [startDate, endDate])
        
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
        let result = fetchTodoItem(fromRow: indexPath.row)
        
        result.context.delete(result.entity)
        do {
            try result.context.save()
            todoItems.remove(at: indexPath.row)
        } catch {}
    }
    
    func markDone(atIndexPath indexPath: IndexPath) {
        let result = fetchTodoItem(fromRow: indexPath.row)

        result.entity.isDone = !result.entity.isDone
        do {
            try result.context.save()
            todoItems[indexPath.row].isDone = !todoItems[indexPath.row].isDone
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
    
    // Helper function for modifying saved TodoItem. Queries Core Data and
    // return NSManagedObjectContext and TodoItemEntity based on table view selection
    private func fetchTodoItem(fromRow row: Int) -> (context: NSManagedObjectContext, entity: TodoItemEntity) {
        var entity: TodoItemEntity!
        
        let title = todoItems[row].title
        let date = todoItems[row].date
        let context = container.viewContext
        
        let fetchTodoItem: NSFetchRequest<TodoItemEntity> = TodoItemEntity.fetchRequest()
        fetchTodoItem.predicate = NSPredicate(format: "title == %@ AND date == %@", argumentArray: [title, date])
        
        let results = try? context.fetch(fetchTodoItem)
        entity = results?.first
        
        return (context, entity)
    }
}
