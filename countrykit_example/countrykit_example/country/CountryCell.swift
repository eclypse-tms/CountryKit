//
//  CountryCell.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import UIKit
import FlagKit

protocol SingleCountrySelectionDelegate: AnyObject {
    func didSelect(country: Country)
    func didDeselect(country: Country)
    func didClickToOpenBulkCountrySelection()
}

extension SingleCountrySelectionDelegate {
    //make it optional
    func didClickToOpenBulkCountrySelection() {}
}

/// this cell shows an indication of whether it is selected or not
protocol SelectableCell: AnyObject {
    func performSelection()
    func performDeselection()
}

class CountryCell: UITableViewCell, SelectableCell, NibLoadable {
    @IBOutlet private weak var selectedStatus: UIImageView!
    @IBOutlet private weak var countryFlag: UIImageView!
    @IBOutlet private weak var countryName: UILabel!
    @IBOutlet private weak var cellSeparator: UIView!
    
    private var countrySelectionInfo: CountrySelectionViewModel?
    private weak var delegate: SingleCountrySelectionDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectedStatus.isHidden = true
    }
    
    override func prepareForReuse() {
        countryFlag.image = nil
        countryName.attributedText = nil
        cellSeparator.isHidden = true
        selectedStatus.isHidden = true
        contentView.gestureRecognizers?.removeAll()
    }
    
    func configure(with viewModel: CountrySelectionViewModel, delegate: SingleCountrySelectionDelegate? = nil) {
        countryFlag.image = Flag.rectImage(with: viewModel.country)
        countryName.attributedText = viewModel.highlightedText
        
        if viewModel.isSelected {
            selectedStatus.isHidden = false
        } else {
            selectedStatus.isHidden = true
        }
        
        if viewModel.shouldShowCellSeparator {
            cellSeparator.isHidden = false
        } else {
            cellSeparator.isHidden = true
        }
        
        self.countrySelectionInfo = viewModel
        self.delegate = delegate
        
        if viewModel.userInteractionStatus == .interactionEnabled {
            if viewModel.allowsSelection {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnThisCountry(_:)))
                contentView.addGestureRecognizer(tapGesture)
            } else if viewModel.interpretSelectionAsIntentToModify {
                let tapGesture = UITapGestureRecognizer(target: self, action: #selector(didTapOnAnyCountry(_:)))
                contentView.addGestureRecognizer(tapGesture)
            }
        }
    }
    
    @objc private func didTapOnThisCountry(_ sender: UIGestureRecognizer) {
        guard let validVM = countrySelectionInfo else { return }
        if validVM.isSelected {
            performDeselection()
            delegate?.didDeselect(country: validVM.country)
        } else {
            performSelection()
            delegate?.didSelect(country: validVM.country)
        }
    }
    
    @objc private func didTapOnAnyCountry(_ sender: Any) {
        delegate?.didClickToOpenBulkCountrySelection()
    }
    
    func performSelection() {
        countrySelectionInfo?.isSelected = true
        selectedStatus.isHidden = false
    }
    
    func performDeselection() {
        countrySelectionInfo?.isSelected = false
        selectedStatus.isHidden = true
    }
}
