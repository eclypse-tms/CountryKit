//
//  FooterCell.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import UIKit

class FooterCell: UITableViewCell, NibLoadable {
    @IBOutlet private weak var footerNote: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        
        footerNote.text = nil
    }
    
    func configure(with viewModel: FooterViewModel) {
        footerNote.text = viewModel.callout
    }
}
