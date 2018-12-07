//
//  SideMenuViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/11/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import Foundation
import UIKit

protocol SlideMenuDelegate {
    func slideMenuItemSelectedAtIndex(_ index : Int32)
}

class SideMenuViewController: UIViewController , UITableViewDataSource, UITableViewDelegate {
  
  @IBOutlet weak var balance: UILabel!
    @IBOutlet var tblMenuOptions : UITableView!
    @IBOutlet var btnCloseMenuOverlay : UIButton!
    var arrayMenuOptions = [Dictionary<String,String>]()
    var btnMenu : UIButton!
    var delegate : SlideMenuDelegate?
  
  var user: User?
  let userDelegate = UIApplication.shared.delegate as! AppDelegate
    
    override func viewDidLoad() {
      super.viewDidLoad()
      tblMenuOptions.tableFooterView = UIView()
      // Do any additional setup after loading the view.
      
      if let user = userDelegate.user {
        self.user = user
      } else {
        self.user = User.getUser(1)
        userDelegate.user = self.user
      }
      
      balance.text! = String(user!.balance)
    }
    
    override func didReceiveMemoryWarning() {
      super.didReceiveMemoryWarning()
      // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
      super.viewWillAppear(animated)
      updateArrayMenuOptions()
    }
    
    func updateArrayMenuOptions(){
      arrayMenuOptions.append(["title":"Groups"])
      arrayMenuOptions.append(["title":"Search People"])
      arrayMenuOptions.append(["title":"Transfer to Bank"])
      arrayMenuOptions.append(["title":"Trip Summaries"])
      arrayMenuOptions.append(["title":"User Settings"])
      arrayMenuOptions.append(["title":"Log Out"])
      
      tblMenuOptions.reloadData()
    }
  
  @IBAction func goToProfile() {
    let btn = UIButton(type: UIButton.ButtonType.custom)
    btn.tag = 0
    self.onCloseMenuClick(btn)
  }
    
    @IBAction func onCloseMenuClick(_ button:UIButton!){
      btnMenu.tag = 0
      
      if (self.delegate != nil) {
          var index = Int32(button.tag)
          if(button == self.btnCloseMenuOverlay){
              index = -1
          }
          delegate?.slideMenuItemSelectedAtIndex(index)
      }
      
      UIView.animate(withDuration: 0.3, animations: { () -> Void in
          self.view.frame = CGRect(x: -UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width,height: UIScreen.main.bounds.size.height)
          self.view.layoutIfNeeded()
          self.view.backgroundColor = UIColor.clear
      }, completion: { (finished) -> Void in
          self.view.removeFromSuperview()
          self.removeFromParentViewController()
      })
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
      let cell : UITableViewCell = tableView.dequeueReusableCell(withIdentifier: "cellMenu")!
      
      cell.selectionStyle = UITableViewCell.SelectionStyle.none
      cell.layoutMargins = UIEdgeInsets.zero
      cell.preservesSuperviewLayoutMargins = false
      cell.backgroundColor = UIColor.clear
      
      let lblTitle : UILabel = cell.contentView.viewWithTag(101) as! UILabel
      
      lblTitle.text = arrayMenuOptions[indexPath.row]["title"]!
      
      return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
      let btn = UIButton(type: UIButton.ButtonType.custom)
      btn.tag = indexPath.row + 1
      self.onCloseMenuClick(btn)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      return arrayMenuOptions.count
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
      return 1;
    }
}
