//
//  ViewModelBindableType.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import UIKit

protocol ViewModelBindableType {
    associatedtype ViewModelType
    var viewModel:ViewModelType! {get set}
    func bindViewModel()
}

extension ViewModelBindableType where Self:UIViewController {
    mutating func bind(viewModel:Self.ViewModelType) {
    self.viewModel = viewModel
    loadViewIfNeeded()
    bindViewModel()
    }
}


