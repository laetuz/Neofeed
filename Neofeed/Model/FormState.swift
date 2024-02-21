//
//  FormState.swift
//  Neofeed
//
//  Created by Ryo Martin on 21/02/24.
//

import Foundation

enum FormState {
    case idle, working, error
    
    var isError: Bool {
        get {
            self == .error
        }
        set {
            guard !newValue else { return }
            self = .idle
        }
    }
}
