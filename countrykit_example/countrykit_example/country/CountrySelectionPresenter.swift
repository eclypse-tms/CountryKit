//
//  CountrySelectionPresenter.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/8/23.
//

import UIKit
import Combine

enum CountrySelection: Int, CaseIterable {
    case worldwide
    case worldwideExplanation
    case allCountries
    case rosterExplanation
}

class CountrySelectionPresenter: NSObject {
    
    private let countryProvider: CountryProvider
    private var fullCountryList = [Country]()
    private var filteredCountryList = [CountrySelectionViewModel]()
    
    let searchBarRelay = PassthroughSubject<String, Never>()
    private let textHighlighter: TextHighlighter
    private let presenterQueue: DispatchQueue
    private var formSelectedCountries = Set<Country>()
    private var cancellables: Set<AnyCancellable> = []
    private (set) var countrySelectionConfig: CountrySelectionConfig = .defaultValue
    private var dataSource: UITableViewDiffableDataSource<CountrySelection, AnyHashable>?
    
    private let reloadDataRelay = PassthroughSubject<Bool, Never>()
    let countrySelectionSubject = PassthroughSubject<(IndexPath, Bool), Never>()
    var isInSearchMode = false
    let dismissView = PassthroughSubject<Bool, Error>()
    
    init(countryProvider: CountryProvider, textHighlighter: TextHighlighter, presenterQueue: DispatchQueue) {
        self.countryProvider = countryProvider
        self.textHighlighter = textHighlighter
        self.presenterQueue = presenterQueue
    }
    
    func tearDown() {
        cancellables.forEach { $0.cancel() }
        dataSource = nil
    }
    
    func configureBindings() {
        Just.init(true)
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
                CountrySelectionViewModel(country: $0, isSelected: false, shouldShowCellSeparator: false)
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
            //self?.viewRestorationRelay.accept(true)
        })
    }
    
    private func data(for section: CountrySelection) -> [AnyHashable] {
        var vms = [AnyHashable]()
        switch section {
        case .worldwide:
            if !isInSearchMode {
                if countrySelectionConfig.shouldShowWorldWide {
                    let isCountrySelected = formSelectedCountries.contains(Country.Worldwide)
                    let vm = CountrySelectionViewModel(country: Country.Worldwide, isSelected: isCountrySelected, highlightedText: NSAttributedString(string: Country.Worldwide.localizedName))
                    vms.append(vm)
                }
            }
        case .worldwideExplanation:
            if !isInSearchMode {
                if countrySelectionConfig.shouldShowWorldWide {
                    let vm = FooterViewModel(callout: "info_about_worldwide_selection".localized())
                    vms.append(vm)
                }
            }
        case .allCountries:
            vms.append(contentsOf: filteredCountryList)
        case .rosterExplanation:
            if !isInSearchMode {
                if !countrySelectionConfig.rosterJustification.isEmpty {
                    let vm = FooterViewModel(callout: countrySelectionConfig.rosterJustification)
                    vms.append(vm)
                }
            }
        }
        return vms
    }
    
    func register(config: CountrySelectionConfig) {
        formSelectedCountries = Set(config.previouslySelectedCountries)
        countrySelectionConfig = config
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

    /*
    private func provideViewModel(for indexPath: IndexPath) -> AnyHashable {
        let countrySection = CountrySelection(rawValue: indexPath.section)!
        switch countrySection {
        case .worldwide:

        case .worldwideExplanation:
            
        case .allCountries:
            //let countryAtIndexPath = filteredCountryList[indexPath.row]
            //let isCountrySelected = formSelectedCountries.contains(countryAtIndexPath.country)
            //return CountrySelectionViewModel(country: countryAtIndexPath.country, isSelected: isCountrySelected, highlightedText: countryAtIndexPath.highlightedText)
        case .rosterExplanation:
            return
        }
    }
    */

    func getSelectedCountries() -> [Country] {
        return formSelectedCountries.map { $0 }
    }
    
    private func apply(searchQuery: String) {
        // Strip out all the leading and trailing spaces.
        let strippedString = searchQuery.trimmingCharacters(in: CharacterSet.whitespaces)
        
        if strippedString.count == 0 {
            isInSearchMode = false
            filteredCountryList = fullCountryList.map { CountrySelectionViewModel(country: $0) }
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
                return CountrySelectionViewModel(country: eachCountry, highlightedText: textToHighlight)
            })
        }
        reloadDataRelay.send(true)
    }
    
    private func configure(cell: UITableViewCell, with viewModel: AnyHashable) {
        switch cell {
        case let countryCell as CountryCell:
            if let vm = viewModel as? CountrySelectionViewModel {
                countryCell.configure(with: vm, delegate: self)
            }
        case let footerCell as FooterCell:
            if let vm = viewModel as? FooterViewModel {
                footerCell.configure(with: vm)
            }
        default:
            break
        }
    }
}

// MARK: UITableViewDelegate
extension CountrySelectionPresenter: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
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
}

// MARK: SingleCountrySelectionDelegate
extension CountrySelectionPresenter: SingleCountrySelectionDelegate {
    func didSelect(country: Country) {
        if countrySelectionConfig.canMultiSelect {
            //multi selection is allowed
            if country == Country.Worldwide {
                //user selected Worldwide - deselect everything else
                clearPreviousAnd(selectThis: country)
            } else {
                //user selected another country
                if formSelectedCountries.contains(Country.Worldwide) {
                    //but previously worldwide was selected, so clear everything
                    //and select
                    clearPreviousAnd(selectThis: country)
                } else {
                    formSelectedCountries.insert(country)
                }
            }
        } else {
            //only single selection is allowed
            clearPreviousAnd(selectThis: country)
        }
        
        if countrySelectionConfig.autoDismiss {
            dismissView.send(true)
        }
    }
    
    func didDeselect(country: Country) {
        formSelectedCountries.remove(country)
        if countrySelectionConfig.autoDismiss {
            dismissView.send(true)
        }
    }
    
    private func clearPreviousAnd(selectThis: Country) {
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
                    countrySelectionSubject.send((indexPathToDeselect, false))
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
                    countrySelectionSubject.send((indexPathToDeselect, false))
                }
            }
        }
        formSelectedCountries.removeAll()
        formSelectedCountries.insert(selectThis)
    }
}
