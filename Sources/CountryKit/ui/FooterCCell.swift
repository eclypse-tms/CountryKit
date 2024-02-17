//
//  FooterCCell.swift
//  
//
//  Created by eclypseon 2/16/24.
//

import UIKit

class FooterCCell: UICollectionViewCell, NibLoader {
    @IBOutlet private weak var footerNote: UILabel!
    
    open override func prepareForReuse() {
        super.prepareForReuse()
        
        footerNote.text = nil
    }
    
    open func configure(with viewModel: FooterViewModel) {
        footerNote.text = viewModel.footerText
    }
}
