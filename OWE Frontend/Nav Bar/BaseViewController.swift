//
//  BaseViewController.swift
//  OWE Frontend
//
//  Created by Juliann Fields on 11/11/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//
import UIKit

class BaseViewController: UIViewController, SlideMenuDelegate {
  
  override func viewDidLoad() {
    super.viewDidLoad()
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  
  func slideMenuItemSelectedAtIndex(_ index: Int32) {
    let topViewController : UIViewController = self.navigationController!.topViewController!
    print("View Controller is : \(topViewController) \n", terminator: "")
    switch(index){
      case 0:
          print("Profile\n", terminator: "")
          self.openViewControllerBasedOnIdentifier("Profile", "Main")
          break
      
      case 1:
        print("Groups\n", terminator: "")
        self.openViewControllerBasedOnIdentifier("Groups", "GroupViews")
        break
      
      case 2:
        print("Search People\n", terminator: "")
        self.openViewControllerBasedOnIdentifier("History", "HistoryVC")
        break
      
      case 3:
        print("Transfer to Bank\n", terminator: "")
        self.openViewControllerBasedOnIdentifier("History", "HistoryVC")
        break
      
      case 4:
        print("Trip Summaries\n", terminator: "")
        self.openViewControllerBasedOnIdentifier("History", "HistoryVC")
        break
      
      case 5:
        print("Settings\n", terminator: "")
        self.openViewControllerBasedOnIdentifier("Settings", "SettingsVC")
        break
      
      default:
        print("default\n", terminator: "")
      }
  }
  
  func openViewControllerBasedOnIdentifier(_ strIdentifier:String, _ board:String){
    let storyboard = UIStoryboard(name: board, bundle: nil)
    let destViewController : UIViewController = storyboard.instantiateViewController(withIdentifier: strIdentifier)
    
    let topViewController : UIViewController = self.navigationController!.topViewController!
    
    if (topViewController.restorationIdentifier! == destViewController.restorationIdentifier!){
      print("Same VC")
    } else {
      self.navigationController!.pushViewController(destViewController, animated: true)
    }
  }
  
  func addSlideMenuButton(){
    let btnShowMenu = UIButton(type: UIButton.ButtonType.system)
    btnShowMenu.setImage(self.defaultMenuImage(), for: UIControl.State())
    btnShowMenu.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
    btnShowMenu.addTarget(self, action: #selector(BaseViewController.onSlideMenuButtonPressed(_:)), for: UIControl.Event.touchUpInside)
    let customBarItem = UIBarButtonItem(customView: btnShowMenu)
    self.navigationItem.leftBarButtonItem = customBarItem;
  }
  
  func defaultMenuImage() -> UIImage {
    var defaultMenuImage = UIImage()
    
    UIGraphicsBeginImageContextWithOptions(CGSize(width: 30, height: 22), false, 0.0)
    
    UIColor.black.setFill()
    UIBezierPath(rect: CGRect(x: 0, y: 3, width: 30, height: 1)).fill()
    UIBezierPath(rect: CGRect(x: 0, y: 10, width: 30, height: 1)).fill()
    UIBezierPath(rect: CGRect(x: 0, y: 17, width: 30, height: 1)).fill()
    
    UIColor.white.setFill()
    UIBezierPath(rect: CGRect(x: 0, y: 4, width: 30, height: 1)).fill()
    UIBezierPath(rect: CGRect(x: 0, y: 11,  width: 30, height: 1)).fill()
    UIBezierPath(rect: CGRect(x: 0, y: 18, width: 30, height: 1)).fill()
    
    defaultMenuImage = UIGraphicsGetImageFromCurrentImageContext()!
    
    UIGraphicsEndImageContext()
    
    return defaultMenuImage;
  }
  
  @objc func onSlideMenuButtonPressed(_ sender : UIButton){
    if (sender.tag == 10)
    {
      // To Hide Menu If it already there
      self.slideMenuItemSelectedAtIndex(-1);
      
      sender.tag = 0;
      
      let viewMenuBack : UIView = view.subviews.last!
      
      UIView.animate(withDuration: 0.3, animations: { () -> Void in
        var frameMenu : CGRect = viewMenuBack.frame
        frameMenu.origin.x = -1 * UIScreen.main.bounds.size.width
        viewMenuBack.frame = frameMenu
        viewMenuBack.layoutIfNeeded()
        viewMenuBack.backgroundColor = UIColor.clear
      }, completion: { (finished) -> Void in
        viewMenuBack.removeFromSuperview()
      })
      
      return
    }
    
    sender.isEnabled = false
    sender.tag = 10
    
    let storyboard = UIStoryboard(name: "Main", bundle: nil)
    let menuVC : SideMenuViewController = storyboard.instantiateViewController(withIdentifier: "SideMenuViewController") as! SideMenuViewController
    menuVC.btnMenu = sender
    menuVC.delegate = self
    self.view.addSubview(menuVC.view)
    self.addChildViewController(menuVC)
    menuVC.view.layoutIfNeeded()
    
    
    menuVC.view.frame=CGRect(x: 0 - UIScreen.main.bounds.size.width, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
    
    UIView.animate(withDuration: 0.3, animations: { () -> Void in
      menuVC.view.frame=CGRect(x: 0, y: 0, width: UIScreen.main.bounds.size.width, height: UIScreen.main.bounds.size.height);
      sender.isEnabled = true
    }, completion:nil)
  }
}
