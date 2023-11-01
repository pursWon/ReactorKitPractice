import UIKit
import ReactorKit
import RxCocoa
import SnapKit

class BeerImageViewController: UIViewController, View {
    let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.backgroundColor = .systemGray4
        
        return imageView
    }()
    
    let generateButton: UIButton = {
        let button = UIButton()
        button.setTitle("Generate", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.backgroundColor = .orange
        
        return button
    }()
    
    var disposeBag = DisposeBag()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = ""
        view.backgroundColor = .white
        
        addViews()
    }
    
    init(reactor: MyReactor) {
        super.init(nibName: nil, bundle: nil)
        self.reactor = reactor
    }
    
    required init?(coder: NSCoder) {
        fatalError()
    }
    
    // bindAction : View에서 Reactor로 이벤트 방출
    func bindAction(_ reactor: MyReactor) {
        generateButton.rx.tap
            .map { Reactor.Action.generate }
            .bind(to: reactor.action)
            .disposed(by: disposeBag)
    }
    
    func addViews() {
        [imageView, generateButton].forEach {
            view.addSubview($0)
        }
        setLayout()
    }
    
    func setLayout() {
        imageView.snp.makeConstraints {
            $0.leading.equalTo(40)
            $0.trailing.equalTo(-40)
            $0.top.equalTo(100)
        }
        
        generateButton.snp.makeConstraints {
            $0.leading.equalTo(80)
            $0.trailing.equalTo(-80)
            $0.top.equalTo(imageView.snp_bottomMargin).offset(100)
            $0.bottom.equalTo(-80)
        }
    }
    
    func bind(reactor: MyReactor) {
        bindAction(reactor)
        bindState(reactor)
    }
    
    // bindState : Reactor에서 바뀐 state들을 View에서 구독
    func bindState(_ reactor: MyReactor) {
        reactor.state.bind { self.imageView.load(imageString: $0.url) }.disposed(by: disposeBag)
    }
}

extension UIImageView {
    func load(imageString: String) {
        DispatchQueue.global().async { [weak self] in
            guard let imageURL = URL(string: imageString) else { return }
            
            if let data = try? Data(contentsOf: imageURL) {
                if let image = UIImage(data: data) {
                    DispatchQueue.main.async {
                        self?.image = image
                    }
                }
            }
        }
    }
}
