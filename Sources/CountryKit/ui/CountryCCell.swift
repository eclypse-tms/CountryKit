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
    @IBOutlet private weak var flagHeight: NSLayoutConstraint!
    @IBOutlet private weak var flagWidth: NSLayoutConstraint!
    @IBOutlet private weak var cellSeparator: UIView!
    
    private var cellSelectionStyle: CountryCellSelectionStyle = .checkMark
    
    private func resetCell() {
        countryFlag.image = nil
        countryName.attributedText = nil
        checkMark.image = nil
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
                    if let providedCellSelectionColor = CountryPickerPresenter.universalConfig.macConfiguration.cellSelectionColor {
                        checkMark.isHidden = true
                        
                        self.selectedBackgroundView = provideSelectedBackgroundView(cellSelectionColor: providedCellSelectionColor)
                        
                        if CountryPickerPresenter.universalConfig.macConfiguration._isRowSelectionColorPerceivedBright {
                            countryName.textColor = UIColor.label
                        } else {
                            countryName.textColor = UIColor.white
                        }
                    } else {
                        checkMark.isHidden = false
                        self.selectedBackgroundView = nil
                    }
                default:
                    switch CountryPickerPresenter.universalConfig.theme.cellSelectionStyle {
                    case .checkMark:
                        checkMark.isHidden = false
                        selectedBackgroundView = nil
                    case .highlight:
                        checkMark.isHidden = true
                        selectedBackgroundView = provideSelectedBackgroundView(cellSelectionColor: nil)
                    }
                }
            } else {
                switch traitCollection.userInterfaceIdiom {
                case .mac:
                    self.selectedBackgroundView = nil
                    countryName.textColor = UIColor.label
                default:
                    self.selectedBackgroundView = nil
                    self.checkMark.isHidden = true
                }
            }
        }
    }
    
    private func provideSelectedBackgroundView(cellSelectionColor: UIColor?) -> UIView {
        let newBackgroundView = UIView()
        newBackgroundView.backgroundColor = cellSelectionColor ?? UIColor.secondarySystemBackground
        return newBackgroundView
    }
}
