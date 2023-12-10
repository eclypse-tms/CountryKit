//
//  ExampleViewController.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import UIKit
import Composure

class ExampleViewController: UIViewController {
    
    @IBOutlet private weak var mainView: UICollectionView!
    @IBOutlet private weak var selectCountryButton: UIButton!
    
    private var dataSource: UICollectionViewDiffableDataSource<SelectedCountriesSection, Country>!

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        configureMainView()
        print("example view controller is loaded...")
    }
    
    private func configureMainView() {
        configureDataSource(with: mainView)
        mainView.register(SelectedCountryCell.nib, forCellWithReuseIdentifier: SelectedCountryCell.nibName)
        
        mainView.collectionViewLayout = generateCompositionalLayout(with: SelectedCountriesSection.allCases)
        mainView.allowsSelection = false
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
}

extension ExampleViewController: SingleCountrySelectionDelegate {
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
}

extension ExampleViewController: BulkCountrySelectionDelegate {
    func didFinishSelecting(countries: [Country]) {
        print("user selected the following countries: \(countries)")
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
}
