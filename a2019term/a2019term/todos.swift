//
//  todos.swift
//  a2019term
//
//  Created by 助川友理 on 2019/12/22.
//  Copyright © 2019 助川友理. All rights reserved.
//

import SwiftUI

struct todo: Identifiable{
    var id = UUID()
    var name: String
    var time: Int
}

#if DEBUG
let testData = [
    todo(name:"風呂",time:1),
    todo(name:"洗面所",time:2),
    todo(name:"食事",time:3),
    todo(name:"歯磨き",time:4),
    todo(name:"化粧",time:5)
]

#endif
