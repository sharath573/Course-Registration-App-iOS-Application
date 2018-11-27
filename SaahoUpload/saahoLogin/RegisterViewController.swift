  //
//  RegisterViewController.swift
//  saahoLogin
//
//  Created by Sharath on 11/11/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import UIKit


class RegisterViewController: UIViewController {
    @IBOutlet weak var ename: UITextField!
    @IBOutlet weak var fname: UITextField!
    @IBOutlet weak var id: UITextField!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var pwd: UITextField!
    @IBOutlet weak var dltID: UITextField!
    

    
    @IBAction func regisBtn(_ sender: Any) {
        if fname.text == ""{
            setAlert(title: "Oops", message: "Enter your First Name")
        }
        if ename.text == ""{
            setAlert(title: "Oops", message: "Enter your Last Name ")
        }
        if id.text == ""{
            setAlert(title: "Oops", message: "Enter your RedID")
        }
        if pwd.text == ""{
            setAlert(title: "Oops", message: "Enter your Password")
        }
        if email.text == ""{
            setAlert(title: "Oops", message: "Enter your Email")
        }
        //dict
        let dict:[String:Any] = ["firstname":fname.text as Any,"lastname":ename.text as Any,"redid":id.text as Any,"password":pwd.text as Any,"email":email.text as Any]
        //postdata
        do {
            let json=try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            if let url = URL(string: "https://bismarck.sdsu.edu/registration/addstudent") {
                var mutableRequest = URLRequest.init(url: url)
                mutableRequest.httpMethod = "POST"
                mutableRequest.setValue("application/json",
                                        forHTTPHeaderField: "Content-Type")
                let session = URLSession.shared
                let task = session.uploadTask(with: mutableRequest,
                                              from: json,
                                              completionHandler: uploadResponse)
                task.resume()
                
            }
            else {
                print("Unable to create URL")
            }
        }catch{
            
        }
       
      
        
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        fname.text = ""
        ename.text = ""
        id.text = ""
        email.text = ""
        pwd.text = ""
      
        
    }
    override func viewDidAppear(_ animated: Bool) {
        if let redIDDefault = UserDefaults.standard.object(forKey: "redIDValue") as? String //do the same thing for all the user defaults
        { id.text = redIDDefault }
        if let pwdDefault = UserDefaults.standard.object(forKey: "pwdValue") as? String //do the same thing for all the user defaults
        { pwd.text = pwdDefault }
    }

    //function to send data to server
    func uploadResponse(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            print(error as Any)
            return
        }
        
            DispatchQueue.main.async {
                do{
                let json: Any = try JSONSerialization.jsonObject(with: data!)
                let jsonDictionary = json as! NSDictionary
                let httpResponse = response as? HTTPURLResponse
                let status:Int = httpResponse!.statusCode
                if status == 200{
                if jsonDictionary["ok"] as? String == "Student Added" {
                    print("Success")
                    UserDefaults.standard.set(self.id.text, forKey: "redIDValue")
                    UserDefaults.standard.set(self.pwd.text, forKey: "pwdValue")
                    self.setAlert(title: "Yehh! You are Registered", message: "Your Details are  registered with your RedID. Go back to Login")
                }
                else{
                    let message = jsonDictionary["error"] as! String
                    self.setAlert(title: "Registration Error!", message: message)
                        }
                    }
               
            }catch{
                print("error in uploadresponse")
            }
            }
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
