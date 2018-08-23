//
//  SecondViewController.swift
//  FitnessApp
//
//  Created by Abhishek Bhandari on 05/08/18.
//  Copyright © 2018 AbhishekBhandari. All rights reserved.
//

import UIKit
import HealthKit
import Alamofire
import SwiftyJSON
import UserNotifications
import SwiftGifOrigin 

class SecondViewController: UIViewController {
    let healthStore = HKHealthStore()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.TodaysStepsLabel.isHidden = true
        self.stepsLabel.isHidden = true
        self.dataSentLabel.isHidden = true
        //self.manualSendLabel.isHidden = true
        self.ButtonArray[1].isHidden = true
        self.WorkoutLabel.isHidden = true
//        sendStepdata(x: 0)
//        getTodaysSteps()
        ButtonArray[0].isHidden = true
        // Do any additional setup after loading the view.
        //assignbackground()
        ButtonArray[1].layer.cornerRadius = 20
        ButtonArray[1].layer.borderWidth = 2
        ButtonArray[1].layer.borderColor = UIColor.gray.cgColor
        ButtonArray[1].tintColor = UIColor.blue
        ButtonArray[1].showsTouchWhenHighlighted = true
        //runningImage.image = UIImage(named: "Image-3")
    }

    @IBOutlet weak var fitnessImage: UIImageView!
    @IBOutlet weak var fitnessGif: UIImageView!
    override func viewDidAppear(_ animated: Bool) {
        sendStepdata(x: 0)
        getTodaysSteps()
        self.dataSentLabel.text = "Sending Data..."
        self.TodaysStepsLabel.isHidden = true
//    fadeViewOutThenIn(view : fitnessImage, delay: 2)
//        UpperfadeViewOutThenIn(view1 : SimpsonImage1, view2 : SimpsonImage3, delay: 1)
      appearLate(delay: 4)
    }
    @IBOutlet var ButtonArray: [UIButton]!
    @IBAction func manuallySendSteps(_ sender: UIButton) {
        sendStepdata(x: 1)
        //let button = sender

    }
    @IBOutlet weak var WorkoutLabel: UILabel!
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
//    }
    func appearLate(delay: TimeInterval){
        self.TodaysStepsLabel.isHidden = true
        self.stepsLabel.isHidden = true
        self.dataSentLabel.isHidden = true
       // self.manualSendLabel.isHidden = true
        self.ButtonArray[1].isHidden = true
//        let gif = UIImage.gif(url: "https://www.google.com/url?sa=i&source=images&cd=&cad=rja&uact=8&ved=2ahUKEwjhqZ-_t_zcAhWGJ3wKHSJBD-kQjRx6BAgBEAU&url=https%3A%2F%2Fwww.verywellfit.com%2Frunning-4157127&psig=AOvVaw1sPVNb4wqUYVOVEGIwypkS&ust=1534882088102777")
        
        DispatchQueue.main.asyncAfter(deadline: .now() + delay) {
            self.TodaysStepsLabel.isHidden = false
            self.WorkoutLabel.isHidden = false

        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
            self.stepsLabel.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
           self.dataSentLabel.isHidden = false
        }
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
           // self.manualSendLabel.isHidden = false
            self.ButtonArray[1].isHidden = false
            //self.fitnessGif.image = gif
            self.fitnessImage.isHidden = true
            self.fitnessGif.loadGif(name: "Running")
        }
    }
    func fadeViewOutThenIn(view : UIView, delay: TimeInterval) {
       // self.TodaysStepsLabel.isHidden = true
        let animationDuration = 1
        
        // Fade in the view
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { () -> Void in
            view.alpha = 0
            //self.TodaysStepsLabel.alpha = 0
        }) { (Bool) -> Void in
            
            // After the animation completes, fade out the view after a delay
            
            UIView.animate(withDuration: TimeInterval(animationDuration), delay: delay, options: .curveEaseOut , animations: { () -> Void in
                view.alpha = 1
                 //self.TodaysStepsLabel.alpha = 1
            }, completion: nil)
            //self.TodaysStepsLabel.isHidden = false
        }
    }
    func UpperfadeViewOutThenIn(view1 : UIView, view2 : UIView, delay: TimeInterval) {
        // self.TodaysStepsLabel.isHidden = true
        let animationDuration = 3
        
        // Fade in the view
        UIView.animate(withDuration: TimeInterval(animationDuration), animations: { () -> Void in
            view1.alpha = 0
            //self.TodaysStepsLabel.alpha = 0
        }) { (Bool) -> Void in
            UIView.animate(withDuration: TimeInterval(animationDuration), animations: { () -> Void in
                view2.alpha = 0
                //self.TodaysStepsLabel.alpha = 0
            }) { (Bool) -> Void in
            // After the animation completes, fade out the view after a delay
            
                    UIView.animate(withDuration: TimeInterval(animationDuration), delay: delay, options: .curveEaseOut , animations: { () -> Void in
                        view2.alpha = 1
                        //self.TodaysStepsLabel.alpha = 1
                    }, completion: nil)
            }
            //self.TodaysStepsLabel.isHidden = false
        }
    }
    func getYesterdaysSteps(completion: @escaping (Double) -> Void) {
        
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)
        //let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let exactlyOneDayAgo = Calendar.current.date(byAdding: DateComponents(day: -1), to: now)!
        let startOfOneDayAgo = Calendar.current.startOfDay(for: exactlyOneDayAgo)
        let predicate = HKQuery.predicateForSamples(withStart: startOfOneDayAgo, end: startOfDay, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }

    @IBOutlet weak var dataSentLabel: UILabel!
    
    func sendStepdata( x : Int){
        getYesterdaysSteps { (result) in
            print("\(result)")
            DispatchQueue.main.async {
                self.stepsLabel.numberOfLines = 2
                self.stepsLabel.text = "Yesterday's steps : \(result)"
                self.stepsLabel.textColor = UIColor.black
                self.stepsLabel.sizeToFit()
            }
            let _id = UserDefaults.standard
            print(_id)
            let idValue = _id.string(forKey: "IDMongo")
            print(idValue!)
            let Name = UserDefaults.standard
            let name = Name.string(forKey: "IDname")
            let param1 = ["$set" : ["Name" : name!, "Steps" : Int(result)]]
            print(param1)
            let header = [
                "Content-Type": "application/json",
            ]
            Alamofire.request("https://api.mlab.com/api/1/databases/fitness_app/collections/fitness/\(String(describing: idValue!))?apiKey=FQ823N84cKWWiUJExg_UZvM_GEuJRL-F", method: .put , parameters: param1, encoding : JSONEncoding.default, headers: header ).responseJSON {(response) in
                switch response.result {
                case .success:
                    print(response)
                    if x == 0 {
                       // print("ccccc!!!!!")
                        self.dataSentLabel.numberOfLines = 4
                        self.dataSentLabel.text = "successfully sent"
                        self.dataSentLabel.sizeToFit()
                        self.dataSentLabel.textColor = UIColor.black
                    } else if x == 1 {
                       // print("dddddd!!!!!")
                        self.dataSentLabel.numberOfLines = 4
                        self.dataSentLabel.text = "Step Data manually sent!"
                        self.dataSentLabel.sizeToFit()
                        self.dataSentLabel.textColor = UIColor.black
                    }

                case .failure(let error):
                    print(error)
                }
            }
        }
    }
    
    @IBOutlet weak var stepsLabel: UILabel!

    func getTodaysSteps(completion: @escaping (Double) -> Void) {
        let stepsQuantityType = HKQuantityType.quantityType(forIdentifier: .stepCount)!
        
        
        let now = Date()
        let startOfDay = Calendar.current.startOfDay(for: now)

        let predicate = HKQuery.predicateForSamples(withStart: startOfDay, end: now, options: .strictStartDate)
        
        let query = HKStatisticsQuery(quantityType: stepsQuantityType, quantitySamplePredicate: predicate, options: .cumulativeSum) { (_, result, error) in
            var resultCount = 0.0
            guard let result = result else {
                print("Failed to fetch steps rate")
                completion(resultCount)
                return
            }
            if let sum = result.sumQuantity() {
                resultCount = sum.doubleValue(for: HKUnit.count())
            }
            
            DispatchQueue.main.async {
                completion(resultCount)
            }
        }
        healthStore.execute(query)
    }

    func getTodaysSteps(){
        getTodaysSteps { (result) in
            print("\(result)")
            DispatchQueue.main.async {
                self.TodaysStepsLabel.text = "Today's steps: \(result)"
                self.TodaysStepsLabel.numberOfLines = 3
                self.TodaysStepsLabel.sizeToFit()
                self.TodaysStepsLabel.textColor = UIColor.black
            }
        }
    }
    @IBOutlet weak var TodaysStepsLabel: UILabel!

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */
    
}
