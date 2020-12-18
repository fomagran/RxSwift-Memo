import UIKit
import RxSwift

let disposeBag = DisposeBag()

print("---------hello---------")
//MARK:Hello
Observable.just("Hello").subscribe{print($0)}.disposed(by: disposeBag)

print("---------observable---------")
//MARK:Observable
//Observable 유튜버 Observer는 구독자

// Observable 생성방법 1
Observable<Int>.create { (observer) -> Disposable in
    observer.on(.next(0))
    observer.onNext(1)
    observer.onCompleted()
    return Disposables.create()
}

// Observable 생성방법 2
Observable.from([0,1])

print("---------publish subject---------")
//MARK:Publish Subject
enum MyError:Error {
    case error
}

//subject도 observable 형태
let subject = PublishSubject<String>()

subject.onNext("Hello")
//퍼블리쉬 서브젝트는 구독 이후에 전달된 새로운 이벤트만 구독자로 전달한다.
let o1 = subject.subscribe { print(">> 1",$0)}
subject.onNext("RxSwift")
let o2 = subject.subscribe{print(">> 2",$0)}
o2.disposed(by: disposeBag)
//o1,o2 두 구독자한테 이벤트d가 간다.
subject.onNext("Subject")
//모든 구독자한테 컴플리트 이벤트가 전달돔.
//subject.onCompleted()

//컴플리트 이벤트가 발생한 이후에는 바로 컴플리트 이벤트가 전달되어 종료된다.
let o3 = subject.subscribe{print(">> 3",$0)}
o3.disposed(by: disposeBag)

//에러가 발생했을 때는 모든 구독자에게 에러가 발생했다고 이벤트가 전달된다.
subject.onError(MyError.error)

//실행은 되지만 에러가 있다고 이벤트가 전달되어 종료된다.
let o4 = subject.subscribe{print(">> 4",$0)}
o4.disposed(by: disposeBag)


print("---------just---------")
//MARK:just
let element = "😁"

//넥스트 이벤트가 출력되고 컴플리트 이벤트도 바로 출력됨.
Observable.just(element)
    .subscribe{event in print(event)}
    .disposed(by: disposeBag)
//just는 파라미터에 전달된 요소를 그대로 방출한다.
Observable.just([1,2,3])
    .subscribe{event in print(event)}
    .disposed(by: disposeBag)

print("---------of---------")
//MARK: of
let apple = "apple"
let orange = "orange"
let kiwi  = "kiwi"

//just와 다르게 하나하나 방출되고 컴플리트 이벤트가 방출됨.
Observable.of(apple,orange,kiwi)
    .subscribe{element in print(element)}
    .disposed(by: disposeBag)
//배열로 넣었을 땐 배열 하나하나가 그대로 방출됨
Observable.of([1,2],[3,4],[5,6])
    .subscribe{element in print(element)}
    .disposed(by: disposeBag)

print("---------from---------")
//MARK: from
let fruits = ["apple","orange","kiwi","watermelon"]
//배열을 넣어도 배열 안의 element가 하나하나 방출되고 컴플리트
Observable.from(fruits)
    .subscribe { (element) in print(element) }
    .disposed(by: disposeBag)

print("---------filter---------")
//MARK: filter
let numbers = [1,2,3,4,5,6,7,8]
//필터를 사용해서 원하는 값만 방출할 수 있음
Observable.from(numbers)
    .filter{$0.isMultiple(of: 2)}
    .subscribe{element in print(element)}
    .disposed(by: disposeBag)


print("---------flatmap---------")
//MARK: flatmap
let behavior1 = BehaviorSubject(value: 1)
let behavior2 = BehaviorSubject(value: 2)
let behaviorSubject = PublishSubject<BehaviorSubject<Int>>()
behaviorSubject
    .flatMap{$0.asObservable()}
    .subscribe{print($0)}
    .disposed(by: disposeBag)

behaviorSubject.onNext(behavior1)
behaviorSubject.onNext(behavior2)

//가장 마지막으로 업데이트된 최신항목만 방출됨.
behavior1.onNext(11)
behavior2.onNext(22)

print("---------combinelatest---------")
//MARK: combinelatest
let greetings = PublishSubject<String>()
let languages = PublishSubject<String>()

//lhs는 lefthandside rhs righthandside
Observable.combineLatest(greetings,languages) {lhs,rhs -> String in return "\(lhs) \(rhs)"}
    .subscribe{print($0)}
    .disposed(by: disposeBag)

//하나만 이벤트를 넣었을 경우 아무것도 방출되지 않음
greetings.onNext("Hello")
//모든 퍼블리쉬 서브젝트가 값이 주어질 때 방출됨. -> Hello World!
languages.onNext("World!")
//새로운 값이 주어지면 가장 최신의 서브젝트오 합쳐져서 방출뒴 -> Bye World!
greetings.onNext("Bye")
//하나만 끝나면 가장 마지막에 된 값을 저장하고 컴플리트함.
greetings.onCompleted()

//에러가 발생하면 그 즉시 에러를 방출하고 종료된다.
languages.onError(MyError.error)
// Bye Swift로 출려됨
languages.onNext("Swift")
languages.onCompleted()






    




