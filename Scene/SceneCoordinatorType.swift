//
//  SceneCoordinatorType.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/21.
//

import Foundation
import RxSwift

protocol SceneCoordinatorType {
    func transition(to scene:Scene,using style:TransitionStyle,animated:Bool) -> Completable
    
    func close(animated:Bool) -> Completable
}
