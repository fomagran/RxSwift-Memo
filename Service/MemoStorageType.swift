//
//  MemoStorage.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import Foundation
import RxSwift


protocol MemoStorageType {
    @discardableResult
    func createMemo(content:String) -> Observable<Memo>
    
    @discardableResult
    func memoList() -> Observable<[Memo]>
    
    @discardableResult
    func updateMemo(memo:Memo,content:String) -> Observable<Memo>
    
    @discardableResult
    func deleteMemo(memo:Memo) -> Observable<Memo>
}
