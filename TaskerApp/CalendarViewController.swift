import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    private let tableView = UITableView()
    private let store = TodoItemStore()
    private var selectedDate = Date()
    
    var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        store.load(todoItemsOn: Date())

        displayTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoCell .self, forCellReuseIdentifier: "TodoCell")
        
        displayCalendar()
        calendar.delegate = self
        
    }
    
    @IBAction func addItemPressed(_ sender: Any) {
        let alert = UIAlertController(title: "Add todo item",
                                      message: nil, preferredStyle: .alert)
        
        let addAction = UIAlertAction(title: "Add", style: .default) { [unowned self]_ in
            guard let title = alert.textFields?.first?.text else {
                return
            }
            let todoItem = TodoItem(date: selectedDate, title: title, isDone: false)
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
    
    func displayCalendar() {
        let w = self.view.frame.size.width
        let h = self.view.frame.size.height
        calendar  = FSCalendar(frame: CGRect(x: 0.0, y: h/2, width: w, height: h/2))
        calendar.scope = .month
        calendar.scrollDirection = .horizontal
        calendar.firstWeekday = 2
        calendar.select(calendar.today)
        self.view.addSubview(calendar)
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        store.load(todoItemsOn: date)
        tableView.reloadData()
    }
    
    private func displayTableView() {
        let h = self.view.frame.size.height
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: -h/2).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as? TodoCell else {
            return UITableViewCell()
        }
        let todoItem = store.item(forIndexPath: indexPath)
        cell.textLabel?.text = todoItem?.title
        
        if todoItem?.isDone ?? false {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
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
}
