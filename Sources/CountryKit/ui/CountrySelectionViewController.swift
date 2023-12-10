//
//  ViewController.swift
//  countrykit_example
//
//  Created by Turker Nessa on 11/30/23.
//

import UIKit
import Combine

class CountrySelectionViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var mainView: UITableView!
    @IBOutlet private weak var countrySelectionDirections: UILabel!
    private var _presenterQueue: DispatchQueue!

    private var presenter: CountrySelectionPresenter!
    private var cancellables: Set<AnyCancellable> = []
    var countrySelectionObserver: PassthroughSubject<[Country], Error>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        performDelayedInitialization()
        configureMainView()
        configureSearchBar()
        configureBindings()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        presenter.tearDown()
    }
    
    private func performDelayedInitialization() {
        let textHighlighter = TextHighlighterImpl()
        let countryProvider = CountryProviderImpl()
        let presenterQueue = DispatchQueue(label: "queue.presenter")
        self._presenterQueue = presenterQueue
        presenter = CountrySelectionPresenter(countryProvider: countryProvider,
                                              textHighlighter: textHighlighter,
                                              presenterQueue: presenterQueue)
    }
    
    private func configureBindings() {
        presenter.dismissView
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController?.dismiss(animated: true)
            })
            .store(in: &cancellables)
        
        presenter.countrySelectionRelay
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] (eachIndexPath, selected) in
                guard let strongSelf = self else { return }
                if selected {
                    strongSelf.mainView.selectRow(at: eachIndexPath, animated: false, scrollPosition: .none)
                } else {
                    strongSelf.mainView.deselectRow(at: eachIndexPath, animated: false)
                }
            }).store(in: &cancellables)
        
        presenter.configureBindings()
    }
    
    private func configureMainView() {
        presenter.configureDataSource(with: mainView)
        mainView.delegate = presenter
        mainView.register(CountryCell.nib, forCellReuseIdentifier: CountryCell.nibName)
        mainView.register(FooterCell.nib, forCellReuseIdentifier: FooterCell.nibName)
        
        mainView.allowsMultipleSelection = true
        mainView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 150, right: 0)
        mainView.tableFooterView = UIView()
        mainView.separatorStyle = .singleLine
        mainView.estimatedRowHeight = CGFloat(44)
        mainView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureSearchBar() {
        searchBar.returnKeyType = .done
        searchBar.delegate = self
    }
    
    func didSelectDone() {
        countrySelectionObserver?.send(presenter.getSelectedCountries())
    }
    
    ///register a config file to change the behavior of this country selection interface
    func register(countrySelectionConfig: CountrySelectionConfig) {
        presenter.register(config: countrySelectionConfig)
    }
}

extension CountrySelectionViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarRelay.send(searchText)
    }
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(false)
    }

    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarRelay.send("")
        self.view.endEditing(false)
    }
    
    func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
