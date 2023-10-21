import UIKit
import ReactorKit
import RxSwift
import RxCocoa

class CounterViewController: UIViewController, StoryboardView {
    @IBOutlet weak var countLabel: UILabel!
    @IBOutlet weak var increaseButton: UIButton!
    @IBOutlet weak var decreaseButton: UIButton!
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        countLabel.backgroundColor = .systemTeal
        increaseButton.backgroundColor = .systemGray5
    }
    
    func bind(reactor: CounterViewReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // bindAction : View에서 Reactor로 이벤트 방출
    func bindAction(_ reactor: CounterViewReactor) {
        increaseButton.rx.tap
            .map { Reactor.Action.increase }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
        
        decreaseButton.rx.tap
            .map { Reactor.Action.decrease }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    // bindState : Reactor에서 바뀐 state들을 View에서 구독
    func bindState(_ reactor: CounterViewReactor) {
        reactor.state
            .map { String($0.value) }
            .distinctUntilChanged()
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
}

