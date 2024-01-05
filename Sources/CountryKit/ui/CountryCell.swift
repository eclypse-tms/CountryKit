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
    
    override func prepareForReuse() {
        countryFlag.image = nil
        countryName.attributedText = nil
        
        selectionStyle = .none
        accessoryType = .none
    }
    
    func configure(with viewModel: CountryViewModel, configuration: CountryPickerConfiguration) {
        countryFlag.image = Flag.rectImage(with: viewModel.country)
        if let validThemeFont = configuration.themeFont {
            countryName.font = validThemeFont
        }
        
        self.cellSelectionStyle = configuration.cellSelectionStyle
        if let validHighlightedText = viewModel.highlightedSearchText {
            countryName.attributedText = validHighlightedText
        } else {
            countryName.text = viewModel.country.localizedName
        }
        
        #if targetEnvironment(macCatalyst)
        flagHeight.constant = configuration.macConfiguration.flagSize.height
        flagWidth.constant = configuration.macConfiguration.flagSize.width
        #endif
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            #if targetEnvironment(macCatalyst)
            selectionStyle = .default
            #else
            switch cellSelectionStyle {
            case .checkMark:
                accessoryType = .checkmark
                selectionStyle = .none
            case .highlight:
                accessoryType = .none
                selectionStyle = .default
            }
            #endif
        } else {
            accessoryType = .none
            selectionStyle = .none
        }
    }
}
