//
//  SelectedCountryCell.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/10/23.
//

import UIKit
import FlagKit

class SelectedCountryCell: UICollectionViewCell, NibLoadable {

    @IBOutlet private weak var countryFlag: UIImageView!
    @IBOutlet private weak var countryName: UILabel!
    @IBOutlet private weak var container: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        container.roundCorners(cornerRadius: 12)
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryName.text = nil
        countryFlag.image = nil
    }
    
    func configure(with country: Country) {
        self.countryFlag.image = Flag(countryCode: country.alpha2Code)?.image(style: .roundedRect)
        self.countryName.text = country.localizedName
    }

}
