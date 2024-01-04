//
//  InstructionsViewController.swift
//  countrykit_example
//
//  Created by eclypse on 12/10/23.
//

import UIKit

class InstructionsViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {
        #if targetEnvironment(macCatalyst)
        if let toolbaritem = sender as? NSToolbarItem {
            toolbaritem.isEnabled = false
            return true
        }
        return super.canPerformAction(action, withSender: sender)
        #else
        return super.canPerformAction(action, withSender: sender)
        #endif
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
