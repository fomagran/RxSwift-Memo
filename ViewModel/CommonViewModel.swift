//
//  CommonViewModel.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/21.
//

import Foundation
import RxSwift
import RxCocoa

class CommonViewModel:NSObject {
    let title:Driver<String>
    let sceneCoordinator:SceneCoordinatorType
    let storage:MemoStorageType
    
    init(title:String,sceneCoordinator:SceneCoordinatorType,storage:MemoStorageType) {
        self.title = Observable.just(title).asDriver(onErrorJustReturn: "")
        self.sceneCoordinator = sceneCoordinator
        self.storage = storage
    }
}
