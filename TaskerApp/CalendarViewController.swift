import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    private let tableView = UITableView()
    private let store = TodoItemStore()
    
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
        store.load(todoItemsOn: date)
        tableView.reloadData()
    }
    
    private func displayTableView() {
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: 0).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: self.view.frame.size.width/2).isActive = true
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
        
        // nil coallescing operator. If the first statement is nil, default value will be false
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
