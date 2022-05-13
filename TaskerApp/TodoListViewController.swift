import UIKit

class TodoCell: UITableViewCell {
    
}

class TodoListViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private let tableView = UITableView()
    private var store = TodoItemStore()
    private var date = Date()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        store.load(todoItemsOn: Date())
        
        
        displayTableView()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoCell .self, forCellReuseIdentifier: "TodoCell")
    }
    
    private func displayTableView() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    @IBAction func prevDayButton(_ sender: Any) {
        if let newDate = Calendar.current.date(byAdding: .day, value: -1, to: date) {
            date = newDate
        }
        store.load(todoItemsOn: date)
        tableView.reloadData()
        
    }
    @IBAction func nextDayButton(_ sender: Any) {
        if let newDate = Calendar.current.date(byAdding: .day, value: 1, to: date) {
            date = newDate
        }
        store.load(todoItemsOn: date)
        tableView.reloadData()
    }
    
    @IBAction func todayButton(_ sender: Any) {
        date = Date()
        store.load(todoItemsOn: date)
        tableView.reloadData()
    }
    
    @IBAction func addItemPressed(_ sender: Any) {
        
        let alert = UIAlertController(title: "Add todo item",
                                      message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self]_ in
            guard let title = alert.textFields?.first?.text else {
                return
            }
            let todoItem = TodoItem(date: date, title: title, isDone: false)
            self.addNewItem(todoItem)
        }
        alert.addAction(addAction)
        
        let cancelAction = UIAlertAction(title: "Canccel", style: .cancel) {_ in
            
        }
        alert.addAction(cancelAction)
        
        alert.addTextField { textField in
            textField.placeholder = "Todo item"
        }
        
        present(alert, animated: true, completion: nil)
    }
    
    private func addNewItem(_ todoItem: TodoItem) {
        let indexPath = store.insert(todoItem: todoItem)
        tableView.beginUpdates()
        tableView.insertRows(at: [indexPath], with: .fade)
        tableView.endUpdates()
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as? TodoCell else {
            return UITableViewCell()
        }
        let todoItem = store.item(forIndexPath: indexPath)
        cell.textLabel?.text = todoItem?.title
        
        // nil coallescing operator. If the first statement is nil, default value will be false
        if todoItem?.isDone ?? false {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    // Set the title for each section
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        let title = dateFormatter.weekdaySymbols[Calendar.current.component(.weekday, from: date) - 1] + " " + dateFormatter.string(from: date)
        return title
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store.delete(atIndexPath:  indexPath)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store.markDone(atIndexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
    
    private lazy var dateFormatter : DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .none
        formatter.timeZone = TimeZone.current
        return formatter
    }()
    
}

