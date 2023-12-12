//
//  CountrySelectionPresenter.swift
//  CountryKit
//
//  Created by eclypse on 12/8/23.
//

import UIKit
import Combine

enum CountrySelection: Int, CaseIterable {
    case worldwide
    case worldwideExplanation
    case allCountries
    case rosterExplanation
}

open class CountrySelectionPresenter: NSObject {
    //MARK: Injected properties
    open var textHighlighter: TextHighlighter
    open var presenterQueue: DispatchQueue
    open var countryProvider: CountryProvider
    
    //MARK: semi-private properties
    private (set) var formSelectedCountries = Set<Country>()
    private (set) var countrySelectionConfig: CountrySelectionConfiguration = .default()
    
    //MARK: private properties
    private var fullCountryList = [Country]()
    private var filteredCountryList = [CountryViewModel]()
    private var cancellables: Set<AnyCancellable> = []
    private var dataSource: UITableViewDiffableDataSource<CountrySelection, AnyHashable>?
    private let reloadDataRelay = PassthroughSubject<Bool, Never>()
    private let viewRestorationRelay = PassthroughSubject<Void, Never>()
    private let tableSelectionRelay = PassthroughSubject<IndexPath, Never>()
    private let tableDeselectionRelay = PassthroughSubject<IndexPath, Never>()
    private var isInSearchMode = false

    //MARK: public properties
    let searchBarRelay = PassthroughSubject<String, Never>()
    let countrySelectionRelay = PassthroughSubject<CellSelectionMeta, Never>()
    let dismissView = PassthroughSubject<Bool, Never>()
    
    public init(countryProvider: CountryProvider, textHighlighter: TextHighlighter, presenterQueue: DispatchQueue) {
        self.countryProvider = countryProvider
        self.textHighlighter = textHighlighter
        self.presenterQueue = presenterQueue
    }
    
    open func register(config: CountrySelectionConfiguration) {
        formSelectedCountries = config.previouslySelectedCountries
        countrySelectionConfig = config
        
        let worldWideCountry = Country.Worldwide
        if !config.localizedWorldWide.isEmpty {
            Country.Worldwide = Country(alpha3Code: worldWideCountry.alpha3Code,
                                       englishName: worldWideCountry.englishName,
                                       alpha2Code: worldWideCountry.alpha2Code,
                                       localizedNameOverride: countrySelectionConfig.localizedWorldWide)
        }
    }
    
    open func tearDown() {
        cancellables.forEach { $0.cancel() }
        dataSource = nil
    }
    
    func configureBindings() {
        Just(true)
        .receive(on: presenterQueue)
        .sink(receiveValue: {  [weak self] _ in
            guard let strongSelf = self else { return }
                
            let initialCountryList: [Country]
            if !strongSelf.countrySelectionConfig.countryRoster.isEmpty {
                initialCountryList = strongSelf.countryProvider.allKnownCountries.compactMap { (alpha2Code, eachCountry) -> Country? in
                    if strongSelf.countrySelectionConfig.countryRoster.contains(eachCountry) {
                        return eachCountry
                    } else {
                        return nil
                    }
                }
            } else if !strongSelf.countrySelectionConfig.excludedCountries.isEmpty {
                initialCountryList = strongSelf.countryProvider.allKnownCountries.compactMap { (alpha2Code, eachCountry) -> Country? in
                    if strongSelf.countrySelectionConfig.excludedCountries.contains(eachCountry) {
                        return nil
                    } else {
                        return eachCountry
                    }
                }
            } else {
                initialCountryList = strongSelf.countryProvider.allKnownCountries.map { $1 }
            }
              
            strongSelf.fullCountryList = initialCountryList
                .sorted(by: { (lhs, rhs) -> Bool in
                    let result = lhs.localizedName.compare(rhs.localizedName, options: [.caseInsensitive, .diacriticInsensitive])
                    switch result {
                    case .orderedAscending:
                        return true
                    default:
                        return false
                    }
                })

            strongSelf.filteredCountryList = strongSelf.fullCountryList.map({
                CountryViewModel(country: $0)
            })
            strongSelf.reloadDataRelay.send(false)
        }).store(in: &cancellables)
        
        
        reloadDataRelay.receive(on: presenterQueue)
            .sink { completed in
                
            } receiveValue: { [weak self] shouldAnimate in
                guard let strongSelf = self else { return }
                strongSelf.reloadData(shouldAnimate: shouldAnimate)
            }.store(in: &cancellables)
        
        searchBarRelay.receive(on: presenterQueue)
            .debounce(for: .milliseconds(300), scheduler: presenterQueue)
            .sink { [weak self] searchText in
                self?.apply(searchQuery: searchText)
            }.store(in: &cancellables)
        
        tableSelectionRelay.receive(on: presenterQueue)
            .sink { [weak self] selectedIndexPath in
                guard let strongSelf = self else { return }
                let countrySection = CountrySelection(rawValue: selectedIndexPath.section)!
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
                let countrySection = CountrySelection(rawValue: deselectedIndexPath.section)!
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
    
    func configureDataSource(with tableView: UITableView) {
        if dataSource == nil {
            dataSource = UITableViewDiffableDataSource<CountrySelection, AnyHashable>(tableView: tableView) { [weak self] (tableView, indexPath, itemIdentifier) -> UITableViewCell? in
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
        var snapshot = NSDiffableDataSourceSnapshot<CountrySelection, AnyHashable>()
        snapshot.appendSections(CountrySelection.allCases)
        
        
        CountrySelection.allCases.forEach { eachSection in
            let vms = data(for: eachSection)
            snapshot.appendItems(vms, toSection: eachSection)
        }
        
        guard let configuredDataSource = dataSource else { return }
        configuredDataSource.apply(snapshot, animatingDifferences: shouldAnimate, completion: { [weak self] in
            self?.viewRestorationRelay.send(())
        })
    }
    
    private func data(for section: CountrySelection) -> [AnyHashable] {
        var vms = [AnyHashable]()
        switch section {
        case .worldwide:
            if !isInSearchMode {
                if countrySelectionConfig.shouldShowWorldWide {
                    let vm = CountryViewModel(country: Country.Worldwide)
                    vms.append(vm)
                }
            }
        case .worldwideExplanation:
            if !isInSearchMode {
                if countrySelectionConfig.shouldShowWorldWide {
                    let vm = FooterViewModel(footerText: countrySelectionConfig.localizedWorldWideDescription)
                    vms.append(vm)
                }
            }
        case .allCountries:
            vms.append(contentsOf: filteredCountryList)
        case .rosterExplanation:
            if !isInSearchMode {
                if !countrySelectionConfig.rosterJustification.isEmpty && !countrySelectionConfig.rosterJustification.isEmpty {
                    let vm = FooterViewModel(footerText: countrySelectionConfig.rosterJustification)
                    vms.append(vm)
                } else if !countrySelectionConfig.excludedCountries.isEmpty && !countrySelectionConfig.excludedCountriesJustification.isEmpty {
                    let vm = FooterViewModel(footerText: countrySelectionConfig.excludedCountriesJustification)
                    vms.append(vm)
                }
            }
        }
        return vms
    }
    
    private func reuseIdentifier(for indexPath: IndexPath) -> String {
        let countrySection = CountrySelection(rawValue: indexPath.section)!
        switch countrySection {
        case .worldwide, .allCountries:
            return CountryCell.nibName
        case .worldwideExplanation, .rosterExplanation:
            return FooterCell.nibName
        }
    }
    
    open func apply(searchQuery: String) {
        // Strip out all the leading and trailing spaces.
        let strippedString = searchQuery.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if strippedString.count == 0 {
            isInSearchMode = false
            filteredCountryList = fullCountryList.map { CountryViewModel(country: $0) }
        } else {
            isInSearchMode = true
            let searchComponents = strippedString.components(separatedBy: " ") as [String]
            
            // Build all the "OR" expressions for each value in searchString.
            filteredCountryList = fullCountryList.filter { eachCountry -> Bool in
                
                var shouldIncludeThisCountry = false
                for eachSearchComponent in searchComponents {
                    shouldIncludeThisCountry = eachCountry.localizedName.localizedCaseInsensitiveContains(eachSearchComponent)
                    if shouldIncludeThisCountry {
                        break
                    }
                }
                
                return shouldIncludeThisCountry
            }.map({ eachCountry in
                let textToHighlight = textHighlighter.highlightedText(sourceText: eachCountry.localizedName, searchComponents: searchComponents)
                return CountryViewModel(country: eachCountry, highlightedText: textToHighlight)
            })
        }
        reloadDataRelay.send(true)
    }
    
    private func configure(cell: UITableViewCell, with viewModel: AnyHashable) {
        switch cell {
        case let countryCell as CountryCell:
            if let vm = viewModel as? CountryViewModel {
                countryCell.configure(with: vm, cellSelectionStyle: countrySelectionConfig.cellSelectionStyle)
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
            for (index, eachCounty) in filteredCountryList.enumerated() {
                if formSelectedCountries.contains(eachCounty.country) {
                    let indexPathToRestore = IndexPath(row: index, section: CountrySelection.allCountries.rawValue)
                    countrySelectionRelay.send(CellSelectionMeta(country: eachCounty.country, isSelected: true, indexPath: indexPathToRestore, performCellSelection: true))
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
    func didSelect(country: Country, at indexPath: IndexPath) {
        if countrySelectionConfig.canMultiSelect {
            //multi selection is allowed
            if country == Country.Worldwide {
                if formSelectedCountries.count == 0 {
                    //there is no previous selection and user clicked on Worldwide
                    //UI should already reflect this selection, however, we need to generate a selection event for
                    //the delegate
                    formSelectedCountries.insert(country)
                    countrySelectionRelay.send(CellSelectionMeta(country: country, isSelected: true, indexPath: indexPath, performCellSelection: false))
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
                    countrySelectionRelay.send(CellSelectionMeta(country: country, isSelected: true, indexPath: indexPath, performCellSelection: false))
                }
            }
        } else {
            //only single selection is allowed
            clearPreviousAnd(selectThis: country, at: indexPath)
        }
        
        if countrySelectionConfig.autoDismiss {
            dismissView.send(true)
        }
    }
    
    func didDeselect(country: Country, at indexPath: IndexPath) {
        formSelectedCountries.remove(country)
        countrySelectionRelay.send(CellSelectionMeta(country: country, isSelected: false, indexPath: indexPath, performCellSelection: false))
        if countrySelectionConfig.autoDismiss {
            dismissView.send(true)
        }
    }
    
    private func clearPreviousAnd(selectThis: Country, at indexPath: IndexPath) {
        formSelectedCountries.forEach { eachSelectedCountry in
            var section: Int = 0
            var row: Int = 0
            
            if eachSelectedCountry == .Worldwide {
                if isInSearchMode || !countrySelectionConfig.shouldShowWorldWide {
                    //if the user is in search mode or worldwide selection is not allowed
                    //there is only one section
                    //worldwide selection cannot be visually cleared because it is already
                    //hidden
                } else {
                    section = CountrySelection.worldwide.rawValue
                    row = 0
                    let indexPathToDeselect = IndexPath(row: row, section: section)
                    countrySelectionRelay.send(CellSelectionMeta(country: eachSelectedCountry, isSelected: false, indexPath: indexPathToDeselect, performCellSelection: true))
                }
            } else {
                if let indexOfPreviouslySelectedCountry = filteredCountryList.firstIndex (where: { $0.country == eachSelectedCountry }) {
                    if isInSearchMode || !countrySelectionConfig.shouldShowWorldWide {
                        //if the user is in search mode or worldwide selection is not allowed
                        //there is only one section
                        section = CountrySelection.allCountries.rawValue
                        row = indexOfPreviouslySelectedCountry
                    } else {
                        //other countries reside in section 1
                        section = CountrySelection.allCountries.rawValue
                        row = indexOfPreviouslySelectedCountry
                    }
                    let indexPathToDeselect = IndexPath(row: row, section: section)
                    countrySelectionRelay.send(CellSelectionMeta(country: eachSelectedCountry, isSelected: false, indexPath: indexPathToDeselect, performCellSelection: true))
                }
            }
        }
        formSelectedCountries.removeAll()
        formSelectedCountries.insert(selectThis)
        countrySelectionRelay.send(CellSelectionMeta(country: selectThis, isSelected: true, indexPath: indexPath, performCellSelection: false))
    }
}

// MARK: UITableViewDelegate
extension CountrySelectionPresenter: UITableViewDelegate {
    public func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        let countrySection = CountrySelection(rawValue: indexPath.section)!
        switch countrySection {
        case .worldwide:
            return 44
        case .worldwideExplanation:
            return UITableView.automaticDimension
        case .allCountries:
            return 44
        case .rosterExplanation:
            return UITableView.automaticDimension
        }
    }
    
    public func tableView(_ tableView: UITableView, willSelectRowAt indexPath: IndexPath) -> IndexPath? {
        let countrySection = CountrySelection(rawValue: indexPath.section)!
        switch countrySection {
        case .worldwideExplanation, .rosterExplanation:
            //explanation cells are not selectable
            return nil
        default:
            return indexPath
        }
    }
    
    public func tableView(_ tableView: UITableView, shouldHighlightRowAt indexPath: IndexPath) -> Bool {
        let currentSection = CountrySelection(rawValue: indexPath.section)!
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
