//
//  ViewController.swift
//  FitnessApp
//
//  Created by Abhishek Bhandari on 25/07/18.
//  Copyright © 2018 AbhishekBhandari. All rights reserved.
//

import UIKit
import HealthKit
import Alamofire 
import SwiftyJSON
import UserNotifications
import SpriteKit
class ViewController: UIViewController {
    let healthStore = HKHealthStore()
   
    override func viewDidAppear(_ animated: Bool) {
        print("check1")
       // fadeViewOutThenIn(view: fitnessImage, delay: 2)
        Passcode.layer.borderColor = UIColor.black.cgColor
        let testAuth1 = UserDefaults.standard.string(forKey: "ID")
        let testAuth2 = UserDefaults.standard.string(forKey: "IDFlag")
        if(testAuth1! == "1" && testAuth2! == "1" ){
            print("check2")
            performSegue(withIdentifier: "goToSecondScreen", sender: self)
        }
        ButtonArray[0].isHidden = true
// ButtonArray[2].isHidden = false
//        if testAuth1! == "1" {
//             ButtonArray[2].isHidden = true
//        }
    }
//
    override func viewDidLoad() {
        super.viewDidLoad()
        self.errorReporting.isHidden = true
        //assignbackground()
        authorizeHealthKitAccess()
        self.ButtonArray[0].isHidden = true
        let testAuth1 = UserDefaults.standard.string(forKey: "ID")
        let testAuth2 = UserDefaults.standard.string(forKey: "IDFlag")
        print(testAuth2!)
        print(testAuth1!)
        self.Passcode.isHidden = false;
        if(testAuth1! == "1" && testAuth2! == "1" ){
            self.ButtonArray[1].isHidden = true;
           // self.ButtonArray[2].isHidden = true;
            self.Passcode.isHidden = true
            print("This code ran")
        }
//        if(testAuth1! == "1"){
//            self.ButtonArray[2].isHidden = true;
//            self.errorReporting.numberOfLines = 3
//            self.errorReporting.textColor = UIColor.blue
//            self.errorReporting.text = "Authorization successful"
//            self.errorReporting.sizeToFit()
//            self.errorReporting.isHidden = false
//        }
        
        // Do any additional setup after loading the view, typically from a nib.
        let content = UNMutableNotificationContent()
        content.title = "Reminder"
        content.body = "Click on 'send data' and Update your steps data (note: for consistency and comparison's sake, everyone's data will be of the previous day "
        content.sound = UNNotificationSound.default()
//        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 8*60*60, repeats: true)
        var date = DateComponents()
        date.hour = 10
        date.minute = 00
        let trigger = UNCalendarNotificationTrigger(dateMatching: date, repeats: true)
        let request = UNNotificationRequest(identifier: "TestIdentifier", content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: nil)
    }
    func fadeViewOutThenIn(view : UIView, delay: TimeInterval) {
        // self.TodaysStepsLabel.isHidden = true
        let animationDuration = 5
        
        // Fade in the view
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { () -> Void in
            view.alpha = 0
            //self.TodaysStepsLabel.alpha = 0
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: delay, options: .curveEaseOut , animations: { () -> Void in
                view.alpha = 1
              //  self.TodaysStepsLabel.alpha = 1
            }, completion: nil)
            //self.TodaysStepsLabel.isHidden = false
        }
    }
    
    @IBOutlet weak var fitnessImage: UIImageView!
    // @IBOutlet weak var Hidefunction: UILabel!
   // let _id = "5b61f99c37475b96a220f745"
    
   // var identifierForVendor = NSUUID().uuidString
   // var name = UIDevice.current.name
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
//    func assignbackground(){
//        let background = UIImage(named: "Image")
//
//        var imageView : UIImageView!
//        imageView = UIImageView(frame: view.bounds)
//        imageView.contentMode =  UIViewContentMode.scaleAspectFill
//        imageView.clipsToBounds = true
//        imageView.image = background
//        imageView.center = view.center
//        view.addSubview(imageView)
//        self.view.sendSubview(toBack: imageView)
//
////        let visualEffectView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
////        visualEffectView.frame = imageView.bounds
////        imageView.addSubview(visualEffectView)
//
//   }
    
    @IBOutlet var ButtonArray: [UIButton]!
    //Invisible holder. Won't be seen at run-time. It is used to control all action buttons
    
    @IBOutlet weak var errorReporting: UILabel!
    @IBOutlet weak var Passcode: UITextField!
        //Username placeholder box
    @IBAction func storeUserName(_ sender: Any) {
        //submit button
        view.endEditing(true)
        print("non-functional")
        let x = Passcode.text
        // print(x)

        let url = URL(string: "https://api.mlab.com/api/1/databases/fitness_app/collections/fitness?apiKey=FQ823N84cKWWiUJExg_UZvM_GEuJRL-F")
       // let postingURL = URLEncoding.queryString
        Alamofire.request(url!, method: .get, parameters: ["q":"{'username':'\(x!)'}"]).responseJSON{
            response in switch response.result {
            case .success:
                print(response)
            //            let json = JSON(["_id" : "123"])
                var json = JSON(response.result.value!)
                print(json[0]["_id"]["$oid"])
                let MongoID = json[0]["_id"]["$oid"]
                if(MongoID == JSON.null){
                    self.errorReporting.numberOfLines = 3
                    self.errorReporting.textColor = UIColor.red
                    self.errorReporting.text = "Username invalid. Try again"
                    self.errorReporting.sizeToFit()
                    self.errorReporting.isHidden = false
                }else{
                    
                    self.errorReporting.numberOfLines = 3
                    self.errorReporting.text = "Username accepted and saved. Sending your steps data..."
                    self.errorReporting.sizeToFit()
                    self.errorReporting.isHidden = false
                    print("MongoID" + "\(String(describing: MongoID))")
                    let _id = UserDefaults.standard
                    _id.set("\(String(describing: MongoID))", forKey: "IDMongo")
                    _id.synchronize()
                    let idValue = _id.string(forKey: "IDMongo")
                    print(idValue!)
                    
                    let name = UserDefaults.standard
                    let nameVal1 = json[0]["firstname"]
                    let nameVal2 = json[0]["lastname"]
                    name.set("\(String(describing: nameVal1))" + " " + "\(String(describing: nameVal2))", forKey: "IDname")
                    name.synchronize()
                    let Flag = UserDefaults.standard
                    Flag.set("1", forKey: "IDFlag")
                    Flag.synchronize()
                    self.ButtonArray[1].isHidden = true
                   // self.ButtonArray[2].isHidden = true
                    self.Passcode.isHidden = true
                    let testAuth1 = UserDefaults.standard.string(forKey: "ID")
                    print(testAuth1!)
                    let testAuth2 = UserDefaults.standard.string(forKey: "IDFlag")
                    print(testAuth2!)
                    if((testAuth1! == "1")&&(testAuth2! == "1")){
                        self.performSegue(withIdentifier: "goToSecondScreen", sender: self)
                    }
                }
            case .failure(let error):
                print(error)
            }
        }
        //Hidefunction.isHidden = false;
     print("jumped to end")
    }
    
//    func json(from object:Any) -> String? {
//        guard let data = try? JSONSerialization.data(withJSONObject: object, options: []) else {
//            return nil
//        }
//        return String(data: data, encoding: String.Encoding.utf8)
//    }
    func authorizeHealthKitAccess(){
        let healthKitTypes: Set = [
            // access step count
            HKObjectType.quantityType(forIdentifier: HKQuantityTypeIdentifier.stepCount)!
        ]
        
        healthStore.requestAuthorization(toShare: healthKitTypes, read: healthKitTypes) { (bool, error) in
            print(bool)
        
            if let e = error {
                print("oops something went wrong during authorisation \(e.localizedDescription)")
                
            } else {
                print("User has completed the authorization flow")
                if(bool == true){
                    UserDefaults.standard.set("1", forKey: "ID")
                    UserDefaults.standard.synchronize()
                }
            }
        }
       // self.ButtonArray[2].isHidden = true
    }
//    @IBAction func authorizeHealthKitAccess(_ sender: Any) {
//        //authorize healthkit button
//  //      self.errorReporting.numberOfLines = 5
//        authorizeHealthKitAccess()
//       // self.ButtonArray[2].isHidden = true
//    }

    @IBAction func registerOnWebsite(_ sender: Any) {
        if let url = URL(string: "http://localhost:8080/register") {
            UIApplication.shared.open(url, options: [:])
//            http://localhost:8080/register
//            https://www.infogain.com
        }
    }
}
