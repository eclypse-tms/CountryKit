//
//  SelectionsViewController.swift
//  countrykit_example
//
//  Created by eclypse on 12/9/23.
//

import UIKit
import Composure
import CountryKit

class SelectionsViewController: UIViewController {
    
    @IBOutlet private weak var mainView: UICollectionView!
    @IBOutlet private weak var selectCountryButton: UIButton!
    @IBOutlet private weak var configStack: UIStackView!
    @IBOutlet private weak var configScroll: UIScrollView!
    @IBOutlet private weak var worldWideStack: UIStackView!
    @IBOutlet private weak var limitedCountryStack: UIStackView!
    @IBOutlet private weak var excludedCountryStack: UIStackView!
    
    
    @IBOutlet private weak var allowSelectionSwitch: UISwitch!
    @IBOutlet private weak var canMultiSelectSwitch: UISwitch!
    @IBOutlet private weak var cellSelectionStyleSegment: UISegmentedControl!
    @IBOutlet private weak var searchCriteriaSegment: UISegmentedControl!
    @IBOutlet private weak var navBarButtonsSegment: UISegmentedControl!
    @IBOutlet private weak var pickerViewPresentationSegment: UISegmentedControl!
    
    @IBOutlet private weak var allowWorldwideSwitch: UISwitch!
    @IBOutlet private weak var autoDismissSwitch: UISwitch!
    @IBOutlet private weak var preselectCountriesSwitch: UISwitch!
    @IBOutlet private weak var limitedCountrySwitch: UISwitch!
    @IBOutlet private weak var excludeCountrySwitch: UISwitch!
    
    @IBOutlet private weak var worldwideTranslation: UITextField!
    @IBOutlet private weak var worldwideDescriptionTranslation: UITextView!
    @IBOutlet private weak var limitedCountryDescriptionTranslation: UITextView!
    @IBOutlet private weak var excludedCountryDescriptionTranslation: UITextView!
    @IBOutlet private weak var pinnedHeaderTooltip: UITextView!
    @IBOutlet private weak var pinnedFooterTooltip: UITextView!
    
    @IBOutlet private weak var inclusionButton: UIButton!
    @IBOutlet private weak var sortButton: UIButton!
    
    private var selectedCountryListOption: CountryListOption = []
    private var selectedSortOption: CountrySorter?
    
    private var dataSource: UICollectionViewDiffableDataSource<SelectedCountriesSection, Country>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureMainView()
        configureInitialState()
        configureInclusionOptions()
        configureSortOptions()
    }
    
    private func configureMainView() {
        configureDataSource(with: mainView)
        mainView.register(SelectedCountryCell.nib, forCellWithReuseIdentifier: SelectedCountryCell.nibName)
        
        mainView.collectionViewLayout = generateCompositionalLayout(with: SelectedCountriesSection.allCases)
        mainView.allowsSelection = false
        
        mainView.isHidden = true //upon initial launch we are showing the configuration elements
    }
    
    private func configureInclusionOptions() {
        
        let inclusionMenu = UIMenu(children: [
            UIAction(title: "Sovereign State", handler: { _ in self.add(countryListOption: .sovereignStates) }),
            UIAction(title: "Commonwealth Member", handler: { _ in self.add(countryListOption: .commonwealthMembers) }),
            UIAction(title: "Dependent Territory", handler: { _ in self.add(countryListOption: .dependentTerritories) }),
            UIAction(title: "No Population", handler: { _ in self.add(countryListOption: .noPermanentPopulation) }),
            UIAction(title: "Disputed Territories", handler: { _ in self.add(countryListOption: .disputedTerritories) }),
            UIAction(title: "All Countries/Territories", handler: { _ in self.add(countryListOption: .all) })
        ])
        
        inclusionButton.menu = inclusionMenu
        inclusionButton.showsMenuAsPrimaryAction = true
        selectedCountryListOption = [.sovereignStates] //default option
    }
    
    private func add(countryListOption: CountryListOption) {
        selectedCountryListOption = [countryListOption]
    }
    
    private func configureSortOptions() {
        
        let sortMenu = UIMenu(children: [
            UIAction(title: "Default", handler: { _ in self.mark(selectedSort: 0) }),
            UIAction(title: "Alpha 2 Code", handler: { _ in self.mark(selectedSort: 1) }),
            UIAction(title: "Area", handler: { _ in self.mark(selectedSort: 2) }),
            UIAction(title: "North American Countries", handler: { _ in self.mark(selectedSort: 3) }),
            UIAction(title: "Timezone", handler: { _ in self.mark(selectedSort: 4) })
        ])
        
        sortButton.menu = sortMenu
        sortButton.showsMenuAsPrimaryAction = true
    }
    
    private func mark(selectedSort: Int) {
        switch selectedSort {
        case 1:
            //sort countries by their alpha2 code
            selectedSortOption = Alpha2Sorter()
        case 2:
            //sort countries by their area
            selectedSortOption = AreaSorter()
        case 3:
            //place Canada, United States and Mexico on top and then sort by name
            selectedSortOption = NorthAmericanCountriesSorter()
        case 4:
            //sorty by each countries easternward timezone 
            selectedSortOption = TimeZoneSorter()
        default:
            selectedSortOption = nil
        }
    }
    
    private func configureInitialState() {
        limitedCountryStack.isHidden = true
        excludedCountryStack.isHidden = true
        worldWideStack.isHidden = true
        
        addBorder(to: worldwideDescriptionTranslation)
        addBorder(to: limitedCountryDescriptionTranslation)
        addBorder(to: excludedCountryDescriptionTranslation)
        addBorder(to: pinnedHeaderTooltip)
        addBorder(to: pinnedFooterTooltip)
    }
    
    private func configureDataSource(with collectionView: UICollectionView) {
        dataSource = UICollectionViewDiffableDataSource<SelectedCountriesSection, Country>(collectionView: collectionView) { [weak self] (collectionView, indexPath, itemIdentifier: AnyHashable) -> UICollectionViewCell? in
            guard let strongSelf = self,
                  let cell = collectionView.dequeueReusableCell(withReuseIdentifier: SelectedCountryCell.nibName, for: indexPath) as? SelectedCountryCell,
                  let viewModel = strongSelf.dataSource?.itemIdentifier(for: indexPath) else { return nil }
            cell.configure(with: viewModel)
            return cell
        }
    }
    
    @IBAction func didChangeSwitchValue(_ sender: UISwitch) {
        switch sender {
        case allowWorldwideSwitch:
            worldWideStack.isHidden = !sender.isOn
        case limitedCountrySwitch:
            limitedCountryStack.isHidden = !sender.isOn
        case excludeCountrySwitch:
            excludedCountryStack.isHidden = !sender.isOn
        default:
            break
        }
    }

    @IBAction func didClickOnSelectCountry(_ sender: UIButton) {
        configScroll.isHidden = true
        mainView.isHidden = false
            
        var config = CountryPickerConfiguration.default()
        config.allowsSelection = allowSelectionSwitch.isOn
        config.canMultiSelect = canMultiSelectSwitch.isOn
        
        config.theme.cellSelectionStyle = CountryCellSelectionStyle(rawValue: cellSelectionStyleSegment.selectedSegmentIndex)!
        config.searchMethodology = SearchMethodology(rawValue: searchCriteriaSegment.selectedSegmentIndex)!
        config.buttonDisplayOption = ToolbarButtonsDisplayOption(rawValue: navBarButtonsSegment.selectedSegmentIndex)!
        
        if allowWorldwideSwitch.isOn {
            config.shouldShowWorldWide = true
            config.localizedWorldWide = worldwideTranslation.text ?? ""
            config.localizedWorldWideDescription = worldwideDescriptionTranslation.text
        } else {
            config.shouldShowWorldWide = false
            config.localizedWorldWide = ""
            config.localizedWorldWideDescription = ""
        }
        
        //save the inclusions
        config.countryListOption = selectedCountryListOption
        
        if limitedCountrySwitch.isOn {
            limitedCountryStack.isHidden = false
            config.countryRoster = Set([Country.Aruba, Country.Finland, Country.Hungary, Country.Japan,  Country.Kuwait, Country.Mali, Country.New_Zealand, Country.Romania, Country.Saint_Kitts_and_Nevis, Country.Uzbekistan])
            config.rosterJustification = limitedCountryDescriptionTranslation.text
        } else {
            limitedCountryStack.isHidden = true
            config.countryRoster = Set()
            config.rosterJustification = ""
        }
        
        if excludeCountrySwitch.isOn {
            excludedCountryStack.isHidden = false
            config.excludedCountries = Set([.Afghanistan, .Aland_Islands, .Albania, .Algeria, .American_Samoa, .Andorra, .Angola, .Anguilla, .Antarctica, .Antigua_and_Barbuda, .Argentina, .Armenia, .Aruba, .Australia, .Austria, .Azerbaijan])
            config.excludedCountriesJustification = excludedCountryDescriptionTranslation.text
        } else {
            excludedCountryStack.isHidden = true
            config.excludedCountries = Set()
            config.excludedCountriesJustification = ""
        }
        
        if pinnedHeaderTooltip.text.isEmpty {
            config.pinnedHeaderText = nil
        } else {
            config.pinnedHeaderText = pinnedHeaderTooltip.text
        }
        
        if pinnedFooterTooltip.text.isEmpty {
            config.pinnedFooterText = nil
        } else {
            config.pinnedFooterText = pinnedFooterTooltip.text
        }
        
        config.dismissAfterFirstSelection = autoDismissSwitch.isOn
        
        if preselectCountriesSwitch.isOn {
            let currentSnapshot = dataSource.snapshot()
            config.preselectedCountries = Set(currentSnapshot.itemIdentifiers)
        } else {
            config.preselectedCountries.removeAll()
            resetCountrySelections()
        }
        
        config.countrySorter = self.selectedSortOption
        
        #if targetEnvironment(macCatalyst)
        config.macConfiguration.cellSelectionColor = UIColor(named: "AccentColor")
        config.macConfiguration.bottomToolbarSeparatorColor = .clear
        #endif
        
        //initialize country picker ui
        let countryPickerVC = UICountryPickerViewController()
        
        //get notified when user interacts with the country selection ui
        countryPickerVC.delegate = self
        
        let shouldDisplayPickerViewModally: Bool
        switch pickerViewPresentationSegment.selectedSegmentIndex {
        case 0:
            shouldDisplayPickerViewModally = false
        default:
            shouldDisplayPickerViewModally = true
        }
        
        if shouldDisplayPickerViewModally {
            //save the configuration on the view controller
            countryPickerVC.countryPickerConfiguration = config
            let navController = UINavigationController(rootViewController: countryPickerVC)
            navController.modalPresentationStyle = .formSheet
            present(navController, animated: true)
        } else {
            config.showSearchBar = false
            //save the configuration on the view controller
            countryPickerVC.countryPickerConfiguration = config
            splitViewController?.setViewController(countryPickerVC, for: .secondary)
            splitViewController?.show(.secondary)
        }
    }
    
    private func addBorder(to uiTextView: UITextView) {
        uiTextView.layer.cornerRadius = UIFloat(6)
        uiTextView.layer.borderColor = UIColor.gray.cgColor
        uiTextView.layer.borderWidth = 0.5
        uiTextView.layer.opacity = 0.5
        uiTextView.isOpaque = true
        uiTextView.backgroundColor = UIColor(named: "textview_background_color")
    }
}

extension SelectionsViewController: UICountryPickerDelegate {
    func didSelect(country: Country) {
        print("selected \(country.localizedName)")
        var currentSnapshot = dataSource.snapshot()
        if currentSnapshot.numberOfSections == 0 {
            currentSnapshot.appendSections([SelectedCountriesSection.primarySection])
        }
        
        if currentSnapshot.itemIdentifiers.contains(country) {
            //selected country is already included in the collection view's snapshot
            //nothing to do
        } else {
            currentSnapshot.appendItems([country], toSection: .primarySection)
            dataSource.apply(currentSnapshot, animatingDifferences: true)
        }
    }
    
    func didDeselect(country: Country) {
        print("deselected \(country.localizedName)")
        var currentSnapshot = dataSource.snapshot()
        if currentSnapshot.itemIdentifiers.contains(country) {
            currentSnapshot.deleteItems([country])
            dataSource.apply(currentSnapshot, animatingDifferences: true)
        } else {
            //selected country is not present in the collection view's snapshot
            //nothing to do
        }
    }
    
    func resetCountrySelections() {
        var currentSnapshot = dataSource.snapshot()
        currentSnapshot.deleteSections([.primarySection])
        dataSource.apply(currentSnapshot, animatingDifferences: false)
    }
    
    func didFinishSelecting(countries: [Country]) {
        print("user selected the following countries: \(countries.map { $0.localizedName}.joined(separator: ",") )")
        configScroll.isHidden = false
        mainView.isHidden = true
    }
    
    func didCancel() {
        configScroll.isHidden = false
        mainView.isHidden = true
    }
}

enum SelectedCountriesSection: Int, DefinesCompositionalLayout, CaseIterable {
    case primarySection
    
    func layoutInfo(using layoutEnvironment: NSCollectionLayoutEnvironment) -> Composure.CompositionalLayoutOption {
        switch self {
        case .primarySection:
            return .dynamicWidthFixedHeight(estimatedWidth: UIFloat(150), fixedHeight: UIFloat(36))
        }
    }
    
    var interItemSpacing: CGFloat {
        return UIFloat(8)
    }
    
    var interGroupSpacing: CGFloat {
        return UIFloat(8)
    }
    
    func sectionInsets(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSDirectionalEdgeInsets {
        return .init(top: 0, leading: UIFloat(8), bottom: 0, trailing: UIFloat(8))
    }
}

extension SelectionsViewController: UISplitViewControllerDelegate {
    func splitViewController(_ svc: UISplitViewController, topColumnForCollapsingToProposedTopColumn proposedTopColumn: UISplitViewController.Column) -> UISplitViewController.Column {
        return .primary
    }
}
