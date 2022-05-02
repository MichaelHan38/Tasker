import UIKit
import FSCalendar

class CalendarViewController: UIViewController {
    
    var calendar: FSCalendar!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        calendar  = FSCalendar(frame: CGRect(x: 0.0, y: 40.0, width: self.view.frame.size.width, height: self.view.frame.size.height/2))
        calendar.scope = .month
        calendar.scrollDirection = .horizontal
        self.view.addSubview(calendar)
    }
}
