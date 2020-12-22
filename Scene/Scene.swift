//
//  Scene.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/21.
//

import UIKit

enum Scene {
    case list(MemoListViewModel)
    case detail(MemoDetailViewModel)
    case edit(MemoEditViewModel)
}

extension Scene {
    func instantiate(from storyboard:String = "Main") -> UIViewController {
        let storyboard = UIStoryboard(name: storyboard, bundle: nil)
        switch self {
        case  .list(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "ListNavigationController") as? UINavigationController else { fatalError() }
            guard var listVC = nav.viewControllers.first as? MemoListViewController else { fatalError() }
            listVC.bind(viewModel: viewModel)
            return nav
        case  .detail(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "MemoDetailNavigationController") as? UINavigationController else {  fatalError()}
            guard var detailVC = nav.viewControllers.first as? MemoDetailViewController else {  fatalError() }
            detailVC.bind(viewModel: viewModel)
            return detailVC
        case  .edit(let viewModel):
            guard let nav = storyboard.instantiateViewController(withIdentifier: "EditNavigationController") as? UINavigationController else { fatalError() }
            guard var editVC = nav.viewControllers.first as? MemoEditViewController else { fatalError() }
            editVC.bind(viewModel: viewModel)
            return nav
        }
    }
}

