//
//  CountrySelectionPresenter.swift
//  CountryKit
//
//  Created by eclypse on 12/8/23.
//

import UIKit
import Combine

/// assists the UICountryPickerViewController in performing various view related tasks
/// such as reacting to UI events, performing search and configuring the underlying table view
open class CountryPickerPresenter: NSObject {
    //MARK: Injected properties
    
    /// a dedicated class that is used to apply filtering logic on the full country list
    open var countryFilteringMethod: CountryFilteringMethod
    
    /// many of the actions are processed in this dedicated queue
    open var presenterQueue: DispatchQueue
    
    /// provides the list of countries that this presenter further refines
    open var countryProvider: CountryProvider
    
    //MARK: semi-private properties
    /// keeps track of the selected countries
    private (set) var formSelectedCountries = Set<Country>()
    
    /// main configuration object that determines how the picker should work
    private (set) var countryPickerConfig: CountryPickerConfiguration = .default()
    
    /// static configuration file to be accessed from anywhere
    private (set) static var universalConfig: CountryPickerConfiguration = .default()
    //MARK: private properties
    private var fullCountryList = [Country]()
    private var filteredCountryList = [CountryViewModel]()
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: UITableViewDiffableDataSource<CountryPickerViewSection, AnyHashable>?
    private let reloadDataRelay = PassthroughSubject<Bool, Never>()
    private let viewRestorationRelay = PassthroughSubject<Void, Never>()
    private let tableSelectionRelay = PassthroughSubject<IndexPath, Never>()
    private let tableDeselectionRelay = PassthroughSubject<IndexPath, Never>()

    //MARK: public properties
    let searchBarRelay = PassthroughSubject<String, Never>()
    let countrySelectionRelay = PassthroughSubject<CellSelectionMeta, Never>()
    let dismissView = PassthroughSubject<Bool, Never>()
    
    public init(countryProvider: CountryProvider, countryFilteringMethod: CountryFilteringMethod, presenterQueue: DispatchQueue) {
        self.countryProvider = countryProvider
        self.countryFilteringMethod = countryFilteringMethod
        self.presenterQueue = presenterQueue
    }
    
    open func register(config: CountryPickerConfiguration) {
        formSelectedCountries = config.preselectedCountries
        countryPickerConfig = config
        CountryPickerPresenter.universalConfig = config
        
        /// initializes Worldwide
        let worldWideCountry = Country.Worldwide
        if !config.localizedWorldWide.isEmpty {
            /// since the config file indicates that there is a localized worldwide option,
            /// we re-init this with the provided localization override
            Country.Worldwide = Country(alpha3Code: worldWideCountry.alpha3Code,
                                       englishName: worldWideCountry.englishName,
                                       alpha2Code: worldWideCountry.alpha2Code,
                                       localizedNameOverride: countryPickerConfig.localizedWorldWide)
        }
    }
    
    /// if you override it, make sure to call super at some point
    open func tearDown() {
        cancellables.forEach { $0.cancel() }
        dataSource = nil //making it nil breaks the memory reference cycle
    }
    
    /// configures the country list and loads the table
    func configureBindings() {
        Just(true)
        .receive(on: presenterQueue)
        .sink(receiveValue: {  [weak self] _ in
            guard let strongSelf = self else { return }
            
            strongSelf.countryProvider.loadAdditionalMetaData()
                
            let unsortedCountryList: [Country]
            
            if !strongSelf.countryPickerConfig.countryRoster.isEmpty {
                unsortedCountryList = Array(strongSelf.countryPickerConfig.countryRoster)
            } else if !strongSelf.countryPickerConfig.excludedCountries.isEmpty {
                unsortedCountryList = strongSelf.countryProvider
                    .allKnownCountries
                    .compactMap(strongSelf.applyInclusionCriteria(alpha2Code:country:))
                    .compactMap(strongSelf.applyExclusionCriteria(country:))
            } else {
                unsortedCountryList = strongSelf.countryProvider.allKnownCountries
                    .compactMap(strongSelf.applyInclusionCriteria(alpha2Code:country:))
            }
              
            if let providedSorter = strongSelf.countryPickerConfig.countrySorter {
                strongSelf.fullCountryList = unsortedCountryList.sorted(by: providedSorter.sort(lhs:rhs:))
            } else {
                strongSelf.fullCountryList = unsortedCountryList.sorted()
            }

            strongSelf.filteredCountryList = strongSelf.fullCountryList.map({
                CountryViewModel(country: $0)
            })
            strongSelf.reloadDataRelay.send(false)
        }).store(in: &cancellables)
        
        
        reloadDataRelay.receive(on: presenterQueue)
            .sink(receiveValue: { [weak self] shouldAnimate in
                guard let strongSelf = self else { return }
                strongSelf.reloadData(shouldAnimate: shouldAnimate)
            }).store(in: &cancellables)
        
        searchBarRelay.receive(on: presenterQueue)
            .debounce(for: .milliseconds(300), scheduler: presenterQueue)
            .sink { [weak self] searchText in
                guard let strongSelf = self else { return }
                strongSelf.filteredCountryList = strongSelf.countryFilteringMethod
                    .apply(searchQuery: searchText,
                           fullCountryList: strongSelf.fullCountryList,
                           searchMethodology: strongSelf.countryPickerConfig.searchMethodology)
                strongSelf.reloadDataRelay.send(true)
            }.store(in: &cancellables)
        
        tableSelectionRelay.receive(on: presenterQueue)
            .sink { [weak self] selectedIndexPath in
                guard let strongSelf = self else { return }
                let countrySection = CountryPickerViewSection(rawValue: selectedIndexPath.section)!
                switch countrySection {
                case .worldwide:
                    strongSelf.didSelect(country: Country.Worldwide, at: selectedIndexPath)
                case .allCountries:
                    let selectedCountry = strongSelf.filteredCountryList[selectedIndexPath.row]
                    strongSelf.didSelect(country: selectedCountry.country, at: selectedIndexPath)
                default:
                    break
                }
            }.store(in: &cancellables)
        
        tableDeselectionRelay.receive(on: presenterQueue)
            .sink { [weak self] deselectedIndexPath in
                guard let strongSelf = self else { return }
                let countrySection = CountryPickerViewSection(rawValue: deselectedIndexPath.section)!
                switch countrySection {
                case .worldwide:
                    strongSelf.didDeselect(country: Country.Worldwide, at: deselectedIndexPath)
                case .allCountries:
                    let deselectedCountry = strongSelf.filteredCountryList[deselectedIndexPath.row]
                    strongSelf.didDeselect(country: deselectedCountry.country, at: deselectedIndexPath)
                default:
                    break
                }
            }.store(in: &cancellables)
        
        viewRestorationRelay.receive(on: presenterQueue)
            .sink { [weak self] _ in
                guard let strongSelf = self else { return }
                strongSelf.restoreCellSelectionsAfterReload()
            }.store(in: &cancellables)
    }
    
    private func applyExclusionCriteria(country: Country) -> Country? {
        if countryPickerConfig.excludedCountries.contains(country) {
            return nil
        } else {
            return country
        }
    }
    
    open func applyInclusionCriteria(alpha2Code: String, country: Country) -> Country? {
        if !countryPickerConfig.countryRoster.isEmpty {
            //there is a specific list of countries that user wants to present.
            //we cannot apply the inclusion criteria on this
            return country
        }
        
        if countryPickerConfig.countryListOption.contains(.all) {
            return country
        }
        
        if countryPickerConfig.countryListOption.contains(.sovereignStates), 
            country.wiki.alpha2CodeOfItsSovereignState == nil, //cannot have another country as its sovereign
            !country.wiki.isDisputedTerritory, //cannot be a disputed territory
            !country.wiki.noPermanentPopulation //must have a permanent population
        {
            //user wanted to include the sovereign states and this country does not have another sovereign state
            return country
        }
        
        if countryPickerConfig.countryListOption.contains(.commonwealthMembers), country.wiki.isMemberOfCommonwealth {
            //user wanted to include the commonwealth states and this country is a member of commonwealth
            return country
        }
        
        if countryPickerConfig.countryListOption.contains(.dependentTerritories), country.wiki.alpha2CodeOfItsSovereignState != nil {
            //user wanted to include the commonwealth states and this country HAS another sovereign state
            return country
        }
        
        if countryPickerConfig.countryListOption.contains(.noPermanentPopulation), country.wiki.noPermanentPopulation {
            //user wanted to include those regions and territories without any permanent population
            return country
        }
        
        if countryPickerConfig.countryListOption.contains(.disputedTerritories), country.wiki.isDisputedTerritory {
            //user wanted to include those regions and territories that are internationally disputed
            return country
        }
        
        
        return nil
    }
    
    /// configures the data source
    func configureDataSource(with tableView: UITableView) {
        if dataSource == nil {
            dataSource = UITableViewDiffableDataSource<CountryPickerViewSection, AnyHashable>(tableView: tableView) { [weak self] (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
                guard let strongSelf = self else { return nil }
                let cellIdentifier = strongSelf.reuseIdentifier(for: indexPath)
                let cell = tableView.dequeueReusableCell(withIdentifier: cellIdentifier, for: indexPath)
                guard let viewModel = strongSelf.dataSource?.itemIdentifier(for: indexPath) else { return nil }
                strongSelf.configure(cell: cell, with: viewModel)
                return cell
            }
            dataSource?.defaultRowAnimation = .fade
        }
    }
    
    private func reloadData(shouldAnimate: Bool) {
        var snapshot = NSDiffableDataSourceSnapshot<CountryPickerViewSection, AnyHashable>()
        snapshot.appendSections(CountryPickerViewSection.allCases)
        
        CountryPickerViewSection.allCases.forEach { eachSection in
            let vms = data(for: eachSection)
            snapshot.appendItems(vms, toSection: eachSection)
        }
        
        guard let configuredDataSource = dataSource else { return }
        configuredDataSource.apply(snapshot, animatingDifferences: shouldAnimate, completion: { [weak self] in
            self?.viewRestorationRelay.send(())
        })
    }
    
    private func data(for section: CountryPickerViewSection) -> [AnyHashable] {
        var vms = [AnyHashable]()
        switch section {
        case .worldwide:
            if !countryFilteringMethod.isInSearchMode {
                if countryPickerConfig.shouldShowWorldWide {
                    let vm = CountryViewModel(country: Country.Worldwide)
                    vms.append(vm)
                }
            }
        case .worldwideExplanation:
            if !countryFilteringMethod.isInSearchMode {
                if countryPickerConfig.shouldShowWorldWide {
                    let vm = FooterViewModel(footerText: countryPickerConfig.localizedWorldWideDescription)
                    vms.append(vm)
                }
            }
        case .allCountries:
            vms.append(contentsOf: filteredCountryList)
        case .rosterExplanation:
            if !countryFilteringMethod.isInSearchMode {
                if !countryPickerConfig.rosterJustification.isEmpty && !countryPickerConfig.rosterJustification.isEmpty {
                    let vm = FooterViewModel(footerText: countryPickerConfig.rosterJustification)
                    vms.append(vm)
                } else if !countryPickerConfig.excludedCountries.isEmpty && !countryPickerConfig.excludedCountriesJustification.isEmpty {
                    let vm = FooterViewModel(footerText: countryPickerConfig.excludedCountriesJustification)
                    vms.append(vm)
                }
            }
        }
        return vms
    }
    
    private func reuseIdentifier(for indexPath: IndexPath) -> String {
        let countrySection = CountryPickerViewSection(rawValue: indexPath.section)!
        switch countrySection {
        case .worldwide, .allCountries:
            return CountryCell.nibName
        case .worldwideExplanation, .rosterExplanation:
            return FooterCell.nibName
        }
    }
    
    private func configure(cell: UITableViewCell, with viewModel: AnyHashable) {
        switch cell {
        case let countryCell as CountryCell:
            if let vm = viewModel as? CountryViewModel {
                countryCell.configure(with: vm)
            }
        case let footerCell as FooterCell:
            if let vm = viewModel as? FooterViewModel {
                footerCell.configure(with: vm)
            }
        default:
            break
        }
    }
    
    private func restoreCellSelectionsAfterReload() {
        if formSelectedCountries.count > 0 {
            var numberOfRestoredSelections = 0
            //only compare the alpha2 codes to determine whether set contains a selected country
            let setOfSelectedAlpha2Codes = Set<String>(formSelectedCountries.map { $0.alpha2Code })
            
            //we need to treat worldwide differently as its data source is not contained in filteredCountryList
            if setOfSelectedAlpha2Codes.contains(Country.Worldwide.alpha2Code) {
                let indexPathToRestore = IndexPath(row: 0, section: CountryPickerViewSection.worldwide.rawValue)
                countrySelectionRelay.send(CellSelectionMeta(country: Country.Worldwide, isSelected: true, indexPath: indexPathToRestore, performCellSelection: true, isInitiatedByUser: false))
                numberOfRestoredSelections += 1
            }
            
            for (index, eachCounty) in filteredCountryList.enumerated() {
                if setOfSelectedAlpha2Codes.contains(eachCounty.country.alpha2Code) {
                    let indexPathToRestore = IndexPath(row: index, section: CountryPickerViewSection.allCountries.rawValue)
                    countrySelectionRelay.send(CellSelectionMeta(country: eachCounty.country, isSelected: true, indexPath: indexPathToRestore, performCellSelection: true, isInitiatedByUser: false))
                    numberOfRestoredSelections += 1
                }
                
                if formSelectedCountries.count == numberOfRestoredSelections {
                    //no need to keep enumerating if we already restored all selections
                    break
                }
            }
        }
    }
    
    // MARK: Country Selection Logic
    /// this function gets invoked after the user taps on a row to select that row.
    open func didSelect(country: Country, at indexPath: IndexPath) {
        if countryPickerConfig.canMultiSelect {
            //multi selection is allowed
            if country == Country.Worldwide {
                if formSelectedCountries.count == 0 {
                    //there is no previous selection and user clicked on Worldwide
                    //UI should already reflect this selection, however, we need to generate a selection event for
                    //the delegate
                    formSelectedCountries.insert(country)
                    countrySelectionRelay.send(CellSelectionMeta(country: country, isSelected: true, indexPath: indexPath, performCellSelection: false, isInitiatedByUser: true))
                } else {
                    //user selected Worldwide - deselect everything else
                    clearPreviousAnd(selectThis: country, at: indexPath)
                }
            } else {
                //user selected another country
                if formSelectedCountries.contains(Country.Worldwide) {
                    //but previously worldwide was selected, so clear everything
                    //and select the new country
                    clearPreviousAnd(selectThis: country, at: indexPath)
                } else {
                    formSelectedCountries.insert(country)
                    countrySelectionRelay.send(CellSelectionMeta(country: country, isSelected: true, indexPath: indexPath, performCellSelection: false, isInitiatedByUser: true))
                }
            }
        } else {
            //only single selection is allowed
            clearPreviousAnd(selectThis: country, at: indexPath)
        }
        
        if countryPickerConfig.dismissAfterFirstSelection {
            dismissView.send(true)
        }
    }
    
    /// this function gets invoked after the user taps on a row to deselect it.
    open func didDeselect(country: Country, at indexPath: IndexPath) {
        formSelectedCountries.remove(country)
        countrySelectionRelay.send(CellSelectionMeta(country: country, isSelected: false, indexPath: indexPath, performCellSelection: false, isInitiatedByUser: true))
        if countryPickerConfig.dismissAfterFirstSelection {
            dismissView.send(true)
        }
    }
    
    private func clearPreviousAnd(selectThis: Country, at indexPath: IndexPath) {
        clearAll()
        formSelectedCountries.insert(selectThis)
        countrySelectionRelay.send(CellSelectionMeta(country: selectThis, isSelected: true, indexPath: indexPath, performCellSelection: false, isInitiatedByUser: true))
    }
    
    /// removes all selections from the country picker view
    open func clearAll() {
        formSelectedCountries.forEach { eachSelectedCountry in
            var section: Int = 0
            var row: Int = 0
            
            if eachSelectedCountry == .Worldwide {
                if countryFilteringMethod.isInSearchMode || !countryPickerConfig.shouldShowWorldWide {
                    //if the user is in search mode or worldwide selection is not allowed
                    //there is only one section
                    //worldwide selection cannot be visually cleared because it is already
                    //hidden
                } else {
                    section = CountryPickerViewSection.worldwide.rawValue
                    row = 0
                    let indexPathToDeselect = IndexPath(row: row, section: section)
                    countrySelectionRelay.send(CellSelectionMeta(country: eachSelectedCountry, isSelected: false, indexPath: indexPathToDeselect, performCellSelection: true, isInitiatedByUser: true))
                }
            } else {
                if let indexOfPreviouslySelectedCountry = filteredCountryList.firstIndex (where: { $0.country == eachSelectedCountry }) {
                    if countryFilteringMethod.isInSearchMode || !countryPickerConfig.shouldShowWorldWide {
                        //if the user is in search mode or worldwide selection is not allowed
                        //there is only one section
                        section = CountryPickerViewSection.allCountries.rawValue
                        row = indexOfPreviouslySelectedCountry
                    } else {
                        //other countries reside in section 1
                        section = CountryPickerViewSection.allCountries.rawValue
                        row = indexOfPreviouslySelectedCountry
                    }
                    let indexPathToDeselect = IndexPath(row: row, section: section)
                    countrySelectionRelay.send(CellSelectionMeta(country: eachSelectedCountry, isSelected: false, indexPath: indexPathToDeselect, performCellSelection: true, isInitiatedByUser: true))
                }
            }
        }
        formSelectedCountries.removeAll()
    }
}

// MARK: UITableViewDelegate
extension CountryPickerPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let countrySection = CountryPickerViewSection(rawValue: indexPath.section)!
        switch countrySection {
        case .worldwide:
            #if targetEnvironment(macCatalyst)
            return countryPickerConfig.macConfiguration.rowHeight
            #else
            return UIFloat(44)
            #endif
        case .worldwideExplanation:
            return UITableView.automaticDimension
        case .allCountries:
            #if targetEnvironment(macCatalyst)
            return countryPickerConfig.macConfiguration.rowHeight
            #else
            return UIFloat(44)
            #endif
        case .rosterExplanation:
            return UITableView.automaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let countrySection = CountryPickerViewSection(rawValue: indexPath.section)!
        switch countrySection {
        case .worldwideExplanation, .rosterExplanation:
            //explanation cells are not selectable
            return nil
        default:
            return indexPath
        }
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let currentSection = CountryPickerViewSection(rawValue: indexPath.section)!
        switch currentSection {
        case .worldwideExplanation, .rosterExplanation:
            //explanation cells are not selectable
            return false
        default:
            return true
        }
    }
    
    public func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableSelectionRelay.send(indexPath)
    }
    
    public func tableView(_ tableView: UITableView, didDeselectRowAt indexPath: IndexPath) {
        tableDeselectionRelay.send(indexPath)
    }
}
