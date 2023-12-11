//
//  ViewController.swift
//  countrykit_example
//
//  Created by Turker Nessa on 11/30/23.
//

import UIKit
import Combine

open class CountrySelectionViewController: UIViewController {
    
    @IBOutlet private weak var searchBar: UISearchBar!
    @IBOutlet private weak var mainView: UITableView!
    @IBOutlet private weak var countrySelectionDirections: UILabel!

    open var presenter: CountrySelectionPresenter!
    private var cancellables: Set<AnyCancellable> = []
    
    /// this relay gets fired everytime user makes a selection in the UI. true value
    /// indicates that selection was made whereas false value indicates a deselection was made.
    public var countrySelectionRelay = PassthroughSubject<(Country, Bool), Never>()
    
    /// this relay gets fired right before this view controller is dismissed with all the selected countries.
    public var countrySelectionFinishedRelay = PassthroughSubject<[Country], Never>()
    
    /// user canceled country selections by backing out from the UI
    public var countrySelectionWasBackedOut = PassthroughSubject<Void, Never>()
    
    /// get notified everytime user makes a selection or deselection
    public var delegate: CountrySelectionDelegate?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureNavBarButtons()
        performDelayedInitialization()
        configureMainView()
        configureSearchBar()
        configureBindings()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        presenter.tearDown()
    }
    
    open func configureNavBarButtons() {
        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didSelectBack(_:)))
        navigationItem.leftItemsSupplementBackButton = false
        
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didSelectDone(_:)))
    }
    
    open func performDelayedInitialization() {
        let textHighlighter = TextHighlighterImpl()
        let countryProvider = CountryProviderImpl()
        let presenterQueue = DispatchQueue(label: "countrykit.queue.presenter")
        presenter = CountrySelectionPresenter(countryProvider: countryProvider,
                                              textHighlighter: textHighlighter,
                                              presenterQueue: presenterQueue)
    }
    
    open func configureBindings() {
        presenter.dismissView
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] _ in
                self?.navigationController?.popViewController(animated: true)
            })
            .store(in: &cancellables)
        
        presenter.countrySelectionRelay
            .receive(on: DispatchQueue.main)
            .sink(receiveValue: { [weak self] cellSelectionMeta in
                guard let strongSelf = self else { return }
                if cellSelectionMeta.performCellSelection {
                    if cellSelectionMeta.isSelected {
                        strongSelf.mainView.selectRow(at: cellSelectionMeta.indexPath, animated: false, scrollPosition: .none)
                    } else {
                        strongSelf.mainView.deselectRow(at: cellSelectionMeta.indexPath, animated: false)
                    }
                }
                
                if cellSelectionMeta.isSelected {
                    strongSelf.delegate?.didSelect(country: cellSelectionMeta.country)
                    strongSelf.countrySelectionRelay.send((cellSelectionMeta.country, true))
                } else {
                    strongSelf.delegate?.didDeselect(country: cellSelectionMeta.country)
                    strongSelf.countrySelectionRelay.send((cellSelectionMeta.country, false))
                }
                
            }).store(in: &cancellables)
        
        presenter.configureBindings()
    }
    
    open func configureMainView() {
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
    
    open func configureSearchBar() {
        searchBar.returnKeyType = .done
        searchBar.delegate = self
    }
    
    @objc
    open func didSelectDone(_ sender: Any?) {
        let selectedCountries = Array(presenter.formSelectedCountries)
        countrySelectionFinishedRelay.send(selectedCountries)
        delegate?.didFinishSelecting(countries: selectedCountries)
        
        navigationController?.popViewController(animated: true)
    }
    
    @objc
    open func didSelectBack(_ sender: Any?) {
        countrySelectionWasBackedOut.send(())
        delegate?.didBackout()
        
        navigationController?.popViewController(animated: true)
    }
    
    ///register a config file to change the behavior of this country selection interface
    open func register(countrySelectionConfig: CountrySelectionConfig) {
        presenter.register(config: countrySelectionConfig)
    }
}

extension CountrySelectionViewController: UISearchBarDelegate {
    public func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.searchBarRelay.send(searchText)
    }
    
    public func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.view.endEditing(false)
    }

    public func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        presenter.searchBarRelay.send("")
        self.view.endEditing(false)
    }
    
    public func searchBarTextDidEndEditing(_ searchBar: UISearchBar) {
        self.view.endEditing(true)
    }
}
