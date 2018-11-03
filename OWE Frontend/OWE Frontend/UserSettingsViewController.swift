//
//  UserSettingsViewController.swift
//  OWE Frontend
//
//  Created by Hera Miao on 10/30/18.
//  Copyright © 2018 Juliann Fields. All rights reserved.
//

import UIKit

class UserSettingsViewController: UIViewController {
  
  let user = User()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }
  
  // MARK: - Actions
  @IBAction func cancel() {
    delegate?.addContactControllerDidCancel(controller: self)
  }
  
  @IBAction func done() {
    let contact = Contact()
    contact.name = nameField.text!
    contact.email = emailField.text
    contact.homePhone = homePhoneField.text
    contact.workPhone = workPhoneField.text
    contact.picture = picture
    self.saveContact(contact: contact)
    delegate?.addContactController(controller: self, didFinishAddingContact: contact)
  }
  
  func saveContact(contact: Contact){
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    let context = appDelegate.persistentContainer.viewContext
    let entity = NSEntityDescription.entity(forEntityName: "Person", in: context)
    let newUser = NSManagedObject(entity: entity!, insertInto: context)
    newUser.setValue(contact.email, forKey: "email")
    newUser.setValue(contact.name, forKey: "name")
    newUser.setValue(contact.homePhone, forKey: "home_phone")
    newUser.setValue(contact.workPhone, forKey: "work_phone")
    if let pic = contact.picture {
      newUser.setValue(UIImagePNGRepresentation(pic), forKey: "photo")
    }
    do {
      try context.save()
    } catch {
      print("Failed saving")
    }
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
