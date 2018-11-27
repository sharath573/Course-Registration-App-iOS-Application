//
//  ViewController.swift
//  saahoLogin
//
//  Created by Sharath on 11/11/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import UIKit


class ViewController: UIViewController {
    @IBOutlet weak var userId: UITextField!
    @IBOutlet weak var userpwd: UITextField!

    var notReg = 0
    var login = 0
    var userIDdata = Int()
    var pwdIDdata = String()
    var a = String()
    var b = String()
    @IBAction func loginBtn(_ sender: Any) {
        let userIdtext = Int(userId.text!)
        let userIdtextString = String(userId.text!)
        let userIdpwd = String(userpwd.text!)
        if userIdtextString == ""{
            setAlert(title: "Oops!", message: "Please Enter Your UserID ")
        }
        if userIdpwd == ""{
            setAlert(title: "Oops!", message: "Please Enter Your Password ")
        }
    }
    @IBAction func checkBtn(_ sender: Any) {
        if  userId.text ==  UserDefaults.standard.string(forKey: "redIDValue") {
      userpwd.text =   UserDefaults.standard.string(forKey: "pwdValue")
        }
        else{
            setAlert(title: "Sorry", message: "No saved password is available for this RedID. Please Enter Manually")
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        userId.text =  UserDefaults.standard.string(forKey: "redIDValue")
    }

    func setAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion : nil)
        }))
        self.present(alert, animated:true, completion:nil)
    }
  
}


