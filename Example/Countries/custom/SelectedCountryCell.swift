//
//  SelectedCountryCell.swift
//  countrykit_example
//
//  Created by eclypse on 12/10/23.
//

import UIKit
import CountryKit

class SelectedCountryCell: UICollectionViewCell, NibLoadable {

    @IBOutlet private weak var countryFlag: UIImageView!
    @IBOutlet private weak var countryName: UILabel!
    @IBOutlet private weak var container: UIView!
    
    #if !targetEnvironment(macCatalyst)
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        
        container.roundCorners(cornerRadius: 12)
    }
    #endif
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        countryName.text = nil
        countryFlag.image = nil
    }
    
    func configure(with country: Country) {
        self.countryFlag.image = country.flagImage
        self.countryName.text = country.localizedName
    }
}
