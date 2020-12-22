//
//  SceneCoordinator.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/21.
//

import Foundation
import RxSwift
import RxCocoa

extension UIViewController {
    var  sceneViewController:UIViewController {
        return self.children.first ?? self
    }
}

class SceneCoordinator: SceneCoordinatorType {
    
    private let disposeBag = DisposeBag()
    private var window:UIWindow
    private var currentVC:UIViewController
    
    required init(window:UIWindow) {
        self.window = window
        currentVC = window.rootViewController!
    }
    
    func transition(to scene: Scene, using style: TransitionStyle, animated: Bool) -> Completable {
        let subject = PublishSubject<Void>()
        let target = scene.instantiate()
        
        switch style {
        case .root:
            //화면 전환 디버깅
            currentVC = target.sceneViewController
            window.rootViewController = target
            subject.onCompleted()
        case .push:
            guard let nav = currentVC.navigationController else { subject.onError(TransitionError.navigationControllerMissing)
                break
            }
            //뒤로가기 버튼 디버깅
            nav.rx.willShow
                .subscribe(onNext: {[unowned self] event in
                    self.currentVC = event.viewController.sceneViewController
                })
                .disposed(by: disposeBag)
            
            nav.pushViewController(target, animated: animated)
            currentVC = target.sceneViewController
            subject.onCompleted()
        case .modal:
            currentVC.present(target, animated: animated) {
                subject.onCompleted()
            }
            currentVC = target.sceneViewController
        }
        //completable로 변환되어서 반환됨.
        return subject.ignoreElements()
    }
    func close(animated: Bool) -> Completable {
        return Completable.create { [unowned self] completable -> Disposable in
            if let presentingVC = self.currentVC.presentingViewController {
                self.currentVC.dismiss(animated: animated) {
                    self.currentVC = presentingVC.sceneViewController
                    completable(.completed)
                }
            }else if let nav = self.currentVC.navigationController {
                guard nav.popViewController(animated: animated) != nil else {
                    completable(.error(TransitionError.cannotPop))
                    return Disposables.create()
                }
                self.currentVC = nav.viewControllers.last!
                completable(.completed)
            }else {
                completable(.error(TransitionError.unknown))
            }
            return Disposables.create()
        }
    }
}
