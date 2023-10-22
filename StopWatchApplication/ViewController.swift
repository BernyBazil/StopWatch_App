import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
        
    @IBOutlet weak var TimeLabel: UILabel!
    @IBOutlet weak var LapResetButton: UIButton!
    @IBOutlet weak var lapTimesTableView: UITableView!
    @IBOutlet weak var StartStopButton: UIButton!
        
    var timer: Timer?
    var count = 0
    var timerCounting = false
    var lapTimes: [String] = []
    var currentLapTime = 0
    var lapButtonIsLap = false
        
    override func viewDidLoad() {
        super.viewDidLoad()
        lapTimesTableView.dataSource = self
        lapTimesTableView.delegate = self
        configureButtons()
    }
    
    private func configureButtons() {
        StartStopButton.setTitle("START", for: .normal)
        StartStopButton.setTitleColor(UIColor.green, for: .normal)
        LapResetButton.setTitle("RESET", for: .normal)
        LapResetButton.setTitleColor(UIColor.black, for: .normal)
    }
        
    @IBAction func LapResetTapped(_ sender: Any) {
        if timerCounting {
            let lapTimeString = makeTimeString(hours: currentLapTime / 3600, minutes: (currentLapTime % 3600) / 60, seconds: (currentLapTime % 3600) % 60)
            lapTimes.append(lapTimeString)
            currentLapTime = 0
            lapTimesTableView.reloadData()
        } else {
            let alert = UIAlertController(title: "Reset Timer?", message: "Are you sure you would like to reset the Timer?", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "CANCEL", style: .cancel, handler: { (_) in /* Do nothing */ }))
            alert.addAction(UIAlertAction(title: "YES", style: .default, handler: { (_) in
                self.resetTimerAndLapData()
            }))
            self.present(alert, animated: true, completion: nil)
        }
    }
        
    @IBAction func StartStopTapped(_ sender: Any) {
        if timerCounting {
            stopTimer()
        } else {
            startTimer()
        }
    }
    
    private func startTimer() {
        timerCounting = true
        StartStopButton.setTitle("STOP", for: .normal)
        StartStopButton.setTitleColor(UIColor.red, for: .normal)
        timer = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(timerCounter), userInfo: nil, repeats: true)
        if !lapButtonIsLap {
            lapButtonIsLap = true
            LapResetButton.setTitle("LAP", for: .normal)
        }
    }
    
    private func stopTimer() {
        timerCounting = false
        timer?.invalidate()
        StartStopButton.setTitle("START", for: .normal)
        StartStopButton.setTitleColor(UIColor.green, for: .normal)
        if lapButtonIsLap {
            lapButtonIsLap = false
            LapResetButton.setTitle("RESET", for: .normal)
        }
    }
    
    private func resetTimerAndLapData() {
        count = 0
        timer?.invalidate()
        TimeLabel.text = makeTimeString(hours: 0, minutes: 0, seconds: 0)
        lapTimes.removeAll()
        currentLapTime = 0
        lapTimesTableView.reloadData()
        lapButtonIsLap = false
        LapResetButton.setTitle("RESET", for: .normal)
        LapResetButton.setTitleColor(UIColor.black, for: .normal)
        stopTimer()
    }
        
    @objc func timerCounter() {
        count = count + 1
        currentLapTime = count
        let time = secondsToHoursMinutesSeconds(seconds: count)
        TimeLabel.text = makeTimeString(hours: time.0, minutes: time.1, seconds: time.2)
    }
        
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return lapTimes.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "lapTimeCell", for: indexPath)
        
        let lapNumber = indexPath.row + 1
        let lapTimeString = lapTimes[indexPath.row]
        
        cell.textLabel?.text = "Lap \(lapNumber)                                         " + lapTimeString
        return cell
    }

    func secondsToHoursMinutesSeconds(seconds: Int) -> (Int, Int, Int) {
        return ((seconds / 3600), (seconds % 3600) / 60, ((seconds % 3600) % 60))
    }
    
    func makeTimeString(hours: Int, minutes: Int, seconds: Int) -> String {
        var timeString = ""
        timeString += String(format: "%02d", hours)
        timeString += " : "
        timeString += String(format: "%02d", minutes)
        timeString += " : "
        timeString += String(format: "%02d", seconds)
        return timeString
    }
}
