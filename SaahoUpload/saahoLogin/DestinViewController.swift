//
//  DestinViewController.swift
//  saahoLogin
//
//  Created by Sharath on 11/22/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import UIKit

class DestinViewController: UIViewController {
    var redIDfromDetail = String()
    var selectedCourseID = Int()
    var pwdfromDetail = String()
    var status = 0
    var jsonDict:NSDictionary=[:]
    var courselist = [Int]()
    var waitlist = [Int]()
    var responseDict: NSDictionary=[:]
    var Back = Int()
    var detailDict:NSDictionary=[:]
    var detailDict1:NSDictionary=[:]
    var titlename = "Nodata"
    var CourseNameArray = [String]()
    var WaitNameArray = [String]()
    @IBAction func logoutbtn(_ sender: Any) {
        Back = 1
    }
    
    
    
    
    @IBAction func deleteBtn(_ sender: Any) {
        
        
        if status == 0{
        var urlcourseDlt = URLComponents(string: "https://bismarck.sdsu.edu/registration/unregisterclass?")!
        urlcourseDlt.queryItems = [
            URLQueryItem(name: "redid", value: String(redIDfromDetail)),
            URLQueryItem(name: "password", value: String(pwdfromDetail)),
            URLQueryItem(name: "courseid", value: String(selectedCourseID))
        ]
        let urlString1 = urlcourseDlt.url
        //print(urlString)
        
        let session1 = URLSession.shared
        let task1 = session1.dataTask(with: urlString1!, completionHandler: getdltcourse)
        task1.resume()
        }
        else{
            var urlwaitDlt = URLComponents(string: "https://bismarck.sdsu.edu/registration/unwaitlistclass?")!
            urlwaitDlt.queryItems = [
                URLQueryItem(name: "redid", value: String(redIDfromDetail)),
                URLQueryItem(name: "password", value: String(pwdfromDetail)),
                URLQueryItem(name: "courseid", value: String(selectedCourseID))
            ]
            let urlString2 = urlwaitDlt.url
            //print(urlString)
            
            let session2 = URLSession.shared
            let task2 = session2.dataTask(with: urlString2!, completionHandler: getdltwait)
            task2.resume()
        }
        self.detailVIew.isHidden = true
      self.tableView.reloadData()
    }
    @IBAction func filterBtn(_ sender: Any) {
    }
    
    @IBOutlet weak var Emptylabel: UILabel!
    @IBAction func DeleteAll(_ sender: Any) {
        
        let alertController = UIAlertController(title: "Warning!", message: "All your courses and waitlists will be unregistered. Still want to continue?", preferredStyle: .actionSheet)
        alertController.addAction(UIAlertAction(title: "Continue", style: .default, handler: self.deleteall))
        alertController.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler : nil))
        self.present(alertController, animated : true, completion: nil)
    }
    func deleteall(alert: UIAlertAction){
        var urlDltAll = URLComponents(string: "https://bismarck.sdsu.edu/registration/resetstudent?")!
        urlDltAll.queryItems = [
            URLQueryItem(name: "redid", value: String(redIDfromDetail)),
            URLQueryItem(name: "password", value: String(pwdfromDetail))
            
        ]
        let urlDltString = urlDltAll.url
        let session4 = URLSession.shared
        let task4 = session4.dataTask(with: urlDltString!, completionHandler: getDeleteAll)
        task4.resume()
        self.detailVIew.isHidden = true
    }
    
    @IBAction func courseWaitlistbtn(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            status = 0
            self.tableView.reloadData()
            if courselist.count == 0 {
                self.tableView.isHidden = true
                self.Emptylabel.isHidden = false
                Emptylabel.text = "No Enrolled classes"
            }
            else{
                self.tableView.isHidden = false
                self.Emptylabel.isHidden = true
            }
            self.detailVIew.isHidden = true
           
        }
        else{
            status = 1
            self.tableView.reloadData()
            if waitlist.count == 0 {
                self.tableView.isHidden = true
                self.Emptylabel.isHidden = false
                Emptylabel.text = "No Waitlist classes"
            }
            else{
                self.tableView.isHidden = false
                self.Emptylabel.isHidden = true
            }
            self.detailVIew.isHidden = true
        
        }
        
    }
    
    
    
    
    
    @IBOutlet weak var detailVIew: UIView!
    
    @IBOutlet weak var courseIDlbl: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    @IBOutlet weak var timeZ: UILabel!
    @IBOutlet weak var roomZ: UILabel!
    @IBOutlet weak var deptZ: UILabel!
    
    @IBOutlet weak var nameZ: UILabel!
    var strttime = "hhmm"
    var endtime = "hhmm"
    var day = "DDD"
    var bldng = "Building"
    var room = "room"
    var dept = "Department"
    var prof = "Mr.X"
    override func viewDidLoad() {
        super.viewDidLoad()
    
        print("DestinViewController-----------------------------------------------")
        Emptylabel.text = "No Enrolled classes"
            self.Emptylabel.isHidden = true
        
        Back = 1
        redIDfromDetail =  UserDefaults.standard.string(forKey: "redIDValue")!
        pwdfromDetail =   UserDefaults.standard.string(forKey: "pwdValue")!
        print(redIDfromDetail)
        print(pwdfromDetail)
        getcoursedetails()
        self.detailVIew.isHidden = true
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
        
        //  print(jsonDict["enrolled"])
        //  print(jsonDict["seats"])
        courselist = (jsonDict["classes"]  as? [Int])!
        waitlist = (jsonDict["waitlist"] as? [Int])!
        reload()
        getcoursename()
        getwaitname()
        
    }
    ///////////////////////////////////////////getting course names
    func getcoursename(){
        for val in courselist{
        var urlCourseDetail = URLComponents(string: "https://bismarck.sdsu.edu/registration/classdetails?")!
        urlCourseDetail.queryItems = [
            URLQueryItem(name: "classid", value: String(val))
            
        ]
        let urlString = urlCourseDetail.url
        let session = URLSession.shared
        let task = session.dataTask(with: urlString!, completionHandler: getCourseName)
        task.resume()
        
        }}
    func getwaitname(){
        for val2 in waitlist{
            var urlCourseDetail = URLComponents(string: "https://bismarck.sdsu.edu/registration/classdetails?")!
            urlCourseDetail.queryItems = [
                URLQueryItem(name: "classid", value: String(val2))
                
            ]
            let urlString = urlCourseDetail.url
            let session = URLSession.shared
            let task = session.dataTask(with: urlString!, completionHandler: getCourseName2)
            task.resume()
            
        }
        
    }
    func getCourseName(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            DispatchQueue.main.async {
                do{
                    let json:Any = try JSONSerialization.jsonObject(with: data!)
                    self.detailDict = json as! NSDictionary
                    //print(self.detailDict["title"] as Any)
                    self.CourseNameArray.append(self.detailDict["title"] as! String)
                    print(self.CourseNameArray)
                    if self.CourseNameArray.count == self.courselist.count{
                        self.tableView.reloadData()
                    }
                }catch{
                    print("ArrayError")
                }
            }
            
        }
        
    }
    func getCourseName2(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            DispatchQueue.main.async {
                do{
                    let json:Any = try JSONSerialization.jsonObject(with: data!)
                    self.detailDict = json as! NSDictionary
                    //print(self.detailDict["title"] as Any)
                    self.WaitNameArray.append(self.detailDict["title"] as! String)
                    print(self.WaitNameArray)
                    if self.WaitNameArray.count == self.waitlist.count{
                        self.tableView.reloadData()
                    }
                    
                }catch{
                    print("ArrayError")
                }
            }
            
        }
        
    }
    func reload(){
    self.tableView.reloadData()
    }
   
    func getdltcourse(data:Data?, response:URLResponse?, error:Error?) -> Void {//////////////////////////////////////////////////////add course
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            do{
                let course = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                responseDict = course as NSDictionary
                
            } catch { print("No response Error")
            }
            performSelector(onMainThread:#selector(setcourse)  , with: responseDict , waitUntilDone: true)
        } else { print("unable to convert data to text")
        }
    }
    @objc func setcourse( responseDict:NSDictionary)
    {
        let keys=Array(responseDict.allKeys)
        for item in keys{
            if((item as? String)=="error"){
                print(responseDict["error"] as Any)
            }else{ print(responseDict["ok"] as Any)
                getcoursedetails()
                reload()
                self.tableView.reloadData()
                print(CourseNameArray)
            }
        }
    }
    func getdltwait(data:Data?, response:URLResponse?, error:Error?) -> Void {//////////////////////////////////////////////////////delete waitlist
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            do{
                let course = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                responseDict = course as NSDictionary
                
            } catch { print("No response Error")
            }
            performSelector(onMainThread:#selector(setwait)  , with: responseDict , waitUntilDone: true)
        } else { print("unable to convert data to text")
        }
    }
    @objc func setwait( responseDict:NSDictionary)
    {
        let keys=Array(responseDict.allKeys)
        for item in keys{
            if((item as? String)=="error"){
                print(responseDict["error"] as Any)
            }else{ print(responseDict["ok"] as Any)
                getcoursedetails()
                reload()
                self.tableView.reloadData()
            }
        }
    }
    func getDeleteAll(data:Data?, response:URLResponse?, error:Error?) -> Void {//////////////////////////////////////////////////////delete all
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            do{
                let course = try JSONSerialization.jsonObject(with: data!) as! [String:AnyObject]
                responseDict = course as NSDictionary
                
            } catch { print("No response Error")
            }
            performSelector(onMainThread:#selector(setDltAll)  , with: responseDict , waitUntilDone: true)
        } else { print("unable to convert data to text")
        }
    }
    @objc func setDltAll( responseDict:NSDictionary)
    {
        let keys=Array(responseDict.allKeys)
        for item in keys{
            if((item as? String)=="error"){
                print(responseDict["error"] as Any)
            }else{ print(responseDict["ok"] as Any)
                getcoursedetails()
                reload()
                self.tableView.isHidden = true
                Emptylabel.text = "Unregistered All courses"
            }
        }
    }
    func getcoursedetails(){
        var urlComponentDetils = URLComponents(string: "https://bismarck.sdsu.edu/registration/studentclasses?")!
        urlComponentDetils.queryItems = [
            URLQueryItem(name: "redid", value: String(redIDfromDetail)),
            URLQueryItem(name: "password", value: String(pwdfromDetail))
            
        ]
        let urlString = urlComponentDetils.url
        let session = URLSession.shared
        let task = session.dataTask(with: urlString!, completionHandler: getCourseData)
        task.resume()
        
    }
    func getCourseActualDetails(data:Data?, response:URLResponse?, error:Error?) -> Void {/////////////get details after selecting id manually
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            do{
                let json:Any = try JSONSerialization.jsonObject(with: data!)
                self.detailDict = json as! NSDictionary
            }catch{
                print("ArrayError")
            }
        }
        performSelector(onMainThread:#selector(setActualclass)  , with: detailDict, waitUntilDone: true)
    }
    @objc func setActualclass(detailDict:NSDictionary)      //func to get data from getWebpage
    {
        print("getting details")
        
       // print(detailDict)
        titlename = detailDict["title"] as! String
        courseIDlbl.text = titlename
//        @IBOutlet weak var timeZ: UILabel!
//        @IBOutlet weak var roomZ: UILabel!
//        @IBOutlet weak var deptZ: UILabel!
//
//        @IBOutlet weak var nameZ: UILabel!
        if detailDict["startTime"] != nil {
         strttime = detailDict["startTime"] as! String
        }
        if detailDict["endTime"] != nil {
        endtime = detailDict["endTime"] as! String
        }
        if detailDict["days"] != nil {
         day = detailDict["days"] as! String
        }
        if detailDict["building"] != nil {
         bldng = detailDict["building"] as! String
        }
        if detailDict["room"] != nil {
         room = detailDict["room"] as! String
        }
        if detailDict["department"] != nil {
         dept = detailDict["department"] as! String
        }
         if detailDict["instructor"] != nil {
         prof = detailDict["instructor"] as! String
        }
        timeZ.text = strttime + " to " + endtime + " on " + day
        roomZ.text = bldng + " " + room
        deptZ.text = dept
        nameZ.text = prof
    }
 
}


extension DestinViewController: UITableViewDelegate, UITableViewDataSource{
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection indexPath: Int)-> Int {
        if status == 1 {
            return waitlist.count
        }
        else{
        return courselist.count
        }
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let coursecell = tableView.dequeueReusableCell(withIdentifier: "coursecell", for: indexPath)
      
        if status == 1{
            if WaitNameArray.count != 0 {
            coursecell.textLabel?.text = String(waitlist[indexPath.row]) + " " + String(WaitNameArray[indexPath.row])
            }else{
                coursecell.textLabel?.text = String(waitlist[indexPath.row])
            }
        } else{
            if CourseNameArray.count != 0 {
            coursecell.textLabel?.text = String(courselist[indexPath.row]) + " " + String(CourseNameArray[indexPath.row])
            }else{
              coursecell.textLabel?.text = String(courselist[indexPath.row])
            }
        }
        return coursecell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if status == 1 {
            
            courseIDlbl.text  = String(waitlist[indexPath.row])
            selectedCourseID = waitlist[indexPath.row]
            print ("selected data")
             print(selectedCourseID)
            self.detailVIew.isHidden = false
            var urlCourseDetail = URLComponents(string: "https://bismarck.sdsu.edu/registration/classdetails")!
            urlCourseDetail.queryItems = [
                URLQueryItem(name: "classid", value: String(waitlist[indexPath.row]))
                
            ]
            let urlString = urlCourseDetail.url
            let session = URLSession.shared
            let task = session.dataTask(with: urlString!, completionHandler: getCourseActualDetails)
            task.resume()
            
        }
        else{
        courseIDlbl.text  = String(courselist[indexPath.row])
            selectedCourseID = courselist[indexPath.row]
            print(selectedCourseID)
            self.detailVIew.isHidden = false
            var urlCourseDetail = URLComponents(string: "https://bismarck.sdsu.edu/registration/classdetails?")!
            urlCourseDetail.queryItems = [
                URLQueryItem(name: "classid", value: String(selectedCourseID))
                
            ]
            let urlString = urlCourseDetail.url
            print(urlString)
            let session = URLSession.shared
            let task = session.dataTask(with: urlString!, completionHandler: getCourseActualDetails)
            task.resume()
        }
    }
}
