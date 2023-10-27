import UIKit
import RxSwift
import ReactorKit
import Alamofire

class MyReactor: Reactor {
    let initialState = State()
    
    // View로부터 받을 Action을 enum으로 정의
    enum Action {
        case increase
        case decrease
        case generate
    }
    
    // View로부터 action을 받은 경우, 해야할 작업단위들을 enum으로 정의
    // 처리 단위
    enum Mutation {
        case increaseValue
        case decreaseValue
        case loadData
    }
    
    // 현재 상태를 기록하고 있으며, View에서 해당 정보를 사용하여 UI업데이트 및 Reactor에서 image를 얻어올때 page정보들을 저장
    struct State {
        var value = 0
        var isLoading = false
        var beer: Beer = Beer(name: "", imageURL: "")
    }
    
    // Action이 들어온 경우, 어떤 처리를 할것인지 Mutation에서 정의한 작업 단위들을 사용하여 Observable로 방출
    // 해당 부분에서, RxSwift의 concat 연산자를 이용하여 비동기 처리가 유용
    // concat 연산자: 여러 Observable이 배열로 주어지면 순서대로 실행
    func mutate(action: Action) -> Observable<Mutation> {
        switch action {
        case .increase:
            return Observable.just(.increaseValue)
        case .decrease:
            return Observable.just(.decreaseValue)
        case .generate:
            return Observable.just(.loadData)
        }
    }
    
    // 이전 상태와 처리 단위를 받아서 다음 상태를 반환하는 함수
    // 현재 상태(state)와 작업 단위(mutation)을 받아서, 최종 상태를 반환
    // mutate(action:) -> Observable<Mutation>이 실행된 후 바로 해당 메소드 실행
    func reduce(state: State, mutation: Mutation) -> State {
        var newState = state
        
        switch mutation {
        case .increaseValue:
            newState.value += 1
        case .decreaseValue:
            newState.value -= 1
        case .loadData:
            loadRandomBeerImage { myBeer in
                newState.beer = myBeer
            }
        }
        
        return newState
    }
    
    func loadRandomBeerImage(myBeer: @escaping (Beer) -> Void) {
        let url: String = "https://api.punkapi.com/v2/beers/random"
        
        AF.request(url, method: .get, parameters: nil).responseDecodable(of: [Beer].self) { response in
            guard let data = response.value else { return }
            myBeer(data[0])
        }
    }
}
