//
//  SubjectViewController.swift
//  saahoLogin
//
//  Created by Sharath on 11/19/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import UIKit

class SubjectViewController: UIViewController {

    @IBAction func BackBtnSubject(_ sender: Any) {
        Back = 1
    }
    @IBOutlet weak var tableView: UITableView!
var redIDfromFilter = String()
var pwdfromFilter = String()
var courseSegueArray = [Int]()
var vc = 0
var Back = Int()
    var jsonDict:NSDictionary=[:]
    var courseName = String()
    var detailDict:NSDictionary=[:]
    var nameArray:NSArray=[]
    var  CourseNameArray = [String]()
    var viewFinalData = String()
    
    @IBOutlet weak var asd: UILabel!
    
    
    
    
    override func viewDidLoad() {
        Back = 0
        super.viewDidLoad()
        print("SubjectViewController-------------------------")
        redIDfromFilter =  UserDefaults.standard.string(forKey: "redIDValue")!
        pwdfromFilter =   UserDefaults.standard.string(forKey: "pwdValue")!
        print(redIDfromFilter)
        print(pwdfromFilter)
        self.asd.isHidden = true
        if courseSegueArray.count != 0 {
        print("Success - Segue data to Subject View Controller")
        }else{ print("Fail - Segue data to Subject View Controller")
            self.tableView.isHidden = true
            self.asd.isHidden = false
        }
        //////////////////////////////////////////////////////////////////////
        if courseSegueArray.count != 0 {
        let dict:[String: [Int]] = ["classids":courseSegueArray]
        //print(courseSegueArray)
        //postdata
        do {
            let json=try JSONSerialization.data(withJSONObject: dict, options: .prettyPrinted)
            if let url = URL(string: "https://bismarck.sdsu.edu/registration/classdetails")
            
            {
                var mutableRequest = URLRequest.init(url: url)
                mutableRequest.httpMethod = "POST"
                mutableRequest.setValue("application/json",
                                        forHTTPHeaderField: "Content-Type")
                let session = URLSession.shared
                let task = session.uploadTask(with: mutableRequest,
                                              from: json,
                                              completionHandler: getCourseName2)
                task.resume()
            } else { print("Unable to create URL") }
        }catch{ print(error) }}
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Back == 0 {
        let courseID = segue.destination as! DetailViewController
            courseID.DcourseIDdata =  vc
        }
    }
    func getCourseName2(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
          
                do{
                    let json:Any = try JSONSerialization.jsonObject(with: data!)
                    nameArray = json as! NSArray
                    print(nameArray)
                }catch{
                    print("ArrayError")
                }}
         performSelector(onMainThread:#selector(getname)  , with: nameArray, waitUntilDone: true)
    }
    @objc func getname(namearray2:NSArray)      //func to get data from getWebpage
    {
        print("Subject list is working")
        
        for sub in nameArray {
            let jsonDictionary = sub as! NSDictionary //converting each value of array into a dictionary
            let classname = jsonDictionary["title"]
            CourseNameArray.append(classname as! String)
           //print(CourseNameArray.count)
            if courseSegueArray.count == CourseNameArray.count {
                self.tableView.reloadData()
            }}}}
extension SubjectViewController: UITableViewDelegate, UITableViewDataSource{

    func tableView(_ tableView: UITableView, numberOfRowsInSection indexPath: Int)-> Int {
        return courseSegueArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)


        if CourseNameArray.count != 0{
            viewFinalData = String(courseSegueArray[indexPath.row] ) + " " + String(CourseNameArray[indexPath.row] )
          print("Names")
            print(CourseNameArray[indexPath.row])
        }
        else{
            print("No names")
            viewFinalData = String(courseSegueArray[indexPath.row] )
        }
        cell.textLabel?.text = viewFinalData
      
        return cell
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        vc  = courseSegueArray[indexPath.row]
        performSegue(withIdentifier: "courseID", sender: self)
        
    }
}
