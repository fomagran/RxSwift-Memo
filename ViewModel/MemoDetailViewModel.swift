//
//  MemoDetailViewModel.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoDetailViewModel:CommonViewModel {
    
    let memo:Memo
    
    private var formatter:DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "Ko_kr")
        formatter.dateStyle = .medium
        formatter.timeStyle = .medium
        return formatter
    }()
    
    var contents:BehaviorSubject<[String]>
    
    init(memo:Memo,title:String,sceneCoordinator:SceneCoordinatorType,storage:MemoStorageType) {
        self.memo = memo
        
        contents = BehaviorSubject<[String]>(value: [memo.content,formatter.string(from: memo.insertDate)])
        
        super.init(title: title, sceneCoordinator: sceneCoordinator, storage: storage)
        
    }
    lazy var popAction = CocoaAction { [unowned self] in
        return self.sceneCoordinator.close(animated: true).asObservable().map{_ in}
    }
    
}
