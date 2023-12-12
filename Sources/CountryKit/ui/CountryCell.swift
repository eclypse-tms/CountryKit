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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        accessoryType = .none
    }
    
    private var cellSelectionStyle: CountrySelectionStyle = .checkMark
    
    override func prepareForReuse() {
        countryFlag.image = nil
        countryName.attributedText = nil
        
        selectionStyle = .none
        accessoryType = .none
    }
    
    func configure(with viewModel: CountryViewModel, cellSelectionStyle: CountrySelectionStyle) {
        countryFlag.image = Flag.rectImage(with: viewModel.country)
        self.cellSelectionStyle = cellSelectionStyle
        if let validHighlightedText = viewModel.highlightedText {
            countryName.attributedText = validHighlightedText
        } else {
            countryName.text = viewModel.country.localizedName
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            switch cellSelectionStyle {
            case .checkMark:
                accessoryType = .checkmark
                selectionStyle = .none
            case .highlight:
                accessoryType = .none
                selectionStyle = .default
            }
        } else {
            accessoryType = .none
            selectionStyle = .none
        }
    }
}
