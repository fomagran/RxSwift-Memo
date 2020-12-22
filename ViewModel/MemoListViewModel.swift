//
//  MemoListViewModel.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import Foundation
import RxSwift
import RxCocoa
import Action

class MemoListViewModel:CommonViewModel {

    var memoList:Observable<[Memo]> {
        return storage.memoList()
    }
    
    func performUpdate(memo:Memo) -> Action<String,Void> {
        return Action { input in
            return self.storage.updateMemo(memo: memo, content: input).map { _ in}
        }
    }
    
    func performCancel(memo:Memo) -> CocoaAction {
        return Action{
            return self.storage.deleteMemo(memo: memo).map{_ in}
        }
    }
    
    func makeCreateAction() -> CocoaAction {
        return CocoaAction { _ in
            return self.storage.createMemo(content: "")
                .flatMap { (memo) -> Observable<Void> in
                    let editViewModel = MemoEditViewModel(title: "새 메모",sceneCoordinator: self.sceneCoordinator, storage: self.storage, saveAction: self.performUpdate(memo: memo), cancelAction: self.performCancel(memo: memo))
                    
                    let editScene = Scene.edit(editViewModel)
                    return self.sceneCoordinator.transition(to: editScene, using: .modal, animated: true).asObservable().map{_ in}
                }
        }
    }
}
