//
//  ContentView.swift
//  orf
//
//  Created by 助川友理 on 2019/11/12.
//  Copyright © 2019 助川友理. All rights reserved.
//

import SwiftUI

struct ContentView: View {
    var body: some View{
        Button(action:{
            //action
        }){
            Text("Button Title")
        }
    }
    /*
    var body: some View {
        VStack {
            Text("Turtle Rock")
                .font(.title)
            Text("Joshua Tree National Park")
                .font(.subheadline)
        }
    }
*/
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
