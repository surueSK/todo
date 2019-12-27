//
//  TodoStore.swift
//  a2019term
//
//  Created by 助川友理 on 2019/12/25.
//  Copyright © 2019 助川友理. All rights reserved.
//

import Foundation
import SwiftUI
import Combine


class TodoStore:ObservableObject {
    var todos:[todo]{
        didSet{didChange.send()}
    }
    init(todos:[todo]=[]) {
        self.todos=todos
    }
    var didChange = PassthroughSubject<Void,Never>()
}
