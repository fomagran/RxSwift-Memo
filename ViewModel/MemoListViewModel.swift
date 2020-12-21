//
//  MemoListViewModel.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import Foundation
import RxSwift
import RxCocoa

class MemoListViewModel:CommonViewModel {
    
    var memoList:Observable<[Memo]> {
        return storage.memoList()
    }
}
