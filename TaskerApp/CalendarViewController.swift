import UIKit
import FSCalendar

class CalendarViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, FSCalendarDelegate, FSCalendarDataSource {
    
    private let tableView = UITableView()
    var selectedDate = Date()
    var segueDate : Date?
    var store : TodoItemStore?
    var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        jumpToSegueDate()
        store!.load(todoItemsOn: selectedDate)
        displayTableView()
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TodoCell .self, forCellReuseIdentifier: "TodoCell")
        
        displayCalendar()
        calendar.delegate = self
        
    }
    
    private func jumpToSegueDate() {
        if let segueDate = segueDate {
            selectedDate = segueDate
        }
    }
    
    func displayCalendar() {
        let w = self.view.frame.size.width
        let h = self.view.frame.size.height
        calendar  = FSCalendar(frame: CGRect(x: 20.0, y: h/16, width: w - 40, height: 3*h/8))
        calendar.scope = .month
        calendar.scrollDirection = .horizontal
        calendar.firstWeekday = 2
        calendar.select(selectedDate)
        
        calendar.appearance.todayColor = UIColor.orange
        calendar.appearance.titleWeekendColor = UIColor.orange
        calendar.appearance.headerMinimumDissolvedAlpha = 0.0
        self.view.addSubview(calendar)
    }
    
    
    func calendar(_ calendar: FSCalendar, didSelect date: Date, at monthPosition: FSCalendarMonthPosition) {
        selectedDate = date
        store!.load(todoItemsOn: date)
        tableView.reloadData()
    }
    
    private func displayTableView() {
        let h = self.view.frame.size.height
        view.addSubview(tableView)
        
        tableView.topAnchor.constraint(equalTo: view.topAnchor, constant: h/2).isActive = true
        tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor, constant: 0).isActive = true
        tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 0).isActive = true
        tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: 0).isActive = true
        
        tableView.translatesAutoresizingMaskIntoConstraints = false
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell") as? TodoCell else {
            return UITableViewCell()
        }
        let todoItem = store!.item(forIndexPath: indexPath)
        cell.textLabel?.text = todoItem?.title
        
        if todoItem?.isDone ?? false {
            cell.accessoryType = UITableViewCell.AccessoryType.checkmark
        } else {
            cell.accessoryType = UITableViewCell.AccessoryType.none
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return store!.count
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            store!.delete(atIndexPath:  indexPath)
            tableView.beginUpdates()
            tableView.deleteRows(at: [indexPath], with: .fade)
            tableView.endUpdates()
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        store!.markDone(atIndexPath: indexPath)
        tableView.reloadRows(at: [indexPath], with: .fade)
    }
}
