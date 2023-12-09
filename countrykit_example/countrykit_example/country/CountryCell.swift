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
    @IBOutlet private weak var cellSeparator: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        //selectedStatus.isHidden = true
        selectionStyle = .none
        accessoryType = .none
    }
    
    override func prepareForReuse() {
        countryFlag.image = nil
        countryName.attributedText = nil
        cellSeparator.isHidden = true
        //selectedStatus.isHidden = true
        contentView.gestureRecognizers?.removeAll()
    }
    
    func configure(with viewModel: CountrySelectionViewModel) {
        countryFlag.image = Flag.rectImage(with: viewModel.country)
        countryName.attributedText = viewModel.highlightedText
        
        
        if viewModel.isSelected {
            accessoryType = .checkmark
        } else {
            accessoryType = .none
        }
        
        
        if viewModel.shouldShowCellSeparator {
            cellSeparator.isHidden = false
        } else {
            cellSeparator.isHidden = true
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
