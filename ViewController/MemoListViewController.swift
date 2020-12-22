//
//  MemoListViewController.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import UIKit
import RxSwift
import RxCocoa
import NSObject_Rx

class MemoListViewController: UIViewController,ViewModelBindableType {
    
    @IBOutlet weak var addButton: UIBarButtonItem!
    var viewModel:MemoListViewModel!
    
    @IBOutlet weak var table: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        viewModel.memoList
            .bind(to: table.rx.items(cellIdentifier: "ListCell")) {
                row,memo,cell in cell.textLabel?.text = memo.content
            }
            .disposed(by: rx.disposeBag)
        
        addButton.rx.action = viewModel.makeCreateAction()
        
        //메모 선택하기랑 메모 선택해제하기
        Observable.zip(table.rx.modelSelected(Memo.self),
                       table.rx.itemSelected)
            .do(onNext: { [unowned self] (_,indexPath) in
                    self.table.deselectRow(at: indexPath, animated: true)})
            .map{$0.0}
            .bind(to: viewModel.detailAction.inputs)
            .disposed(by: rx.disposeBag)
    }
}
