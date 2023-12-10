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

extension NibLoadable {
    
    public static var nibName: String {
        return String(describing: self.self)
    }
    
    public static var nibBundle: Bundle {
        return Bundle(for: self.self)
    }
    
    public static var nib: UINib {
        return UINib(nibName: nibName, bundle: nibBundle)
    }
    
}

extension NibLoadable where Self: UIView {
    
    public static var fromNib: Self {
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
    
}

extension NibLoadable where Self: UIViewController {
    
    public static var fromNib: Self {
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
    public static func fromNib(_ nibName: String? = nil) -> Self {
        let nibName = nibName ?? self.nibName
        let viewController = Self(nibName: nibName, bundle: nil)
        return viewController
    }
}
