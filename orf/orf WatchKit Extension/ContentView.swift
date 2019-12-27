//
//  ContentView.swift
//  orf WatchKit Extension
//
//  Created by 助川友理 on 2019/11/12.
//  Copyright © 2019 助川友理. All rights reserved.
//

import SwiftUI
import CoreMotion

struct ContentView: View {
    @State var isShown = false
    var body: some View {
        Button(action: {
            self.isShown = true
            gettime()
            gyro()
        }) {
            Text("時間所得！")
        }.alert(isPresented: $isShown, content:{
            Alert(title: Text("時間が取得されました！"))
    })
    }
}

//時間取得機能
let formatter = DateFormatter()
weak var timer:Timer!
var startTime = Date()
func gettime() {
    formatter.timeStyle = .full
    formatter.dateStyle = .full
    let now = Date()
    print(formatter.string(from: now))
}
//時間取得機能
//ジャイロなど
let motionManager: CMMotionManager = CMMotionManager()
func gyro(){
motionManager.deviceMotionUpdateInterval = 0.05 // 20Hz

}
//ジャイロなど

