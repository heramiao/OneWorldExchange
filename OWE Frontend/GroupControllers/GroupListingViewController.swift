//
//  GroupListingViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/4/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit

class GroupListingViewController: UITableViewController, UINavigationControllerDelegate, AddGroupControllerDelegate {
    
    // MARK: - Properties
    var groups = [Group]()
    var dataManager = DataManager()
    
    // MARK: - Delegate protocols
    func GroupSettingsViewControllerDidCancel(controller: GroupSettingsViewController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addGroupController(controller: GroupSettingsViewController, didFinishCreatingGroup group: Group) {
        let newRowIndex = groups.count
        
        groups.append(group)
        
        let indexPath = NSIndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        groupTable.insertRows(at: indexPaths as [IndexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
}
