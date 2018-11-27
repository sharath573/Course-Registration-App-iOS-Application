//
//  DetailViewController.swift
//  saahoLogin
//
//  Created by Sharath on 11/19/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {

    @IBAction func BackBtn(_ sender: Any) {
        Back = 1
       
        
    }
    
    @IBAction func AddBtn(_ sender: Any) {
        if SeatFilled == 0 {
        var urlComponents = URLComponents(string: "https://bismarck.sdsu.edu/registration/registerclass?")!
        urlComponents.queryItems = [
            URLQueryItem(name: "redid", value: String(redIDfromSub)),
            URLQueryItem(name: "password", value: String(pwdfromSub)),
            URLQueryItem(name: "courseid", value: String(DcourseIDdata))
        ]
        let urlString = urlComponents.url
        //print(urlString)
        
        let session2 = URLSession.shared
        let task2 = session2.dataTask(with: urlString!, completionHandler: getWebPage)
        task2.resume()
        } else {
        //////////////////////////////////////////////////
        var urlComponents3 = URLComponents(string: "https://bismarck.sdsu.edu/registration/waitlistclass?")!
        urlComponents3.queryItems = [
            URLQueryItem(name: "redid", value: String(redIDfromSub)),
            URLQueryItem(name: "password", value: String(pwdfromSub)),
            URLQueryItem(name: "courseid", value: String(DcourseIDdata))
        ]
        let urlString3 = urlComponents3.url
        //print(urlString3)
        
        let session3 = URLSession.shared
        let task3 = session3.dataTask(with: urlString3!, completionHandler: getWaitlist)
        task3.resume()
        }
        
    }
    
    @IBOutlet weak var courseidlbl: UILabel!
    var responseDict:NSDictionary=[:]
    var jsonDict:NSDictionary=[:]
    var redIDfromSub = String()
    var pwdfromSub = String()
    var DcourseIDdata = 7034
    var Back = 0
    var SeatFilled = 0
    var courseStatus = String()
    @IBOutlet weak var titlelbl: UILabel!
    @IBOutlet weak var strttimelbl: UILabel!
    @IBOutlet weak var endtimelbl: UILabel!
    @IBOutlet weak var instructorlbl: UILabel!
    @IBOutlet weak var roomlbl: UILabel!
    @IBOutlet weak var enrolledlbl: UILabel!
    @IBOutlet weak var seatslbl: UILabel!
    @IBOutlet weak var desclabel: UITextView!
    var titledata = String()
    var strtdata = String()
    var day = String()
    var enddata = String()
    var instructordata = String()
    var roomdata = String()
    var enroldata = Int()
    var seatdata = Int()
    var descdata = String()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print("DetailViewController-------------------------")
        redIDfromSub =  UserDefaults.standard.string(forKey: "redIDValue")!
        pwdfromSub =   UserDefaults.standard.string(forKey: "pwdValue")!
        print(redIDfromSub)
        print(pwdfromSub)
        print(DcourseIDdata)
        courseidlbl.text = String(DcourseIDdata)
        if courseStatus != "" {
            setAlert(title: "Status", message: courseStatus)
        }
        
        /////////////////////////////////////////////////////////////////////////////getting course details
        var urlComponentDetils = URLComponents(string: "https://bismarck.sdsu.edu/registration/classdetails")!
        urlComponentDetils.queryItems = [
            URLQueryItem(name: "classid", value: String(DcourseIDdata))
         
        ]
        let urlString = urlComponentDetils.url
        let session = URLSession.shared
        let task = session.dataTask(with: urlString!, completionHandler: getCourseData)
        task.resume()
        
        
        // Do any additional setup after loading the view.
    }
    func getCourseData(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            do{
                let json:Any = try JSONSerialization.jsonObject(with: data!)
                self.jsonDict = json as! NSDictionary
            }catch{
                print("ArrayError")
            }
        }
        performSelector(onMainThread:#selector(setclass)  , with: jsonDict, waitUntilDone: true)
    }
    @objc func setclass(jsonDict:NSDictionary)      //func to get data from getWebpage
    {
        print("getting details")
       
        
 
        let enrol = jsonDict["enrolled"] as! Int
        let seat = jsonDict["seats"] as! Int
        if enrol == seat {
            SeatFilled = 1
        }


        
        if jsonDict["fullTitle"] != nil {
             titledata = jsonDict["fullTitle"] as! String
        }else{
             titledata = jsonDict["title"] as! String
        }
        titlelbl.text = titledata
        
        
        if jsonDict["days"] == nil{
            day = "--"
        }else{
            day = jsonDict["days"] as! String
        }
        
        if jsonDict["startTime"] == nil{
        strtdata = "--"
        }else{
            strtdata = jsonDict["startTime"] as! String
        }
        if strtdata == ""{
            strttimelbl.text = "--"
        }else{
        strttimelbl.text = strtdata + " " + day
        }
        
        
        if jsonDict["endTime"] == nil{
           enddata = "--"
        }else{
            enddata = jsonDict["endTime"] as! String
        }
        if enddata == ""{
            endtimelbl.text = "--"
        }else{
            endtimelbl.text = enddata
        }
        
        
        
        if jsonDict["instructor"] == nil {
             instructordata = "--"
        }else{
             instructordata = jsonDict["instructor"] as! String
        }
        instructorlbl.text = instructordata
        if jsonDict["room"] == nil{
           roomdata = "----"
        }else{
        roomdata = jsonDict["room"] as! String
        }
        roomlbl.text = roomdata
        if jsonDict["enrolled"] == nil {
            enroldata = 00
        }else{
        enroldata = jsonDict["enrolled"] as! Int
        }
        enrolledlbl.text = String(enroldata)
        if jsonDict["seats"] == nil {
          seatdata = 00
        }else{
        seatdata = jsonDict["seats"] as! Int
        }
        seatslbl.text = String(seatdata)
        if jsonDict["description"] == nil{ descdata = "Contact Professor for Course Details"
        }else{
        descdata = jsonDict["description"] as! String
        }
        desclabel.text =  descdata
        
        
        
        
        
        
        
        
        
        
        
        
        
    }
    func getWebPage(data:Data?, response:URLResponse?, error:Error?) -> Void {//////////////////////////////////////////////////////add course
            guard error == nil else {
                print("error: \(error!.localizedDescription)")
                return
            }
            if data != nil {
             DispatchQueue.main.async {
                do{
                    let course = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                    self.responseDict = course as NSDictionary
                    let keys=Array(self.responseDict.allKeys)
                    for item in keys{
                        if((item as? String)=="error"){
                            print(self.responseDict["error"] as Any)
                            self.setAlert(title: "Error", message: self.responseDict["error"] as! String)
                        }else{ print(self.responseDict["ok"] as Any)
                            self.setAlert(title: "Success", message: self.responseDict["ok"] as! String)
                        }
                    }
                    
                } catch { print("No response Error")
                }}
            } else { print("unable to convert data to text")
            }
        }

    ///////////////////////////////////////////////////////////////////////////add waitlist
    func getWaitlist(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            DispatchQueue.main.async {
            do{
                let course = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                self.responseDict = course as NSDictionary
                let keys=Array(self.responseDict.allKeys)
                for item in keys{
                    if((item as? String)=="error"){
                        print(self.responseDict["error"] as Any)
                        self.courseStatus = self.responseDict["error"] as! String
                        self.setAlert(title: "Sorry :(", message: self.responseDict["error"] as! String)
                    }else{ print(self.responseDict["ok"] as Any)
                        self.setAlert(title: "Success", message: "You are In Waitlist, you will be notified once you are added to this course")
                        self.courseStatus = self.responseDict["ok"] as! String
                    }
                }
                
            } catch { print("No response Error")
            }
          
            } } else { print("unable to convert data to text")
        }
        }
  
    
    func setAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title: "OK", style: .default, handler: { (action) in
            alert.dismiss(animated: true, completion : nil)
        }))
        self.present(alert, animated:true, completion:nil)
    }
}

