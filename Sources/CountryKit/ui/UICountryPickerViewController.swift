//
//  UICountryPickerViewController.swift
//  CountryKit
//
//  Created by eclypse on 11/30/23.
//

import UIKit
import Combine

open class UICountryPickerViewController: UIViewController {
    
    @IBOutlet public weak var searchBar: UISearchBar!
    @IBOutlet public weak var pickerView: UITableView!
    @IBOutlet public weak var pinnedHeaderDirections: UILabel!
    @IBOutlet public weak var pinnedFooterDirections: UILabel!
    @IBOutlet private weak var headerDirectionsContainer: UIView!
    @IBOutlet private weak var footerDirectionsContainer: UIView!

    public init() {
        super.init(nibName: String(describing: UICountryPickerViewController.self), bundle: CountryKit.assetBundle)
    }
    
    public required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    /// presenter gets initialized after view did load via lateInitPresenter() function
    open var presenter: CountryPickerPresenter!
    
    /// combine support - cancels listeners.
    private var cancellables: Set<AnyCancellable> = []
    
    /// this relay gets fired everytime user makes a selection in the UI. true value
    /// indicates that selection was made whereas false value indicates a deselection was made.
    public var countrySelectionRelay = PassthroughSubject<(Country, Bool), Never>()
    
    /// this relay gets fired right before this view controller is dismissed with all the selected countries.
    public var countrySelectionFinishedRelay = PassthroughSubject<[Country], Never>()
    
    /// user canceled country selections by backing out from the UI
    public var countrySelectionWasCanceled = PassthroughSubject<Void, Never>()
    
    /// get notified everytime user makes a selection or deselection
    public var delegate: UICountryPickerDelegate?
    
    ///register a config file to change the behavior of this country selection interface
    open var countryPickerConfiguration: CountryPickerConfiguration = .default()
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view.
        configureNavBarButtons()
        lateInitPresenter()
        configureMainView()
        configureHeaderFooterViews()
        configureTheme()
        configureSearchBar()
        configureBindings()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        presenter.tearDown()
    }
    
    /// performs configuration of built-in navigation bar buttons.
    open func configureNavBarButtons() {
        if let validLeftBarButtonItem = countryPickerConfiguration.leftBarButton {
            navigationItem.leftBarButtonItem = validLeftBarButtonItem
            navigationItem.leftItemsSupplementBackButton = false
        } else {
            let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
            navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didSelectBack(_:)))
            navigationItem.leftItemsSupplementBackButton = false
        }

        if let validRightBarButtonItem = countryPickerConfiguration.rightBarButton {
            navigationItem.rightBarButtonItem = validRightBarButtonItem
        } else {
            navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didSelectDone(_:)))
        }
    }
    
    /// performs configuration of non-scrolling header and footer views
    open func configureHeaderFooterViews() {
        if let validHeaderText = countryPickerConfiguration.pinnedHeaderText {
            if let validFont = countryPickerConfiguration.themeFont {
                pinnedHeaderDirections.font = validFont
            }
            pinnedHeaderDirections.text = validHeaderText
            headerDirectionsContainer.isHidden = false
        } else {
            headerDirectionsContainer.isHidden = true
        }
        
        if let validFooterText = countryPickerConfiguration.pinnedFooterText {
            if let validFont = countryPickerConfiguration.themeFont {
                pinnedFooterDirections.font = validFont
            }
            pinnedFooterDirections.text = validFooterText
            footerDirectionsContainer.isHidden = false
        } else {
            footerDirectionsContainer.isHidden = true
        }
    }
    
    ///
    open func lateInitPresenter() {
        let bundleLoader = BundleLoaderImpl(fileManager: FileManager.default, bundle: CountryKit.assetBundle)
        let textHighlighter = TextHighlighterImpl()
        let countryProvider = CountryProviderImpl(bundleLoader: bundleLoader)
        let presenterQueue = DispatchQueue(label: "countrykit.queue.presenter")
        presenter = CountryPickerPresenter(countryProvider: countryProvider,
                                              textHighlighter: textHighlighter,
                                              presenterQueue: presenterQueue)
    }
    
    open func configureTheme() {
        if let validThemeFont = countryPickerConfiguration.themeFont {
            searchBar.searchTextField.font = validThemeFont
            pinnedHeaderDirections.font = countryPickerConfiguration.themeFont
            pinnedFooterDirections.font = countryPickerConfiguration.themeFont
        }
        
        if let validNavBarTitleView = countryPickerConfiguration.navigationBarTitleView {
            navigationItem.titleView = validNavBarTitleView
        }
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
                        strongSelf.pickerView.selectRow(at: cellSelectionMeta.indexPath, animated: false, scrollPosition: .none)
                    } else {
                        strongSelf.pickerView.deselectRow(at: cellSelectionMeta.indexPath, animated: false)
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
        
        presenter.register(config: self.countryPickerConfiguration)
        presenter.configureBindings()
    }
    
    open func configureMainView() {
        presenter.configureDataSource(with: pickerView)
        pickerView.delegate = presenter
        pickerView.register(CountryCell.nib, forCellReuseIdentifier: CountryCell.nibName)
        pickerView.register(FooterCell.nib, forCellReuseIdentifier: FooterCell.nibName)
        
        pickerView.allowsSelection = countryPickerConfiguration.allowsSelection
        pickerView.allowsMultipleSelection = countryPickerConfiguration.canMultiSelect
        pickerView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: 150, right: 0)
        pickerView.tableFooterView = UIView()
        pickerView.separatorStyle = .singleLine
        pickerView.estimatedRowHeight = CGFloat(44)
        pickerView.rowHeight = UITableView.automaticDimension
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
        delegate?.didCancel()
        
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
}

extension UICountryPickerViewController: UISearchBarDelegate {
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
