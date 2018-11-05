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
    func addGroupControllerDidCancel(controller: AddGroupController) {
        dismiss(animated: true, completion: nil)
    }
    
    func addGroupController(controller: AddGroupController, didFinishAddingGroup group: Groups) {
        let newRowIndex = groups.count
        
        groups.append(group)
        
        let indexPath = NSIndexPath(row: newRowIndex, section: 0)
        let indexPaths = [indexPath]
        userTable.insertRows(at: indexPaths as [IndexPath], with: .automatic)
        
        dismiss(animated: true, completion: nil)
    }
}
