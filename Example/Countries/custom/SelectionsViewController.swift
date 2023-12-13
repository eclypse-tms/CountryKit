//
//  SelectionsViewController.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
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
    
    private var dataSource: UICollectionViewDiffableDataSource<SelectedCountriesSection, Country>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureMainView()
        configureInitialState()

        
        print("example view controller is loaded...")
    }
    
    private func configureMainView() {
        configureDataSource(with: mainView)
        mainView.register(SelectedCountryCell.nib, forCellWithReuseIdentifier: SelectedCountryCell.nibName)
        
        mainView.collectionViewLayout = generateCompositionalLayout(with: SelectedCountriesSection.allCases)
        mainView.allowsSelection = false
        
        mainView.isHidden = true //upon initial launch we are showing the configuration elements
    }
    
    private func configureInitialState() {
        limitedCountryStack.isHidden = true
        excludedCountryStack.isHidden = true
        
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
        
        
        let countrySelectionVC = UICountryPickerViewController(nibName: String(describing: UICountryPickerViewController.self), bundle: CountryKit.assetBundle)
        var config = CountryPickerConfiguration.default()
        config.allowsSelection = allowSelectionSwitch.isOn
        config.canMultiSelect = canMultiSelectSwitch.isOn
        
        config.cellSelectionStyle = CountryCellSelectionStyle(rawValue: cellSelectionStyleSegment.selectedSegmentIndex)! //don't force unwrap in a shipping application
        config.filteringCriteria = FilteringCriteria(rawValue: searchCriteriaSegment.selectedSegmentIndex)! //don't force unwrap in a shipping application
        
        if allowWorldwideSwitch.isOn {
            config.shouldShowWorldWide = true
            config.localizedWorldWide = worldwideTranslation.text ?? ""
            config.localizedWorldWideDescription = worldwideDescriptionTranslation.text
        } else {
            config.shouldShowWorldWide = false
            config.localizedWorldWide = ""
            config.localizedWorldWideDescription = ""
        }
        
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
        
        config.autoDismiss = autoDismissSwitch.isOn
        
        if preselectCountriesSwitch.isOn {
            let currentSnapshot = dataSource.snapshot()
            config.previouslySelectedCountries = Set(currentSnapshot.itemIdentifiers)
        } else {
            config.previouslySelectedCountries = Set()
        }        
        
        //save the configuration on the view controller
        countrySelectionVC.countryPickerConfiguration = config
        
        
        //get notified when user interacts with the country selection ui
        countrySelectionVC.delegate = self
        
        splitViewController?.setViewController(countrySelectionVC, for: .secondary)
    }
    
    private func addBorder(to uiTextView: UITextView) {
        uiTextView.layer.cornerRadius = 6
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
            return .dynamicWidthFixedHeight(estimatedWidth: 150, fixedHeight: 36)
        }
    }
    
    var interItemSpacing: CGFloat {
        return 8
    }
    
    var interGroupSpacing: CGFloat {
        return 8
    }
    
    func sectionInsets(layoutEnvironment: NSCollectionLayoutEnvironment) -> NSDirectionalEdgeInsets {
        return .init(top: 0, leading: 8, bottom: 0, trailing: 8)
    }
}