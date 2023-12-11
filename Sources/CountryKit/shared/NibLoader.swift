//
//  NibLoader.swift
//  CountryKit
//
//  Created by eclypse on 12/9/23.
//

import Foundation
import UIKit

protocol NibLoader: AnyObject {
    static var nibName: String { get }
    static var nibBundle: Bundle { get }
}

extension NibLoader {
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

extension NibLoader where Self: UIView {
    static var fromNib: Self {
        return nib.instantiate(withOwner: nil, options: nil).first as! Self
    }
}

extension NibLoader where Self: UIViewController {
    static var fromNib: Self {
        return Self(nibName: self.nibName, bundle: nil)
    }
    static func fromNib(_ nibName: String? = nil) -> Self {
        let nibName = nibName ?? self.nibName
        let viewController = Self(nibName: nibName, bundle: nil)
        return viewController
    }
}
