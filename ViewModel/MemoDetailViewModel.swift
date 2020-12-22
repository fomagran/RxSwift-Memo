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
    
    //메모 편집할때 바로 업데이트 되도록 바꿈.
    func performUpdate(memo:Memo) -> Action<String,Void> {
        return Action { input in
            self.storage.updateMemo(memo: memo, content: input)
                .subscribe(onNext: { updated in
                    self.contents.onNext([
                        updated.content,
                        self.formatter.string(from: updated.insertDate)
                    ])
                })
                .disposed(by: self.rx.disposeBag)
            return Observable.empty()
        }
    }
    
    func makeEditAction() -> CocoaAction {
        return CocoaAction { _ in
            let editViewModel = MemoEditViewModel(title: "메모 편집", content: self.memo.content, sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: self.memo))
            
            let editScene = Scene.edit(editViewModel)
            
            return self.sceneCoordinator.transition(to: editScene, using: .modal, animated: true).asObservable().map{_ in}
        }
    }
}
