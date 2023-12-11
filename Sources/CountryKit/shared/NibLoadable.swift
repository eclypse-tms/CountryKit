//
//  NibLoadable.swift
//  countrykit_example
//
//  Created by Turker Nessa on 12/9/23.
//

import Foundation
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
        return CountryKit.assetBundle
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

public extension NibLoadable where Self: UIViewController {
    
    static var fromNib: Self {
        return Self(nibName: self.nibName, bundle: nil)
    }
    
    /// Loads a view controller from a nib file. You can pass an explicit nib name to load the view
    /// controller from. Otherwise, the nib name will default to the class name.
    ///
    /// - Warning: For view controller subclasses that use a common ancestor nib, pass the name of
    ///   the nib explicitly.
    ///
    /// - Parameter nibName: Optional nib name
    /// - Returns: An instance of the view controller loaded from the nib
    static func fromNib(_ nibName: String? = nil) -> Self {
        let nibName = nibName ?? self.nibName
        let viewController = Self(nibName: nibName, bundle: nil)
        return viewController
    }
}
