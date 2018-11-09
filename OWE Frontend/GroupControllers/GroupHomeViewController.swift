//
//  GroupHomeViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit

class GroupHomeViewController: UIViewController {
    @IBOutlet weak var tripImage: UIImageView!
    @IBOutlet var youOweTable: UITableView!
    @IBOutlet var newTransactionButton: UIButton!
    
    var detailItem: Group? {
        didSet {
            // Update the view.
            self.configureView()
        }
    }
    
    func configureView() {
        // Update the user interface for the detail item.
        if let detail: Group = self.detailItem {
            if let tripImage = self.tripImage {
                tripImage.image = detail.image
            }
            self.navigationItem.title = detail.title
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.configureView()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Segues
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editGroup" {
            let navController = segue.destination as! UINavigationController
            let controller = navController.topViewController as! GroupSettingsController
            controller.detailItem = detailItem
        }
    }
    
}
