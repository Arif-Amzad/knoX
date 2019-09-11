//
//  VerifyViewController.swift
//  knoX
//
//  Created by Arif Amzad on 4/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase
import SVProgressHUD

class VerifyViewController: UIViewController {
    
    let userDefaults = UserDefaults.standard
    
    @IBOutlet weak var OTP: UITextField!
    @IBOutlet weak var verifyButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()

    }
    
    
    @IBAction func ButtonVerify(_ sender: Any) {
        
        
        SVProgressHUD.show()
        
        verifyButton.isHidden = true
        OTP.isHidden = true
        
        guard let otp = OTP.text else {
            return
        }
        
        guard let verificaionId = userDefaults.string(forKey: "verificationId") else {return}
        
        let credential = PhoneAuthProvider.provider().credential(withVerificationID: verificaionId, verificationCode: otp)

        Auth.auth().signIn(with: credential) { (success, error) in
            if error == nil {
                
                print("User successfully signed in")
                
                self.sendDataToDatabase()
                
                //self.changeRootView()
                
                self.performSegue(withIdentifier: "goToChatList", sender: self)
                
            }
            else {
                
                print("Something went wrong\(error?.localizedDescription ?? "error found")")
            }
            
            SVProgressHUD.dismiss()
        }
        
    }
    
    
    
    func sendDataToDatabase() {
        
        var currentUser: String = Auth.auth().currentUser?.phoneNumber ?? "current user phone"
        currentUser = currentUser.replacingOccurrences(of: "+", with: "")
        
        let db = Database.database().reference().child("knox_user")
        
        let dictonary = ["name": "empty"]
        db.child(currentUser).setValue(dictonary) {(error, reference) in
            
            if error == nil {
                
                print("added to knox_users")
            }
            else {
                
                print("error\(String(describing: error))")
            }
        }
        
        
//        db.child(currentUser).child("chat_list").setValue(dictonary) {(error, reference) in
//
//            if error == nil {
//
//                print("added to chat_list")
//            }
//            else {
//
//                print("error\(String(describing: error))")
//            }
//        }
        
        
        db.child(currentUser).child("messages").setValue(dictonary) {(error, reference) in
            
            if error == nil {
                
                print("added to messages")
            }
            else {
                
                print("error\(String(describing: error))")
            }
        }
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    
    
    func changeRootView() {
        
        var window: UIWindow?
        window = UIWindow()
        window?.makeKeyAndVisible()
        
        //window?.rootViewController = UINavigationController(rootViewController: ChatViewController())
        
        //newlyadded end
        
        // switch root view controllers
        let storyboard = UIStoryboard.init(name: "Main", bundle: nil)
        let nav = storyboard.instantiateViewController(withIdentifier: "ChatListViewControllerID")
        
        window?.rootViewController = nav
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
