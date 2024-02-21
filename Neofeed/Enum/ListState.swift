//
//  ListState.swift
//  Neofeed
//
//  Created by Ryo Martin on 21/02/24.
//

import Foundation

enum ListState {
    case loading
    case error(Error)
    case loaded([Post])
    
    static var empty: ListState { .loaded([])}
}
