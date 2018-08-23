//
//  ViewController.swift
//  Magic 8 Ball
//
//  Created by Abhishek Bhandari on 19/07/18.
//  Copyright © 2018 AbhishekBhandari. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let ballArray = ["Ball1","Ball2","Ball3","Ball4","Ball5"];
    var randomBallNumber: Int = 0;
    @IBOutlet weak var imageView: UIImageView!
    
    @IBAction func askButtonPressed(_ sender: UIButton) {
        randomBallGenerator();
    }
    
    override func viewDidLoad() {
        super.viewDidLoad();
        randomBallGenerator();
        // Do any additional setup after loading the view, typically from a nib.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    func randomBallGenerator(){
       randomBallNumber = Int(arc4random_uniform(5));
    imageView.image = UIImage(named: ballArray[randomBallNumber]);
    }
    
    override func motionEnded(_ motion: UIEventSubtype, with event: UIEvent?) {
       randomBallGenerator();
    }
}

