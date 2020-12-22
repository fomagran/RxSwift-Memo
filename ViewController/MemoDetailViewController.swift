//
//  MemoDetailViewController.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import UIKit
import RxSwift
import RxCocoa

class MemoDetailViewController: UIViewController,ViewModelBindableType {
    //MARK:Properties
    @IBOutlet weak var deleteButton: UIBarButtonItem!
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var table: UITableView!
    var viewModel:MemoDetailViewModel!
    //MARK:LifeCycle
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
    }
    
    
    func bindViewModel() {
        viewModel.title
            .drive(navigationItem.rx.title)
            .disposed(by: rx.disposeBag)
        
        viewModel.contents
            .bind(to: table.rx.items) { tableView,row,value in
                switch row  {
                case 0:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MemoDetailCell")!
                    cell.textLabel?.text = value
                    return cell
                case 1:
                    let cell = tableView.dequeueReusableCell(withIdentifier: "MemoDetailDateCell")!
                    cell.textLabel?.text = value
                    return cell
                default:
                    fatalError()
                }
            }
            .disposed(by: rx.disposeBag)
        editButton.rx.action = viewModel.makeEditAction()
        deleteButton.rx.action = viewModel.makeDeleteAction()
        
        //과제: 아래는 tap으로 구현되어있는데 action으로 바꿔보기
        shareButton.rx.tap
            .throttle(.milliseconds(500), scheduler: MainScheduler.instance)
            .subscribe(onNext:{[weak self] _ in
                guard let memo = self?.viewModel.memo.content else {return}
                
                let vc = UIActivityViewController(activityItems: [memo], applicationActivities: nil)
                self?.present(vc, animated: true, completion: nil)
            })
            .disposed(by: rx.disposeBag)
    }
}
