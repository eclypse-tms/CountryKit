//
//  NibLoadable.swift
//  Countries
//
//  Created by eclypse on 12/11/23.
//

import UIKit

public protocol NibLoadable: AnyObject {
    static var nibName: String { get }
    static var nibBundle: Bundle { get }
}

public extension NibLoadable {
    
    static var nibName: String {
        return String(describing: self.self)
    }
    
    static var nibBundle: Bundle {
        return Bundle(for: self.self)
    }
    
    static var nib: UINib {
        return UINib(nibName: nibName, bundle: nibBundle)
    }
    
}

public extension NibLoadable where Self: UIView {
    
    static var fromNib: Self {
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
}
