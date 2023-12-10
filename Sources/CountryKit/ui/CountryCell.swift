//
//  CountryCell.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import UIKit
import FlagKit

class CountryCell: UITableViewCell, NibLoadable {
    @IBOutlet private weak var countryFlag: UIImageView!
    @IBOutlet private weak var countryName: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        selectionStyle = .none
        accessoryType = .none
    }
    
    override func prepareForReuse() {
        countryFlag.image = nil
        countryName.attributedText = nil
    }
    
    func configure(with viewModel: CountryViewModel) {
        countryFlag.image = Flag.rectImage(with: viewModel.country)
        if let validHighlightedText = viewModel.highlightedText {
            countryName.attributedText = validHighlightedText
        } else {
            countryName.text = viewModel.country.localizedName
        }
    }
    
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        if selected {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
    }
}
