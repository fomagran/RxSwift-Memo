//
//  ViewController.swift
//  RxSwift Memo
//
//  Created by Fomagran on 2020/12/18.
//


//MARK: Binding
/*Observable이 생산자이고 UIComponet가 소비자가 된다. 이것을 연결하는것을 binding이라고 한다.
 binding은 binder를 통해서 되는데 binder는 error이벤트를 받지 않는다. (UI가 업데이트 되지 않는 문제를 막기 위해서)
 binding에 성공하면 UI가 업데이트 된다.
 */

import UIKit
import RxCocoa
import RxSwift

class ViewController: UIViewController {
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var tf: UITextField!
    let disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        label.text = ""
        tf.becomeFirstResponder()
        
        //텍스트필드에 입력한 값이 바로 레이블에 업데이트 된다. 하지만 백그라운드에서 실행될 때는 안됨.
//        tf.rx.text
//            .subscribe(onNext:{[weak self] str in self?.label.text = str})
//            .disposed(by: disposeBag)
        
        //백그라운드에서 실행되게 하려면 아래와 같이 바인딩 해줘야 한다.
        tf.rx.text
            .bind(to: label.rx.text)
            .disposed(by: disposeBag)
        
    }


}

