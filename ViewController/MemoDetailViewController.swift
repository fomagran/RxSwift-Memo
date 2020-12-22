//
//  MemoDetailViewController.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import UIKit

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
        
    }
    


}
