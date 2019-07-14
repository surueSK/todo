//
//  ViewController.swift
//  todo
//
//  Created by 助川友理 on 2019/06/27.
//  Copyright © 2019 助川友理. All rights reserved.
//

//  ViewController.swift
import UIKit
import AVFoundation

//classの継承を追加
class ViewController: UIViewController,AVAudioRecorderDelegate, AVAudioPlayerDelegate ,UITableViewDataSource, UITableViewDelegate{
    
    @IBOutlet var label: UILabel!
    @IBOutlet var recordButton: UIButton!
    @IBOutlet var playButton: UIButton!
    var audioRecorder: AVAudioRecorder!
    var audioPlayer: AVAudioPlayer!
    var isRecording = false
    var isPlaying = false
    
    @IBOutlet var timerMinute: UILabel!
    @IBOutlet var timerSecond: UILabel!
    
    weak var timer: Timer!
    var startTime = Date()
   
    @IBOutlet var tableView : UITableView!
    
    //----------------ここからToDoテーブル関連-----------------
    // ②テーブルに表示するデータの準備
    var todoItem : [String] = []
    
    // テーブルの行数を指定するメソッド（必須）
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoItem.count
    }
    
    // ④セルの中身を設定するメソッド!!!（必須）
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        // セルを取得する
        let cell: UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "timercell", for: indexPath)
        // セルに値を設定する
        cell.textLabel!.text = todoItem[indexPath.row]
        return cell
       
    }
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        if UserDefaults.standard.object(forKey: "mycell") != nil{
            todoItem = UserDefaults.standard.object(forKey: "mycell") as! [String]
        }
        
        tableView.register(UINib(nibName: "TableViewCell", bundle: nil), forCellReuseIdentifier: "timercell")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    //----------------↓新規追加-----------------
    // MARK - 新規アイテム追加機能
    @IBAction func addButtonPressed(_ sender: Any) {
        // プラスボタンが押された時に実行される処理
        
        var textField = UITextField()
        
        let alert = UIAlertController(title: "新しいTODOを追加", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "追加", style: .default) { (action) in
            print(textField.text!)
            
            self.todoItem.append(textField.text!)
            textField.text = ""
            UserDefaults.standard.set( self.todoItem ,forKey: "mycell" )
            print("array: \(self.todoItem)")
            self.tableView.reloadData()
        }
        
        alert.addTextField { (alertTextField) in
            
            alertTextField.placeholder = "新しいアイテム"
            textField = alertTextField

        }
        
        alert.addAction(action)
       present(alert, animated: true, completion: nil)
        

    }
    
    //----------------↓削除-----------------
    
    // MARK - スワイプでのアイテム削除機能　ここからtable view内整理？
     func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        
        // アイテム削除処理
        todoItem.remove(at: indexPath.row)
        let indexPaths = [indexPath]
        tableView.deleteRows(at: indexPaths, with: .automatic)
        
       
     }
     //----------------***テーブル内ボタンの生成↓***-----------------
    // UITableViewをOutlet接続
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        
        // チェックマークを入れる
        cell?.accessoryType = .checkmark
    }
    
    func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        let cell = tableView.cellForRow(at:indexPath)
        
        // チェックマークを外す
        cell?.accessoryType = .none
       
    }
    
    @IBAction func sampleButton(_ sender: UIButton) {
        if (status) {
            stop()
            sender.setTitle("START", for: .normal)
            //resetBtn.isEnabled = true
            
            // If button status is false use start function, relabel button and disable reset button
        } else {
            start()
            sender.setTitle("STOP", for: .normal)
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
        timerMinute.text = strMinutes
        timerSecond.text = strSeconds
        //labelMillisecond.text = strMilliseconds
        
    }
        
//----------------ここから録音・ストップウォッチ関連-----------------

    @IBAction func record(){
        
        if timer != nil{
            //timerが起動中なら一旦破棄する
            timer.invalidate()
        }
        
        if !isRecording {
            
            timer = Timer.scheduledTimer(
                timeInterval: 0.01,
                target: self,
                selector: #selector(self.timerCounter),
                userInfo: nil,
                repeats: true)
            startTime = Date()
            
            let session = AVAudioSession.sharedInstance()
            try! session.setCategory(AVAudioSession.Category.playAndRecord)
            try! session.setActive(true)
            
            let settings = [
                AVFormatIDKey: Int(kAudioFormatMPEG4AAC),
                AVSampleRateKey: 44100,
                AVNumberOfChannelsKey: 2,
                AVEncoderAudioQualityKey: AVAudioQuality.high.rawValue
            ]
            
            audioRecorder = try! AVAudioRecorder(url: getURL(), settings: settings)
            audioRecorder.delegate = self
            audioRecorder.record()
            
            isRecording = true
            
            label.text = "録音中"
            recordButton.setTitle("STOP", for: .normal)
            playButton.isEnabled = false
            
        }else{
            
            if timer != nil{
                timer.invalidate()
            }
            
            audioRecorder.stop()
            isRecording = false
            
            label.text = "録音終了"
            recordButton.setTitle("START", for: .normal)
            playButton.isEnabled = true
            
        }
    }
    
    func getURL() -> URL{
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let docsDirect = paths[0]
        let url = docsDirect.appendingPathComponent("recording.m4a")
        return url
    }
    
    @IBAction func play(){
        if !isPlaying {
            
            timerMinute.text = "00"
            timerSecond.text = "00"
            
            audioPlayer = try! AVAudioPlayer(contentsOf: getURL())
            audioPlayer.delegate = self
            audioPlayer.play()
            
            isPlaying = true
            
            label.text = "再生中"
            playButton.setTitle("STOP", for: .normal)
            recordButton.isEnabled = false
            
        }else{
            
            audioPlayer.stop()
            isPlaying = false
            
            label.text = "待機中"
            playButton.setTitle("PLAY", for: .normal)
            recordButton.isEnabled = true
            
        }
    }
    
    @objc func timerCounter() {
        // タイマー開始からのインターバル時間
        let currentTime = Date().timeIntervalSince(startTime)
        
        // fmod() 余りを計算
        let minute = (Int)(fmod((currentTime/60), 60))
        // currentTime/60 の余り
        let second = (Int)(fmod(currentTime, 60))
        // floor 切り捨て、小数点以下を取り出して *100
        //let msec = (Int)((currentTime - floor(currentTime))*100)
        
        // %02d： ２桁表示、0で埋める
        let sMinute = String(format:"%02d", minute)
        let sSecond = String(format:"%02d", second)
        //let sMsec = String(format:"%02d", msec)
        
        timerMinute.text = sMinute
        timerSecond.text = sSecond
        //timerMSec.text = sMsec
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(true)
        timer.invalidate()
    }
    
    //override func didReceiveMemoryWarning() {
      //  super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    //}
    
}


