//
//  CountryRowCollectionViewCell.swift
//  
//
//  Created by eclypse on 2/16/24.
//

import FlagKit
import UIKit

class CountryRowCollectionViewCell: UICollectionViewCell, NibLoader {
    @IBOutlet private weak var countryFlag: UIImageView!
    @IBOutlet private weak var countryName: UILabel!
    @IBOutlet private weak var checkMark: UIImageView!
    @IBOutlet private weak var flagHeight: NSLayoutConstraint!
    @IBOutlet private weak var flagWidth: NSLayoutConstraint!
    
    private var cellSelectionStyle: CountryCellSelectionStyle = .checkMark
    private var configuration: CountryPickerConfiguration = .default()
    
    override func prepareForReuse() {
        countryFlag.image = nil
        countryName.attributedText = nil
        checkMark.image = nil
        selectedBackgroundView = nil
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
    
    override var isSelected: Bool {
        didSet {
            if self.isSelected {
                switch traitCollection.userInterfaceIdiom {
                case .mac:
                    if let providedCellSelectionColor = configuration.macConfiguration.cellSelectionColor {
                        checkMark.isHidden = true
                        
                        self.selectedBackgroundView = provideSelectedBackgroundView(cellSelectionColor: providedCellSelectionColor)
                        
                        if configuration.macConfiguration._isRowSelectionColorPerceivedBright {
                            countryName.textColor = UIColor.label
                        } else {
                            countryName.textColor = UIColor.white
                        }
                    } else {
                        checkMark.isHidden = false
                        self.selectedBackgroundView = nil
                    }
                default:
                    switch configuration.theme.cellSelectionStyle {
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
