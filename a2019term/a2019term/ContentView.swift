//
//  ContentView.swift
//  a2019term
//
//  Created by 助川友理 on 2019/12/19.
//  Copyright © 2019 助川友理. All rights reserved.
//

import SwiftUI
// メニュー画面?
struct ContentView: View {
    var body: some View {
        ZStack{
            Color.blue
              .edgesIgnoringSafeArea(.all)
        VStack {
            Text("ADLogger")
            .font(.title)
            .foregroundColor(.orange)
            Text("HOME")
            .foregroundColor(.orange)
            NavigationView {
            NavigationLink(destination: SubContentView()) {
                    Text("TODO & StopWatch")
                        .font(.title)
                        .foregroundColor(.orange)
                
                }
              }
            }
        }
    }
}

// TODO画面
struct SubContentView: View {
    var todos: [todo] = []
    @ObservedObject var store = TodoStore()
    @State var isShown = false
    @State var inPut:String = ""
    //@State var inPut:String = ""
    var body: some View {
        NavigationView{
                List {
                    HStack{
                        TextField("WriteNewtask", text: $inPut)
                        Button(action: addTask) {
                        //store.todos.name.append(self.inPut)
                            Text("Add Task")
                        }
                    }
                ForEach(store.todos){
                todos in
            HStack{
                NavigationLink(destination:Text(todos.name)){
                        Text(todos.name)
                        Text("\(todos.time)")
                }
                Button(action: {
                    self.gettime()
                    print("hello")
                }) {
                    Text("START")
                }
            }
            }.onDelete(perform:delete)
                    .onMove(perform:move)
             .navigationBarItems(trailing: EditButton())
             .navigationBarTitle(Text("TODOS & STOPWATCH"))
            }
        }

    }
    
//TODO機能
    func addTask(){
        self.isShown = true
        //store.todos.append(todos.name)
        //store.todos.name.append(self.inPut)
    }
    func delete(at offsets:IndexSet){
        store.todos.remove(atOffsets:offsets)
    }
    func move(from source:IndexSet,to destination:Int){
        store.todos.move(fromOffsets: source, toOffset: destination)
    }
//時間取得機能
    let formatter = DateFormatter()
    weak var timer:Timer!
    var startTime = Date()
    func gettime(){
        formatter.timeStyle = .full
        formatter.dateStyle = .full
        let now = Date()
        print(formatter.string(from: now))
    }

}


#if DEBUG
struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        //ContentView(store:TodoStore(todos:testData))
        SubContentView(store:TodoStore(todos:testData))
    }
}
#endif

