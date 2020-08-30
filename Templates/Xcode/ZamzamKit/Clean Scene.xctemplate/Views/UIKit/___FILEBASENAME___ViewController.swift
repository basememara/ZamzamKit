//___FILEHEADER___

import UIKit
import ZamzamCore
import ZamzamUI

class ___VARIABLE_productName:identifier___ViewController: UIViewController {
    private let state: ___VARIABLE_productName:identifier___State
    private let interactor: ___VARIABLE_productName:identifier___Interactable?
    private var render: ___VARIABLE_productName:identifier___Renderable?
    
    // MARK: - Control
    
    private lazy var tableView = UITableView(
        frame: .zero,
        style: .grouped
    ).apply {
        $0.delegate = self
        $0.dataSource = self
    }

    private lazy var activityIndicatorView = view.makeActivityIndicator()
    
    // MARK: - Initializers
    
    init(
        state: ___VARIABLE_productName:identifier___State,
        interactor: ___VARIABLE_productName:identifier___Interactable?,
        render: ((UIViewController) -> ___VARIABLE_productName:identifier___Renderable)?
    ) {
        self.state = state
        self.interactor = interactor
        
        super.init(nibName: nil, bundle: nil)
        self.render = render?(self)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) { nil }
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
        prepare()
        fetch()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        state.subscribe(load)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        state.unsubscribe()
    }
}

// MARK: - Setup

private extension ___VARIABLE_productName:identifier___ViewController {
    
    func prepare() {
        // Configure controls
        navigationItem.title = "Title"
        activityIndicatorView.startAnimating()
        
        // Compose layout
        view.addSubview(tableView)
        tableView.edges(to: view)
    }

    func fetch() {
        interactor?.fetch(
            with: ___VARIABLE_productName:identifier___API.FetchRequest()
        )
    }
    
    func load(_ result: StateChange<___VARIABLE_productName:identifier___State>) {
        switch result {
        case .updated(\___VARIABLE_productName:identifier___State.posts), .initial:
            tableView.reloadData()
        case let .failure(error):
            present(alert: error.title, message: error.message)
        default:
            break
        }
    }
}

// MARK: - Interactions

private extension ___VARIABLE_productName:identifier___ViewController {

}

// MARK: - Delegates

extension ___VARIABLE_productName:identifier___ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        
        guard let cell = tableView.cellForRow(at: indexPath),
            let item = state.moreMenu[safe: indexPath.section]?.items[safe: indexPath.row] else {
                return
        }
        
        render?.select(menu: item, from: cell)
    }
}

extension ___VARIABLE_productName:identifier___ViewController: UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        state.moreMenu.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        state.moreMenu[safe: section]?.items.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        state.moreMenu[safe: section]?.title ??+ nil
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let item = state.moreMenu[safe: indexPath.section]?
            .items[safe: indexPath.row] else {
                return UITableViewCell()
        }
        
        return UITableViewCell(style: .default, reuseIdentifier: nil).apply {
            $0.textLabel?.text = item.title
            $0.imageView?.image = UIImage(named: item.icon)
        }
    }
}
