//
//  ViewController.swift
//  countrykit_example
//
//  Created by Turker Nessa on 11/30/23.
//

import UIKit
import Combine

class ViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var mainView: UITableView!
    @IBOutlet private weak var countrySelectionDirections: UILabel!
    private var _presenterQueue: DispatchQueue!

    private var presenter: CountrySelectionPresenter!
    var countrySelectionObserver: PassthroughSubject<[Country], Error>?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        performDelayedInitialization()
        configureMainView()
        configureNavBar()
        configureSearchBar()
        configureBindings()
    }
    
    deinit {
        presenter.tearDown()
    }
    
    private func performDelayedInitialization() {
        let textHighlighter = TextHighlighterImpl()
        let countryProvider = CountryProviderImpl()
        let presenterQueue = DispatchQueue(label: "presenter.queue")
        self._presenterQueue = presenterQueue
        presenter = CountrySelectionPresenter(countryProvider: countryProvider,
                                              textHighlighter: textHighlighter,
                                              presenterQueue: presenterQueue)
    }
    
    private func configureBindings() {
//        presenter.shouldReloadTable
//        .receive(on: DispatchQueue.main)
//        .sink(receiveCompletion: { completed in
//            
//        }, receiveValue: { [weak self] _ in
//            guard let strongSelf = self else { return }
//            if strongSelf.presenter.countrySelectionConfig.canMultiSelect {
//                strongSelf.countrySelectionDirections.text = "title_select_one_or_more_countries".localized()
//            } else {
//                strongSelf.countrySelectionDirections.text = "title_select_single_country".localized()
//            }
//            strongSelf.mainView.reloadData()
//        }).cancel()
        
        presenter.dismissView
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completed in
                
            }, receiveValue: { [weak self] _ in
                //do something
            })
        .cancel()
        
        presenter.countrySelectionSubject
            .receive(on: DispatchQueue.main)
            .sink(receiveCompletion: { completed in
                
            }, receiveValue: { [weak self] (eachIndexPath, selected) in
                guard let strongSelf = self else { return }
                if selected {
                    //strongSelf.mainView.selectRow(at: eachIndexPath, animated: false, scrollPosition: .none)
                    if let cell = strongSelf.mainView.cellForRow(at: eachIndexPath) as? SelectableCell {
                        cell.performSelection()
                    }
                } else {
                    //strongSelf.mainView.deselectRow(at: eachIndexPath, animated: false)
                    if let cell = strongSelf.mainView.cellForRow(at: eachIndexPath) as? SelectableCell {
                        cell.performDeselection()
                    }
                }
            })
            .cancel()
        
        presenter.configureBindings()
    }
    
    private func configureMainView() {
        presenter.configureDataSource(with: mainView)
        mainView.delegate = presenter
        mainView.register(CountryCell.nib, forCellReuseIdentifier: CountryCell.nibName)
        mainView.register(FooterCell.nib, forCellReuseIdentifier: FooterCell.nibName)
        
        mainView.allowsSelection = false
        mainView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 150, right: 0)
        mainView.tableFooterView = UIView()
        mainView.separatorStyle = .singleLine
        mainView.estimatedRowHeight = CGFloat(44)
        mainView.rowHeight = UITableView.automaticDimension
    }
    
    private func configureNavBar() {
        /*
        let navTitleLabel = NavBarView.fromNib
        navTitleLabel.configureTitle(titleText: "countries_or_regions".local)
        self.navigationItem.titleView = navTitleLabel
        
        configureSaveButton(alsoDismissView: true, buttonFlavor: .save)
        configureCancelButton(asSupplementalButton: false)
         */
    }
    
    private func configureSearchBar() {
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        
        //RxSearchBarDelegateProxy doesn't work as of April/20/2020 in Catalyst
        //see issue here: https://github.com/ReactiveX/RxSwift/issues/2161
        
        //binds search bar changes and delegates the searching to the provider
        /*
        searchBar
            .rx.text // Observable property thanks to RxCocoa
            
            .orEmpty // Make it non-optional
            .skip(1)
            .debounce(RxTimeInterval.milliseconds(300), scheduler: MainScheduler.instance) // Wait 0.3 for changes.
            .distinctUntilChanged() // If they didn't occur, check if the new value is the same as old.
            //.filter { !$0.isEmpty } // If the new value is really new, filter for non-empty query.
            //.observe(on: NetworkScheduler(qos: .background))
            .observe(on: MainScheduler.asyncInstance)
            .subscribe(onNext: { [weak self] query in // Here we subscribe to every new value, that is not empty (thanks to filter above).
                guard let strongSelf = self else { return }
                strongSelf.presenter.apply(searchQuery: query)
                if query.isEmpty {
                    DispatchQueue.main.async {
                        strongSelf.searchBar.resignFirstResponder()
                    }
                }
            })
            .disposed(by: disposeBag)
        */
    }
    
    func didSelectDone() {
        countrySelectionObserver?.send(presenter.getSelectedCountries())
    }
    
    ///register a config file to change the behavior of this country selection interface
    func register(countrySelectionConfig: CountrySelectionConfig) {
        presenter.register(config: countrySelectionConfig)
    }
}

extension ViewController: UISearchBarDelegate {
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
