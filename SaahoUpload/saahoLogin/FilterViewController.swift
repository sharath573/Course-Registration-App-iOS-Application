//
//  FilterViewController.swift
//  saahoLogin
//
//  Created by Sharath on 11/12/18.
//  Copyright © 2018 Sharath. All rights reserved.
//

import UIKit

class FilterViewController: UIViewController
, UIPickerViewDataSource, UIPickerViewDelegate
{
    ////////////////////////////////////////////////////////////////////////////pickerview
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return courseDublicateArray.count
    }
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return courseDublicateArray[row] }
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        label.text = self.courseDublicateArray[row]
        courseName = self.courseDublicateArray[row]
        courseID = Int(courseIDArray[row])
        print(courseID)
        self.pickerviewView.isHidden = true
        
    }
    /////////////////slider and time
    
    @IBAction func portalBtn(_ sender: Any) {
        Back = 1
    }
    @IBOutlet weak var levelSliderOutlet: UISegmentedControl!
    @IBOutlet weak var minsliderOutlet: UISegmentedControl!
    @IBOutlet weak var Slider: UISlider!
    @IBAction func timeSlider(_ sender: Any) {
        let hourData = roundf((sender as AnyObject).value)
        let hourIntData = Int(hourData)
        hour = String(format: "%02d", hourIntData)
        timeLabel.text = hour+":"+min
         time = hour+min
    }
    
    @IBAction func minSlider(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
            min = "00"
            timeLabel.text = hour+":"+min
            time = hour+min
        }
        else{
            min = "30"
            timeLabel.text = hour+":"+min
             time = hour+min
        }
    }
    
    @IBAction func levelSlider(_ sender: Any) {
        if (sender as AnyObject).selectedSegmentIndex == 0 {
           levelData = "lower"
        }
        else if (sender as AnyObject).selectedSegmentIndex == 1 {
            levelData = "upper"
        }
        else{
            levelData = "graduate"
        }
    }
    
    @IBOutlet weak var custompicker: UIPickerView!
    @IBOutlet weak var pickerviewView: UIView!
    ///////////////////////////////////////////////////////////////////////// button in the view just to select course
    @IBAction func CourseBtn(_ sender: Any) {
        self.pickerviewView.isHidden = false
        courseDublicateArray=titleArray
        courseIDArray = idArray
        custompicker.dataSource = self
        custompicker.delegate = self
    }
    
    @IBOutlet weak var donetimeBtn: UIButton!
    @IBOutlet weak var hourV: UILabel!
    @IBOutlet weak var minV: UILabel!
    @IBAction func SelectLevelBtn(_ sender: Any) { // Done Button 
        self.donetimeBtn.isHidden = true
        self.hourV.isHidden = true
        self.minV.isHidden = true
        self.minsliderOutlet.isHidden = true
        self.Slider.isHidden = true
    }
    
    @IBAction func SelectTimeBtn(_ sender: Any) {
        self.hourV.isHidden = false
        self.minV.isHidden = false
        self.minsliderOutlet.isHidden = false
        self.Slider.isHidden = false
        self.donetimeBtn.isHidden = false
    }
    
    
    
    
    
    
    
    
    /////////////////////////////////////////////////////////////////check button , take this to the next view controller
    @IBAction func CheckBtn(_ sender: Any) {
        if courseName == ""{
            setAlert(title: "Oh!", message: "Please select your Department")
        }
        else{
        //self.levelSliderOutlet.isHidden = true
        //label.text = String(courseID)
         print(time)
        print(levelData)
        var urlComponents = URLComponents(string: "https://bismarck.sdsu.edu/registration/classidslist")!
        urlComponents.queryItems = [
            URLQueryItem(name: "subjectid", value: String(courseID)),
            URLQueryItem(name: "level", value: String(levelData)),
            URLQueryItem(name: "starttime", value: String(time))
        ]
            let urlString = urlComponents.url
        //print(urlString)

            let session2 = URLSession.shared
        let task2 = session2.dataTask(with: urlString!, completionHandler: getWebPage2)
            task2.resume()
        }}
    ////////////////////////////////////////////////////////////////////////////////////////////uilabel values
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    
    var courseName = ""// name of the selected course from pickerwiew
    var courseID:Int=0
    var hour = "00"
    var min = "00"
    var time = ""
    var levelData = ""
    var classArray = [Int]()
    var idArray = [Int]()
    var titleArray = [String]()
    var jsonArray:NSArray=[]
    var courseArray:NSArray=[]
    var courseDublicateArray = [String]()
    var courseIDArray = [Int]()
    var redIDfromMainViewC = String()
    var pwdSegueFrmViewC = String()
    var jsonDict:NSDictionary=[:]
    var Back = Int()
    //////////////////////////////////////////////////////////////////////////////////////////////viewDidLoad
    override func viewDidLoad() {
        super.viewDidLoad()
        Back = 0
        print("FilterViewController-------------------------")
        redIDfromMainViewC = UserDefaults.standard.string(forKey: "redIDValue")!
        pwdSegueFrmViewC =  UserDefaults.standard.string(forKey: "pwdValue")!
       print(redIDfromMainViewC)
        print(pwdSegueFrmViewC)
        self.pickerviewView.isHidden = true
        self.donetimeBtn.isHidden = true
        self.hourV.isHidden = true
        self.minV.isHidden = true
        self.minsliderOutlet.isHidden = true
        self.Slider.isHidden = true
        
        if let url = URL(string: "https://bismarck.sdsu.edu/registration/subjectlist") {
            let session = URLSession.shared
            let task = session.dataTask(with: url, completionHandler: getWebPage)
            task.resume()
        }
        else {
            print("Unable to create URL")
        }
      
    }
    func getWebPage(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            do{
                let json:Any = try JSONSerialization.jsonObject(with: data!)
                self.jsonArray = json as! NSArray
            }catch{
                print("ArrayError")
            }
        }
        performSelector(onMainThread:#selector(setDetails)  , with: jsonArray, waitUntilDone: true)
    }
    @objc func setDetails(array:NSArray)      //func to get data from getWebpage
    {
         print("Subject list is working")
        
        for sub in jsonArray {
            let jsonDictionary = sub as! NSDictionary //converting each value of array into a dictionary
            let classData = jsonDictionary["classes"]
            classArray.append(classData as! Int)
            let idData = jsonDictionary["id"]
            idArray.append(idData as! Int)
            let titleData = jsonDictionary["title"]
            titleArray.append(titleData as! String)
            }

    }
 ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////courses
    func getWebPage2(data:Data?, response:URLResponse?, error:Error?) -> Void {
        guard error == nil else {
            print("error: \(error!.localizedDescription)")
            return
        }
        if data != nil {
            do{
                let course:Any = try JSONSerialization.jsonObject(with: data!)
                self.courseArray = course as! NSArray
                
            } catch { print("Courses list ERROR")
            }
            performSelector(onMainThread:#selector(setcourse)  , with: courseArray , waitUntilDone: true)
        } else {
            print("unable to convert data to text")
        }
    }
    @objc func setcourse( courseSubArray:NSArray)      //func to get data from getWebpage2 for courselist array
    {
        print("course list is working")
        //print(courseArray)
        
         performSegue(withIdentifier: "courseList", sender: self)
       // samplefunction()
    }
    
    func samplefunction(){
        print(courseArray.count)
        for val in courseArray{
          //  print(classArray[val])
        print("Sample function") // course name kosam
        var urlgetname = URLComponents(string: "https://bismarck.sdsu.edu/registration/classdetails?")!
        urlgetname.queryItems = [
            URLQueryItem(name: "classid", value: String(val as! Int))

        ]
            
        let urlStringget = urlgetname.url
            print(urlStringget)
        let sessions = URLSession.shared
        let tasks = sessions.dataTask(with: urlStringget!, completionHandler: getcourseDetails)
        tasks.resume()
        }}
     /////////////////////////////////////////////sample function get function
    func getcourseDetails(data:Data?, response:URLResponse?, error:Error?) -> Void {
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
        let enrol = jsonDict["fullTitle"]
        print(enrol as Any)
        
        
    }
        
        
        
        
        
        
    
    func setAlert(title:String, message:String)
    {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.default, handler: { (action) in
            alert.dismiss(animated: true, completion : nil)
        }))
        self.present(alert, animated:true, completion:nil)
    }
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if Back == 0 {
            if  courseArray.count != 0 {
                var courseID = segue.destination as! SubjectViewController
                courseID.courseSegueArray = courseArray as! [Int]

            }
        }}

}

