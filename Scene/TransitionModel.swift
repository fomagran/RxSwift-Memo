//
//  TransitionModel.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/21.
//

import Foundation

enum TransitionStyle {
    case root
    case push
    case modal
}

enum TransitionError:Error {
    case navigationControllerMissing
    case cannotPop
    case unknown
}
