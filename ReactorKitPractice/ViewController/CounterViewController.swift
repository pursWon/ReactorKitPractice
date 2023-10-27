import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class CounterViewController: UIViewController, View {
    let countLabel: UILabel = UILabel()
    let increaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("+", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let decreaseButton: UIButton = {
        let button = UIButton()
        button.setTitle("-", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    let buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 60
        stackView.distribution = .fillEqually
        
        return stackView
    }()
    
    let moveButton: UIButton = {
        let button = UIButton()
        button.setTitle("Move", for: .normal)
        button.setTitleColor(.black, for: .normal)
        
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        addViews()
        setBackGroundColor()
        moveButtonClicked()
        
        reactor?.loadRandomBeerImage(myBeer: { beer in
            print(beer.imageURL)
        })
    }
    
    func bind(reactor: MyReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    func addViews() {
        [countLabel, buttonStackView, moveButton].forEach {
            view.addSubview($0)
        }
        
        [increaseButton, decreaseButton].forEach {
            buttonStackView.addArrangedSubview($0)
        }
        
        setLayOut()
        setTextalignment()
    }
    
    func setBackGroundColor() {
        view.backgroundColor = .white
        countLabel.backgroundColor = .systemTeal
        increaseButton.backgroundColor = .systemGray5
        decreaseButton.backgroundColor = .systemGray5
        moveButton.backgroundColor = .link
        buttonStackView.backgroundColor = .white
    }
    
    func setLayOut() {
        countLabel.snp.makeConstraints {
            $0.leading.equalTo(50)
            $0.trailing.equalTo(-50)
            $0.top.equalTo(150)
        }
        
        increaseButton.snp.makeConstraints {
            $0.width.height.equalTo(50)
        }
        
        buttonStackView.snp.makeConstraints {
            $0.leading.equalTo(70)
            $0.trailing.equalTo(-70)
            $0.top.equalTo(500)
            $0.center.equalToSuperview()
        }
        
        moveButton.snp.makeConstraints {
            $0.leading.equalTo(100)
            $0.trailing.equalTo(-100)
            $0.bottom.equalTo(-100)
            $0.top.equalTo(buttonStackView.snp_bottomMargin).offset(130)
        }
    }
    
    func setTextalignment() {
        countLabel.textAlignment = .center
    }
    
    // bindAction : View에서 Reactor로 이벤트 방출
    func bindAction(_ reactor: MyReactor) {
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
    func bindState(_ reactor: MyReactor) {
        reactor.state
            .map { String($0.value) }
            .distinctUntilChanged()
            .bind(to: countLabel.rx.text)
            .disposed(by: disposeBag)
    }
    
    func moveButtonClicked() {
        let beerImageVC = BeerImageViewController()
        moveButton.rx.tap.subscribe(onNext: { self.navigationController?.pushViewController(beerImageVC, animated: true) }).disposed(by: disposeBag)
    }
}

