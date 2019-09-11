//
//  ViewController.swift
//  knoX
//
//  Created by Arif Amzad on 2/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

class WelcomeViewController: UIViewController {
    
    
    @IBAction func ButtonRegister(_ sender: Any) {
        
        //if self.navigationController.visibleViewController == self {
            //self performSegueWithIdentifier:@"thankyou" sender:self
        //}
        
        performSegue(withIdentifier: "goToStartVerification", sender: self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}


