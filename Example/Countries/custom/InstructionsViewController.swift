//
//  InstructionsViewController.swift
//  countrykit_example
//
//  Created by eclypse on 12/10/23.
//

import UIKit
import CountryKit

class InstructionsViewController: UIViewController, ToolbarActionsResponder {
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
    
    override func responds(to aSelector: Selector!) -> Bool {
        let clearSelectionsSelector = #selector(ToolbarActionsResponder.clearSelections(_:))
        return  aSelector != clearSelectionsSelector
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
