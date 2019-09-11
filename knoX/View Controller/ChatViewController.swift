//
//  ChatViewController.swift
//  knoX
//
//  Created by Arif Amzad on 3/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase
import ChameleonFramework
import SVProgressHUD
import FirebaseAuth

class ChatViewController: UIViewController, UINavigationBarDelegate, UITableViewDelegate, UITableViewDataSource, UITextFieldDelegate {
    
    var messageArray: [Message] = [Message]()
    
    var token: Int = 0
    
    var currentUser: String = Auth.auth().currentUser?.phoneNumber ?? "current user"
    
    var messageId1: String = "loading"   //addition of two number string 0152132097901784468511
    
    var messageId2: String = "loading"
    
    var tappedUserName: String = "loading"
    
    var topTitle: String = ""
    
    var keyboardHeight: CGFloat = 0.0
    
    var cellId: String = "id"
   
    @IBOutlet weak var heightConstraint: NSLayoutConstraint!
    @IBOutlet weak var messageTextfield: UITextField!
    @IBOutlet weak var messageTableView: UITableView!
    @IBOutlet weak var sendButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = topTitle
        
        messageTableView.delegate = self
        messageTableView.dataSource = self
        messageTextfield.delegate = self
        
        messageTableView.register(CustomMessageCellTableViewCell.self, forCellReuseIdentifier: cellId)
    
        //messageTableView.register(UINib(nibName: "CustomMessageCell", bundle: nil), forCellReuseIdentifier: "customMessageCellXIB")
        
        messageTableView.backgroundColor = UIColor(white: 0.95, alpha: 1)
        messageTableView.separatorStyle = .none
        
        NotificationCenter.default.addObserver(
            self,
            selector: #selector(keyboardWillShow),
            name: UIResponder.keyboardWillShowNotification,
            object: nil
        )
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.tableViewTapped))
        self.messageTableView.addGestureRecognizer(tapGesture)
        
        retrieveMessage()
        
        configureTableView()
    }
    
    
    
    @objc func tableViewTapped() {
        
        messageTextfield.endEditing(true)
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return messageArray.count
    }
    
    //override func viewWillAppear(_ animated: Bool) {
     //   self.navigationController?.navigationBar.isHidden = false
    //}
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! CustomMessageCellTableViewCell
        
        cell.messageBody.text = messageArray[indexPath.row].messageBody
        cell.sender.text = messageArray[indexPath.row].sender
        
        cell.messageBody.numberOfLines = 0
        
        if cell.sender.text == currentUser  {

            //cell.avatar.backgroundColor = UIColor.flatPurple()
            //cell.messageBody.backgroundColor = UIColor.flatPurple()
            
            cell.bubbleBackgroundView.backgroundColor = UIColor.init(hexString: "4F4F83")  // 7F4F83
            cell.messageBody.textColor = .white
            
            cell.leadingConstraint.isActive = false
            cell.trailingConstraint.isActive = true
            //cell.messageBody.textAlignment = .right
            cell.backgroundColor = .clear
            
            //print(messageArray[indexPath.row].sender)
            //print(cell.messageBody.text)
        }
        else {
            //cell.avatar.backgroundColor = UIColor.flatWatermelon()
            //cell.messageBody.backgroundColor = UIColor.flatGray()
            cell.leadingConstraint.isActive = true
            cell.trailingConstraint.isActive = false
            print(messageArray[indexPath.row].sender)
        }

        return cell
    }
    
    
    
    func configureTableView() {
        
//        let adjustForTabbarInsets: UIEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: self.tabBarController!.tabBar.frame.height, right: 0)
//        self.messageTableView.contentInset = adjustForTabbarInsets
//        self.messageTableView.scrollIndicatorInsets = adjustForTabbarInsets
        
        messageTableView.rowHeight = UITableView.automaticDimension
        messageTableView.estimatedRowHeight = 120.0
    }
    
    
    
    @objc func keyboardWillShow(_ notification: Notification) {
        if let keyboardFrame: NSValue = notification.userInfo?[UIResponder.keyboardFrameEndUserInfoKey] as? NSValue {
            let keyboardRectangle = keyboardFrame.cgRectValue
            keyboardHeight = keyboardRectangle.height
        }
    }
    
    
    
    func textFieldDidBeginEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2) {
            

            
            let height = self.keyboardHeight
            
            print("h--e--i--g--h--t---o--f---t--h--e---k--e--y--b--o--a--r--d \(height)")
            self.heightConstraint.constant = height + 50
            self.view.layoutIfNeeded()
        }
    }
    
    
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        
        UIView.animate(withDuration: 0.2) {
            
            self.heightConstraint.constant =  50
            self.view.layoutIfNeeded()
        }
    }
    

    
    @IBAction func sendButtonPressed(_ sender: Any) {
        
        if messageTextfield.text?.count != 0 {
            
            currentUser = currentUser.replacingOccurrences(of: "+", with: "")
            
            messageTextfield.isEnabled = false
            sendButton.isEnabled = false
            
            let messageDB = Database.database().reference().child("messages")
            
            let messageDictonary = ["sender": currentUser, "message_body": self.messageTextfield.text!] as [String : Any]
            
            if token == 1 {
                
                messageDB.child(self.messageId1).childByAutoId().setValue(messageDictonary) {
                    (error, reference) in
                    
                    if error == nil {
                        
                        print("Message sent successfully!")
                        
                        self.messageTextfield.isEnabled = true
                        
                        self.sendButton.isEnabled = true
                        
                        self.messageTextfield.text = ""
                        
                        print("-----1---------\(self.messageId1)-------------------")
                    }
                    else {
                        
                        print("error\(String(describing: error))")
                    }
                }
            }
            else if token == 2 {
                
                messageDB.child(self.messageId2).childByAutoId().setValue(messageDictonary) {
                    (error, reference) in
                    
                    if error == nil {
                        
                        print("Message sent successfully!")
                        
                        self.messageTextfield.isEnabled = true
                        
                        self.sendButton.isEnabled = true
                        
                        self.messageTextfield.text = ""
                        
                        print("------2--------\(self.messageId2)-------------------")
                    }
                    else {
                        
                        print("error\(String(describing: error))")
                    }
                }
            }
            self.messageTableView.reloadData()
            
            let dictonary1 = ["name": topTitle]
            //let dictonary2 = ["name": currentUser]
            
            let forRunningListDatabase = Database.database().reference().child("knox_user")
                
            forRunningListDatabase.child(currentUser).child("messages").child(tappedUserName).setValue(dictonary1)
            //forRunningListDatabase.child(tappedUserName).child("messages").child(currentUser).setValue(dictonary2)
            
        }
    }
    
    
    func retrieveMessage() {
        
        currentUser = currentUser.replacingOccurrences(of: "+", with: "")
        
        let messageDB = Database.database().reference().child("messages")
        
        messageDB.observeSingleEvent(of: .value) { (dataSnapshot) in
            
            if dataSnapshot.hasChild(self.messageId1) {
                
                self.token = 1
                
                messageDB.child(self.messageId1).observe(.childAdded) { (snapshot) in
                    
                    let snapshotValue = snapshot.value as! Dictionary<String,String>
                    
                    let text = snapshotValue["message_body"]!
                    
                    let sender = snapshotValue["sender"]!
                    
                    let message = Message()
                    
                    message.messageBody = text
                    
                    message.sender = sender
                    
                    self.messageArray.append(message)
                    
                    self.messageTableView.reloadData()
                    self.configureTableView()
                    
                    print("message id 1 \(self.messageId1)")
                    print("This is the message body \(text)")
                    print("this is sender name \(sender)")
                }
            }
            else if dataSnapshot.hasChild(self.messageId2) {
                
                self.token = 2
                
                messageDB.child(self.messageId2).observe(.childAdded) { (snapshot) in
                    
                    let snapshotValue = snapshot.value as! Dictionary<String,String>
                    
                    let text = snapshotValue["message_body"]!
                    let sender = snapshotValue["sender"]!
                    
                    let message = Message()
                    
                    message.messageBody = text
                    message.sender = sender
                    
                    self.messageArray.append(message)
                    
                    self.configureTableView()
                    self.messageTableView.reloadData()
                    
                    print("message id 1 \(self.messageId2)")
                    print("This is the message body \(text)")
                    print("this is sender name \(sender)")
                }
            }
            else {
                
                self.token = 1
                print("----------------N---O----------child-----------")
            }
            
        }
        
       // messageDB.observe(.childAdded) { (dataSnapshot) in
            //if dataSnapshot.hasChild("messages") {
                

          //  }
        //}
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }

    
    
    @IBAction func backButton(_ sender: Any) {
        
        self.navigationController?.popViewController(animated: true)
        
        dismiss(animated: false, completion: nil)
    }
    
    
    
    @IBAction func tempButton(_ sender: Any) {
    
        do{
            
            try Auth.auth().signOut()
            self.performSegue(withIdentifier: "goToFirst", sender: self)
        }
            
        catch{
            
            print("Error while signing out!")
        }
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
