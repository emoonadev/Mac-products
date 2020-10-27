//
//  MP+General.swift
//  Mac product
//
//  Created by Mickael Belhassen on 27/10/2020.
// Copyright (c) 2020 Mickael Belhassen. All rights reserved.
//

import Foundation
import SwiftCoroutine

func async(in scope: CoScope? = nil, task: @escaping () throws -> Void) {
    DispatchQueue.main.startCoroutine(in: scope, task: task)
}