//
//  UICountryPickerViewController.swift
//  CountryKit
//
//  Created by eclypse on 11/30/23.
//

import UIKit
import Combine

@objc
public protocol ToolbarActionsResponder: NSObjectProtocol {
    @objc optional func clearSelections(_ sender: Any?)
}

open class UICountryPickerViewController: UIViewController {
    
    @IBOutlet public weak var searchBar: UISearchBar!
    @IBOutlet public weak var pickerView: UITableView!
    @IBOutlet public weak var pinnedHeaderDirections: UILabel!
    @IBOutlet public weak var pinnedFooterDirections: UILabel!
    @IBOutlet public weak var headerDirectionsContainer: UIView!
    @IBOutlet public weak var footerDirectionsContainer: UIView!
    @IBOutlet public weak var bottomToolbar: UIView!
    @IBOutlet public weak var bottomToolbarHeight: NSLayoutConstraint!
    
    @IBOutlet public weak var cancelButtonMacStyle: UIButton!
    @IBOutlet public weak var doneButtonMacStyle: UIButton!
    public var searchBarMacStyle: UISearchBar? //this search bar is added to the toolbar to make it more mac-like

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
        configureNotificationListening()
        configureBottomBar()
    }
    
    deinit {
        cancellables.forEach { $0.cancel() }
        presenter.tearDown()
    }
    
    /// performs configuration of built-in navigation bar buttons.
    open func configureNavBarButtons() {
        #if targetEnvironment(macCatalyst)
        //hide the navigation bar for catalyst
        navigationController?.setNavigationBarHidden(true, animated: false)
        navigationController?.setToolbarHidden(true, animated: true)
        #else
        //check to see if the picker UI is presented in a navigation controller
        if let validNavController = self.navigationController {
            if let validLeftBarButtonItem = countryPickerConfiguration.leftBarButton {
                //use the provided left bar button
                navigationItem.leftBarButtonItem = validLeftBarButtonItem
                navigationItem.leftItemsSupplementBackButton = false
            } else {
                switch countryPickerConfiguration.navBarButtonOption {
                case .displayLeadingButtonOnly, .displayBothButtons:
                    //there is no left bar button.
                    if self == validNavController.viewControllers.first {
                        //if this view controller is at the root of the navigation hierarchy
                        //we should present it with a dismiss/cancel button
                        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .close, target: self, action: #selector(didSelectBack(_:)))
                    } else {
                        //this view controller is somewhere in the navigation stack
                        //we should present it with a back button
                        let backButtonImage = UIImage(systemName: "chevron.backward", withConfiguration: UIImage.SymbolConfiguration(weight: .semibold))
                        navigationItem.leftBarButtonItem = UIBarButtonItem(image: backButtonImage, style: .plain, target: self, action: #selector(didSelectBack(_:)))
                    }
                    navigationItem.leftItemsSupplementBackButton = false
                case .displayTrailingButtonOnly:
                    navigationItem.hidesBackButton = true
                }
            }
            
            if let validRightBarButtonItem = countryPickerConfiguration.rightBarButton {
                navigationItem.rightBarButtonItem = validRightBarButtonItem
            } else {
                switch countryPickerConfiguration.navBarButtonOption {
                case .displayTrailingButtonOnly, .displayBothButtons:
                    navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(didSelectDone(_:)))
                default:
                    break
                }
            }
        } else {
            //there is no navigation controller, there is no point in setting navigation bar buttons
        }
        #endif
    }
    
    /// configures bottom bar - only applicable for mac catalyst
    open func configureBottomBar() {
        #if targetEnvironment(macCatalyst)

        //create titles to obtain localized versions of Done/Cancel phrases
        let uikitBundle = Bundle(for: UIButton.self)
        let doneTitle = uikitBundle.localizedString(forKey: "Done", value: nil, table: nil)
        let cancelTitle = uikitBundle.localizedString(forKey: "Cancel", value: nil, table: nil)

        if let providedDoneButtonTitle = countryPickerConfiguration.macConfiguration.doneButtonTitle {
            doneButtonMacStyle.setTitle(providedDoneButtonTitle, for: .normal)
        } else {
            doneButtonMacStyle.setTitle(doneTitle, for: .normal)
        }
        
        if let providedCancelButtonTitle = countryPickerConfiguration.macConfiguration.cancelButtonTitle {
            cancelButtonMacStyle.setTitle(providedCancelButtonTitle, for: .normal)
        } else {
            cancelButtonMacStyle.setTitle(cancelTitle, for: .normal)
        }
        
        doneButtonMacStyle.addTarget(self, action: #selector(didSelectDone(_:)), for: .touchUpInside)
        cancelButtonMacStyle.addTarget(self, action: #selector(didSelectBack(_:)), for: .touchUpInside)
        
        if let providedBottomToolbarColor = countryPickerConfiguration.macConfiguration.bottomToolbarColor {
            bottomToolbar.backgroundColor = providedBottomToolbarColor
        }
        
        bottomToolbarHeight.constant = 44
        bottomToolbar.isHidden = false
        
        #else
        
        bottomToolbarHeight.constant = 0
        bottomToolbar.isHidden = true
        
        #endif
    }
    
    /// performs configuration of non-scrolling header and footer views
    open func configureHeaderFooterViews() {
        if let validHeaderText = countryPickerConfiguration.pinnedHeaderText {
            if let validFont = countryPickerConfiguration.theme.font {
                pinnedHeaderDirections.font = validFont
            }
            pinnedHeaderDirections.text = validHeaderText
            headerDirectionsContainer.isHidden = false
        } else {
            headerDirectionsContainer.isHidden = true
        }
        
        if let validFooterText = countryPickerConfiguration.pinnedFooterText {
            if let validFont = countryPickerConfiguration.theme.font {
                pinnedFooterDirections.font = validFont
            }
            pinnedFooterDirections.text = validFooterText
            footerDirectionsContainer.isHidden = false
        } else {
            footerDirectionsContainer.isHidden = true
        }
    }
    
    /// initializes injectable classes that are required for the CountryPickerPresenter.
    /// override it to modify the behavior of the dependent classes
    open func lateInitPresenter() {
        let textHighlighter = TextHighlighterImpl()
        let countryFilteringMethod = CountryFilteringMethodImpl(textHighlighter: textHighlighter)
        let countryProvider = CountryProviderImpl()
        let presenterQueue = DispatchQueue(label: "countrykit.queue.presenter")
        presenter = CountryPickerPresenter(countryProvider: countryProvider,
                                           countryFilteringMethod: countryFilteringMethod,
                                           presenterQueue: presenterQueue)
    }
    
    open func configureTheme() {
        if let validThemeFont = countryPickerConfiguration.theme.font {
            searchBar.searchTextField.font = validThemeFont
            pinnedHeaderDirections.font = countryPickerConfiguration.theme.font
            pinnedFooterDirections.font = countryPickerConfiguration.theme.font
        }
        
        if let validNavBarTitleView = countryPickerConfiguration.theme.navigationBarTitleView {
            navigationItem.titleView = validNavBarTitleView
        }
        
        if let validHeaderBackgroundColor = countryPickerConfiguration.theme.headerBackgroundColor {
            self.headerDirectionsContainer.backgroundColor = validHeaderBackgroundColor
        }
        
        if let validFooterBackgroundColor = countryPickerConfiguration.theme.footerBackgroundColor {
            self.footerDirectionsContainer.backgroundColor = validFooterBackgroundColor
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
                
                if cellSelectionMeta.isInitiatedByUser {
                    if cellSelectionMeta.isSelected {
                        strongSelf.delegate?.didSelect(country: cellSelectionMeta.country)
                        strongSelf.countrySelectionRelay.send((cellSelectionMeta.country, true))
                    } else {
                        strongSelf.delegate?.didDeselect(country: cellSelectionMeta.country)
                        strongSelf.countrySelectionRelay.send((cellSelectionMeta.country, false))
                    }
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
        pickerView.contentInset = UIEdgeInsets.init(top: 0, left: 0, bottom: UIFloat(150), right: 0)
        pickerView.tableFooterView = UIView()
        #if targetEnvironment(macCatalyst)
        pickerView.separatorStyle = .none //make it more mac-like
        #else
        pickerView.separatorStyle = .singleLine
        #endif
        pickerView.estimatedRowHeight = UIFloat(44)
        pickerView.rowHeight = UITableView.automaticDimension
        
    }
    
    open func configureSearchBar() {
        #if targetEnvironment(macCatalyst)
        searchBarMacStyle?.returnKeyType = .done
        searchBarMacStyle?.delegate = self
        searchBar.backgroundImage = UIImage()
        #else
        //search bar is hidden
        searchBar.returnKeyType = .done
        searchBar.delegate = self
        #endif
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
    
    open func configureNotificationListening() {
        // do not forget to remove self from observing notifications in order to prevent memory leaks
        NotificationCenter.default.addObserver(self, selector: #selector(userPerformedSearch(_:)), name: SearchBarEvent.toolbarSearchBarTextChanged.name, object: nil)
    }
    
    @objc
    open func userPerformedSearch(_ notification: Notification) {
        if let searchText = notification.object as? String {
            presenter.searchBarRelay.send(searchText)
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

extension UICountryPickerViewController: ToolbarActionsResponder {
    public func clearSelections(_ sender: Any?) {
        presenter.clearAll()
    }
}
