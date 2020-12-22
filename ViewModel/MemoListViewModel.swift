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
import RxDataSources

typealias MemoSectionModel = AnimatableSectionModel<Int,Memo>

class MemoListViewModel:CommonViewModel {
    
    let dataSource:RxTableViewSectionedAnimatedDataSource<MemoSectionModel> = {
        let ds = RxTableViewSectionedAnimatedDataSource<MemoSectionModel>(configureCell: {(dataSource,tableView,indexPath,memo) -> UITableViewCell in let cell = tableView.dequeueReusableCell(withIdentifier: "ListCell", for: indexPath)
            cell.textLabel?.text = memo.content
            return cell
        })
        ds.canEditRowAtIndexPath = {_,_ in return true}
        return ds
    }()

    var memoList:Observable<[MemoSectionModel]> {
        return storage.memoList()
    }
    
    //add버튼 눌렀을때
    func performUpdate(memo:Memo) -> Action<String,Void> {
        return Action { input in
            return self.storage.updateMemo(memo: memo, content: input).map { _ in}
        }
    }
    
    //캔슬버튼 눌렀을때
    func performCancel(memo:Memo) -> CocoaAction {
        return Action{
            return self.storage.deleteMemo(memo: memo).map{_ in}
        }
    }
    
    //에딧뷰컨트롤러로 화면전환
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
    
    //디테일뷰컨트롤러로 화면 전환
    lazy var detailAction:Action<Memo,Void> = {
        return Action { memo in
            let detailViewModel = MemoDetailViewModel(memo: memo, title: "메모 보기", sceneCoordinator: self.sceneCoordinator, storage: self.storage)
            let detailScene = Scene.detail(detailViewModel)
            
            return self.sceneCoordinator.transition(to: detailScene, using: .push, animated: true).asObservable().map{_ in }
        }
    }()
    
    lazy var deleteAction:Action<Memo,Swift.Never> = {
        return Action{memo in
            return self.storage.deleteMemo(memo: memo).ignoreElements()
        }
    }()
}
