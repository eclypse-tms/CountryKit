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
    private var configuration: CountryPickerConfiguration = .default()
    
    override func prepareForReuse() {
        countryFlag.image = nil
        countryName.attributedText = nil
        
        selectionStyle = .none
        accessoryType = .none
    }
    
    func configure(with viewModel: CountryViewModel, configuration: CountryPickerConfiguration) {
        countryFlag.image = Flag.rectImage(with: viewModel.country)
        if let validThemeFont = configuration.theme.font {
            countryName.font = validThemeFont
        }
        
        self.cellSelectionStyle = configuration.theme.cellSelectionStyle
        if let validHighlightedText = viewModel.highlightedSearchText {
            countryName.attributedText = validHighlightedText
        } else {
            countryName.text = viewModel.country.localizedName
        }
        
        #if targetEnvironment(macCatalyst)
        flagHeight.constant = configuration.macConfiguration.flagSize.height
        flagWidth.constant = configuration.macConfiguration.flagSize.width
        #endif
        
        self.configuration = configuration
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            switch traitCollection.userInterfaceIdiom {
            case .mac:
                if let providedCellSelectionColor = configuration.macConfiguration.cellSelectionColor {
                    selectionStyle = .none
                    
                    if self.selectedBackgroundView == nil {
                        let newView = UIView()
                        newView.backgroundColor = providedCellSelectionColor
                        self.selectedBackgroundView = newView
                    }
                    
                    if configuration.macConfiguration._isRowSelectionColorPerceivedBright {
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
}
