import Foundation

class CalendarPageViewModel {
    let manager = CoreDataManager.shared
    var calendarView: CalendarPageView!
    var selectedDdays: [Date] = []
    var timesAry: [String] = []
    var isModalDismissed: Bool = false {
        didSet {
            makeTimesAry()
            calendarView.calendar.reloadData()
        }
    }

    func makeTimesAry() {
        timesAry = manager.getMemos().compactMap { $0.timeNotifySetting }.map { $0.replacingOccurrences(of: ".", with: "-").prefix(10) }.map { String($0) }
    }

    func addSelectedDday(date: Date) {
        selectedDdays.append(date)
    }
}
