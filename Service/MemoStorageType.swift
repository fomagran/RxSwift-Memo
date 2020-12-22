//
//  MemoStorage.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//

import Foundation
import RxSwift


protocol MemoStorageType {
    func createMemo(content:String) -> Observable<Memo>
    
    func memoList() -> Observable<[MemoSectionModel]>
    
    func updateMemo(memo:Memo,content:String) -> Observable<Memo>

    func deleteMemo(memo:Memo) -> Observable<Memo>
}
