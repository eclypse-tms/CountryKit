//
//  CountryCCell.swift
//  
//
//  Created by eclypse on 2/16/24.
//

import FlagKit
import UIKit

class CountryCCell: UICollectionViewCell, NibLoader {
    @IBOutlet private weak var countryFlag: UIImageView!
    @IBOutlet private weak var countryName: UILabel!
    @IBOutlet private weak var checkMark: UIImageView!
    @IBOutlet private weak var cellAccessoryContainer: UIView!
    @IBOutlet private weak var flagHeight: NSLayoutConstraint!
    @IBOutlet private weak var flagWidth: NSLayoutConstraint!
    @IBOutlet private weak var cellSeparator: UIView!
    
    private var cellSelectionStyle: CountryCellSelectionStyle = .checkMark
    
    private func resetCell() {
        countryFlag.image = nil
        countryName.attributedText = nil
        cellAccessoryContainer.isHidden = true
        selectedBackgroundView = nil
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    func configure(with viewModel: CountryViewModel) {
        resetCell()
        countryFlag.image = Flag.rectImage(with: viewModel.country)
        if let validThemeFont = CountryPickerPresenter.universalConfig.theme.font {
            countryName.font = validThemeFont
        }
        
        self.cellSelectionStyle = CountryPickerPresenter.universalConfig.theme.cellSelectionStyle
        if let validHighlightedText = viewModel.highlightedSearchText {
            countryName.attributedText = validHighlightedText
        } else {
            countryName.text = viewModel.country.localizedName
        }
        
        if designedForMac {
            flagHeight.constant = CountryPickerPresenter.universalConfig.macConfiguration.flagSize.height
            flagWidth.constant = CountryPickerPresenter.universalConfig.macConfiguration.flagSize.width
            cellSeparator.backgroundColor = .clear
        } else {
            cellSeparator.backgroundColor = .separator
        }
    }
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                switch traitCollection.userInterfaceIdiom {
                case .mac:
                    if let providedCellSelectionColor = CountryPickerPresenter.universalConfig.theme.selectionTint {
                        cellAccessoryContainer.isHidden = true
                        
                        self.selectedBackgroundView = provideSelectedBackgroundView(cellSelectionColor: providedCellSelectionColor)
                        
                        if CountryPickerPresenter.universalConfig.theme._isRowSelectionColorPerceivedBright {
                            countryName.textColor = UIColor.label
                        } else {
                            countryName.textColor = UIColor.white
                        }
                    } else {
                        cellAccessoryContainer.isHidden = false
                        self.selectedBackgroundView = nil
                    }
                default:
                    switch CountryPickerPresenter.universalConfig.theme.cellSelectionStyle {
                    case .checkMark:
                        if let checkmarkTint = CountryPickerPresenter.universalConfig.theme.selectionTint {
                            checkMark.tintColor = checkmarkTint
                        }
                        cellAccessoryContainer.isHidden = false
                        selectedBackgroundView = nil
                    case .highlight:
                        cellAccessoryContainer.isHidden = true
                        selectedBackgroundView = provideSelectedBackgroundView(cellSelectionColor: CountryPickerPresenter.universalConfig.theme.selectionTint)
                    }
                }
            } else {
                switch traitCollection.userInterfaceIdiom {
                case .mac:
                    self.selectedBackgroundView = nil
                    countryName.textColor = UIColor.label
                default:
                    self.selectedBackgroundView = nil
                    self.cellAccessoryContainer.isHidden = true
                }
            }
        }
    }
    
    private func provideSelectedBackgroundView(cellSelectionColor: UIColor?) -> UIView {
        let newBackgroundView = UIView()
        if designedForMac {
            newBackgroundView.roundCorners(cornerRadius: UIFloat(8))
        }
        newBackgroundView.backgroundColor = cellSelectionColor ?? CountryPickerColor.defaultHighlight
        return newBackgroundView
    }
}
