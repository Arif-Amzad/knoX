//
//  RegisterViewController.swift
//  knoX
//
//  Created by Arif Amzad on 3/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase

class RegisterViewController: UIViewController {

    let userDefaults = UserDefaults.standard
    

    @IBOutlet weak var notice: UILabel!
    
    @IBOutlet weak var startVerificationOutlet: UIButton!
    @IBOutlet weak var TextFieldPhone: UITextField!
    
    @IBAction func ButtonStartVerification(_ sender: Any) {
        
        guard let phoneNumber = TextFieldPhone.text else { return }
        
        PhoneAuthProvider.provider().verifyPhoneNumber(phoneNumber, uiDelegate: nil) { (verificaitonId, error) in
            
            //self.startVerificationOutlet.isHidden = true
            //self.notice.isHidden = true
            //self.TextFieldPhone.isHidden = true
            
            if error == nil {
                
                //self.ButtonVerifyOutlet.isHidden = false
                //self.TextFieldOTP.isHidden = false
                
                print("Verification ID is_____---------------------------------------------------------\(verificaitonId ?? "This is verification ID"))")
                
                guard let verifyId = verificaitonId else { return }
                
                self.userDefaults.set(verifyId, forKey: "verificationId")
                self.userDefaults.synchronize()
                
                self.performSegue(withIdentifier: "goToVerify", sender: self)
                
                self.TextFieldPhone.isHidden = true
                self.startVerificationOutlet.isHidden = true
                self.notice.isHidden = true
            
            }
            else {
                
                print("Unable to get secret verificaiton from firebase \(String(describing: error))")
                //self.startVerificationOutlet.isHidden = true
                //self.notice.isHidden = true
                //self.TextFieldPhone.isHidden = true
            }
        }
        
        
    }
    
    

    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    

    
    
    
    
    
    
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
