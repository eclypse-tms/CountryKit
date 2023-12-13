//
//  FooterCell.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import UIKit

open class FooterCell: UITableViewCell, NibLoader {
    @IBOutlet private weak var footerNote: UILabel!
    
    open override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        footerNote.text = nil
    }
    
    open func configure(with viewModel: FooterViewModel) {
        footerNote.text = viewModel.footerText
    }
}
