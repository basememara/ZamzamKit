//___FILEHEADER___

/* Replace with following if only supporting SwiftUI
import Combine
import ZamzamUI

class ___VARIABLE_productName:identifier___State: StateRepresentable, ObservableObject {
    @Published public private(set) var tabMenu: [___VARIABLE_productName:identifier___API.TabItem] = []
}
*/

import Foundation.NSNotification
import ZamzamUI

class ___VARIABLE_productName:identifier___State: StateRepresentable {
    private var cancellable: NotificationCenter.Cancellable?
    
    // MARK: - Observables
    
    private(set) var tabMenu: [___VARIABLE_productName:identifier___API.TabItem] = [] {
        willSet {
            guard newValue != tabMenu, #available(iOS 13, *) else { return }
            combineSend()
        }
        
        didSet {
            guard oldValue != tabMenu else { return }
            notificationPost(for: \Self.tabMenu)
        }
    }
}

extension ___VARIABLE_productName:identifier___State {
    
    func subscribe(_ observer: @escaping (StateChange<___VARIABLE_productName:identifier___State>) -> Void) {
        subscribe(observer, in: &cancellable)
    }
    
    func unsubscribe() {
        cancellable = nil
    }
}

// MARK: - Action

enum ___VARIABLE_productName:identifier___Action: Action {
    case loadMenu([___VARIABLE_productName:identifier___API.TabItem])
}

// MARK: - Reducer

extension ___VARIABLE_productName:identifier___State {
    
    func callAsFunction(_ reducer: ___VARIABLE_productName:identifier___Action) {
        switch action {
        case .loadMenu(let menu):
            tabMenu = menu
        }
    }
}

// MARK: - SwiftUI

#if canImport(SwiftUI)
import Combine

@available(iOS 13, *)
extension ___VARIABLE_productName:identifier___State: ObservableObject {}
#endif
