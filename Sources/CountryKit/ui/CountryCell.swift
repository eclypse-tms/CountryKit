//
//  CountryCell.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import UIKit
import FlagKit

class CountryCell: UITableViewCell, NibLoader {
    @IBOutlet private weak var countryFlag: UIImageView!
    @IBOutlet private weak var countryName: UILabel!
    @IBOutlet private weak var flagHeight: NSLayoutConstraint!
    @IBOutlet private weak var flagWidth: NSLayoutConstraint!
    
    private var cellSelectionStyle: CountryCellSelectionStyle = .checkMark
    
    private func resetCell() {
        countryFlag.image = nil
        countryName.attributedText = nil
        selectedBackgroundView = nil
        self.tintColor = nil
        accessoryType = .none
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        resetCell()
    }
    
    func configure(with viewModel: CountryViewModel) {
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
        
        #if targetEnvironment(macCatalyst)
        flagHeight.constant = CountryPickerPresenter.universalConfig.macConfiguration.flagSize.height
        flagWidth.constant = CountryPickerPresenter.universalConfig.macConfiguration.flagSize.width
        #endif
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            switch CountryPickerPresenter.universalConfig.theme.cellSelectionStyle {
            case .checkMark:
                accessoryType = .checkmark
                if let selectionTintColor = CountryPickerPresenter.universalConfig.theme.selectionTint {
                    self.tintColor = selectionTintColor
                }
            case .highlight:
                selectedBackgroundView = provideSelectedBackgroundView(cellSelectionColor: CountryPickerPresenter.universalConfig.theme.selectionTint)
                if CountryPickerPresenter.universalConfig.theme._isRowSelectionColorPerceivedBright {
                    countryName.textColor = UIColor.label
                } else {
                    countryName.textColor = UIColor.white
                }
            }
        } else {
            self.selectedBackgroundView = nil
            countryName.textColor = UIColor.label
            accessoryType = .none
        }
    }
    
    /*
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            switch traitCollection.userInterfaceIdiom {
            case .mac:
                if let providedCellSelectionColor = configuration.theme.selectionTint {
                    selectionStyle = .none
                    
                    if self.selectedBackgroundView == nil {
                        let newView = UIView()
                        newView.backgroundColor = providedCellSelectionColor
                        self.selectedBackgroundView = newView
                    }
                    
                    if configuration.theme._isRowSelectionColorPerceivedBright {
                        countryName.textColor = UIColor.label
                    } else {
                        countryName.textColor = UIColor.white
                    }
                } else {
                    selectionStyle = .default
                    contentView.backgroundColor = nil
                }
            default:
                switch configuration.theme.cellSelectionStyle {
                case .checkMark:
                    accessoryType = .checkmark
                    selectionStyle = .none
                case .highlight:
                    accessoryType = .none
                    selectionStyle = .default
                }
            }
        } else {
            switch traitCollection.userInterfaceIdiom {
            case .mac:
                self.selectedBackgroundView = nil
                countryName.textColor = UIColor.label
            default:
                accessoryType = .none
                selectionStyle = .none
            }
        }
    }
    */
    
    private func provideSelectedBackgroundView(cellSelectionColor: UIColor?) -> UIView {
        let newBackgroundView = UIView()
        if designedForMac {
            newBackgroundView.roundCorners(cornerRadius: UIFloat(8))
        }
        newBackgroundView.backgroundColor = cellSelectionColor ?? CountryPickerColor.defaultHighlight
        return newBackgroundView
    }
}
