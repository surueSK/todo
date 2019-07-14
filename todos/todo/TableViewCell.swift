//
//  TableViewCell.swift
//  todo
//
//  Created by 助川友理 on 2019/07/11.
//  Copyright © 2019 助川友理. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet var timer: UIButton!
    @IBOutlet var timerMinute2: UILabel!
    @IBOutlet var timerSecond2: UILabel!
    
    
   //===============ストップウォッチ関連開始==================
    @IBAction func todotime(){
        if (status) {
            stop()
            timer.setTitle("START", for: .normal)
            //resetBtn.isEnabled = true
            
            // If button status is false use start function, relabel button and disable reset button
        } else {
            start()
            timer.setTitle("STOP", for: .normal)
            //resetBtn.isEnabled = false
        }
    }
    weak var timer2: Timer?
    var startTime2: Double = 0
    var time: Double = 0
    var elapsed: Double = 0
    var status: Bool = false
    
    func start() {
        
        startTime2 = Date().timeIntervalSinceReferenceDate - elapsed
        timer2 = Timer.scheduledTimer(timeInterval: 0.01, target: self, selector: #selector(updateCounter), userInfo: nil, repeats: true)
        
        // Set Start/Stop button to true
        status = true
        
    }
    
    func stop() {
        
        elapsed = Date().timeIntervalSinceReferenceDate - startTime2
        timer2?.invalidate()
        
        // Set Start/Stop button to false
        status = false
        
    }
    
    @objc func updateCounter() {
        
        // Calculate total time since timer started in seconds
        time = Date().timeIntervalSinceReferenceDate - startTime2
        
        // Calculate minutes
        let minutes = UInt8(time / 60.0)
        time -= (TimeInterval(minutes) * 60)
        
        // Calculate seconds
        let seconds = UInt8(time)
        time -= TimeInterval(seconds)
        
        // Calculate milliseconds
        //let milliseconds = UInt8(time * 100)
        
        // Format time vars with leading zero
        let strMinutes = String(format: "%02d", minutes)
        let strSeconds = String(format: "%02d", seconds)
        //let strMilliseconds = String(format: "%02d", milliseconds)
        
        // Add time vars to relevant labels
        timerMinute2.text = strMinutes
        timerSecond2.text = strSeconds
        //labelMillisecond.text = strMilliseconds
        
    }
     //===============ストップウォッチ関連終了==================
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
