//
//  ViewController.swift
//  CountryKit
//
//  Created by eclypse on 11/30/23.
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
    public var countrySelectionWasCanceled = PassthroughSubject<Void, Never>()
    
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
        if let validLeftBarButtonItem = countrySelectionConfiguration.leftBarButton {
            navigationItem.leftBarButtonItem = validLeftBarButtonItem
            navigationItem.leftItemsSupplementBackButton = false
        } else {
            let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didSelectBack(_:)))
            navigationItem.leftItemsSupplementBackButton = false
        }

        if let validRightBarButtonItem = countrySelectionConfiguration.rightBarButton {
            navigationItem.rightBarButtonItem = validRightBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didSelectDone(_:)))
        }
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
                guard let strongSelf = self else { return }
                strongSelf.didSelectDone(strongSelf)
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
        
        presenter.register(config: self.countrySelectionConfiguration)
        presenter.configureBindings()
    }
    
    open func configureMainView() {
        presenter.configureDataSource(with: mainView)
        mainView.delegate = presenter
        mainView.register(CountryCell.nib, forCellReuseIdentifier: CountryCell.nibName)
        mainView.register(FooterCell.nib, forCellReuseIdentifier: FooterCell.nibName)
        
        mainView.allowsSelection = countrySelectionConfiguration.allowsSelection
        mainView.allowsMultipleSelection = countrySelectionConfiguration.canMultiSelect
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
    
    /// convenience function for obtaining currently selected countries
    open func getSelectedCountries() -> Set<Country> {
        return presenter.formSelectedCountries
    }
    
    @objc
    open func didSelectDone(_ sender: Any?) {
        let selectedCountries = Array(presenter.formSelectedCountries)
        countrySelectionFinishedRelay.send(selectedCountries)
        delegate?.didFinishSelecting(countries: selectedCountries)
        
        dismissSelf()
    }
    
    @objc
    open func didSelectBack(_ sender: Any?) {
        countrySelectionWasCanceled.send(())
        delegate?.didBackout()
        
        dismissSelf()
    }
    
    
    /// controls how should this view controller be removed from the view hierarchy.
    /// override this to control the dismissing behavior.
    open func dismissSelf() {
        let isModal: Bool
        if let index = navigationController?.viewControllers.firstIndex(of: self), index > 0 {
            isModal = false
        } else if presentingViewController != nil {
            isModal = true
        } else if navigationController?.presentingViewController?.presentedViewController == navigationController {
            isModal = true
        } else if tabBarController?.presentingViewController is UITabBarController {
            isModal = true
        } else {
            isModal = false
        }
        
        if isModal {
            dismiss(animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }
    
    ///register a config file to change the behavior of this country selection interface
    open var countrySelectionConfiguration: CountrySelectionConfiguration = .default()
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
