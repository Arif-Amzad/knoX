//
//  RunningChatListViewController.swift
//  knoX
//
//  Created by Arif Amzad on 8/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase
import Contacts

class RunningChatListViewController: UITableViewController {

    var runningChatListArray: [ChatList] = [ChatList]()
    
    var currentUser: String = Auth.auth().currentUser?.phoneNumber ?? "current user phone"
    
    //var tappedUserName: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.register(UINib(nibName: "ChatListViewCell", bundle: nil), forCellReuseIdentifier: "chatListViewCellXIB")
        
        retrieveRunningChatList()
        configureTableView()
        //backgroudnDataReady()
        fetchContacts()
        
        tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        //self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        //navigationItem.backBarButtonItem?.isEnabled = false
    }
    
    
    
    @IBAction func messageAddButon(_ sender: Any) {
        
        performSegue(withIdentifier: "goToChatListAll", sender: self)
    }
    
    
    // MARK: - Table view data source
//    override func numberOfSections(in tableView: UITableView) -> Int {
//        // #warning Incomplete implementation, return the number of sections
//        return 0
//    }
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return runningChatListArray.count
    }

    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListViewCellXIB", for: indexPath) as! ChatListViewCell
        
        cell.name.text = runningChatListArray[indexPath.row].name
        cell.avatar.image = UIImage(named: "avatar")
        
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        let chattingVC = storyboard?.instantiateViewController(withIdentifier: "ChatViewControllerID") as! ChatViewController
        
        chattingVC.messageId1 = "\(currentUser)\(runningChatListArray[indexPath.row].userName)"
        chattingVC.messageId2 = "\(runningChatListArray[indexPath.row].userName)\(currentUser)"
        
        chattingVC.topTitle = "\(runningChatListArray[indexPath.row].name)"
        
        chattingVC.tappedUserName = runningChatListArray[indexPath.row].userName
        
        self.navigationController?.pushViewController(chattingVC, animated: true)
        
    }
    
    
    
    func configureTableView() {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    
    
    func retrieveRunningChatList() {
        
        var messageWelcome1ID1: String = ""
        var messageWelcome1ID2: String = ""
        
        currentUser = currentUser.replacingOccurrences(of: "+", with: "")
        //getting list who i contacted at least for once part -1
        let database = Database.database().reference().child("knox_user").child(currentUser)
        
        database.child("chat_list").observe(.childAdded) { (snapshot) in
            
            let tappedUserName = snapshot.key
            
            messageWelcome1ID1 = ("\(self.currentUser)\(tappedUserName)")
            messageWelcome1ID2 = ("\(tappedUserName)\(self.currentUser)")
            
            //adding welcome message to my all contact
            let mDatabase = Database.database().reference().child("messages")
            
            let welcomeMessageDictonary1 = ["sender": tappedUserName, "message_body": "hi there!"]
            
            let welcomeMessageDictonary2 = ["sender": self.currentUser, "message_body": "hi there!"]
            
            //var noChatYet: Bool?
            
            mDatabase.observe(.value, with: { (snap) in
                
                if snap.hasChild(messageWelcome1ID1) || snap.hasChild(messageWelcome1ID2) {
                    
                    
                }
                else {
                mDatabase.child(messageWelcome1ID1).child("----\(self.currentUser)").setValue(welcomeMessageDictonary1)
                    
                    mDatabase.child(messageWelcome1ID1).child("----\(self.currentUser)1").setValue(welcomeMessageDictonary2)
                }
            })
            
            
            
            
            //part - 2
            database.child("messages").child(tappedUserName).observe(.childAdded, with: { (dataSnapshot) in
            
                let tappedName = dataSnapshot.value
            
                let runningChatList = ChatList()
            
                runningChatList.name = tappedName as! String
            
            runningChatList.userName = tappedUserName
                
                //if !noChatYet! {
                    
                    self.runningChatListArray.append(runningChatList)
                    self.tableView.reloadData()
                //}
            
                
            
                
            
            print("-------------------------------------------------------")
            print(tappedUserName)
            print(tappedName!)
            
            })
            
        }
        
        //backgroudnDataReady()
        


    }
    
    
    
//    func backgroudnDataReady() {
//
//        let mDatabase = Database.database().reference().child("messages")
//
//        let welcomeMessageDictonary = ["sender": tappedUserName, "message_body": "hi there!"]
//
//        mDatabase.child("\(currentUser)\(tappedUserName)").childByAutoId().setValue(welcomeMessageDictonary)
//    }
    
    
    
    func fetchContacts() {
        
        print("Contacts have started fetching...")
        
        let store = CNContactStore()
        
        
        store.requestAccess(for: .contacts) { (granted, error) in
            
            if granted {
                
                print("Access granted!")
                
                let keys = [CNContactGivenNameKey, CNContactPhoneNumbersKey]
                
                let request = CNContactFetchRequest(keysToFetch: keys as [CNKeyDescriptor])
                
                do {
                    try store.enumerateContacts(with: request, usingBlock: { (contact, stropPointerIfYouWantToStopEnumerating ) in
                        
                        let contactName = contact.givenName
                        var contactNumber = contact.phoneNumbers.first?.value.stringValue ??
                        "No phone number"
                        
                        contactNumber = contactNumber.replacingOccurrences(of: " ", with: "")
                        contactNumber = contactNumber.replacingOccurrences(of: "-", with: "")
                        contactNumber = contactNumber.replacingOccurrences(of: "+", with: "")
                        //print(contactNumber)
                        
                        let db = Database.database().reference().child("knox_user")
                        
                        db.observe(.value) { (dataSnapshot) in
                            
                            if dataSnapshot.hasChild(contactNumber) {
                                
                                print("Found-------")
                                
                                //var currentUser: String = Auth.auth().currentUser?.phoneNumber ?? "current user phone"
                                
                                self.currentUser = self.currentUser.replacingOccurrences(of: "+", with: "")
                                
                                let dictonary = ["name": contactName]
                                
                                db.child(self.currentUser).child("chat_list").child(contactNumber).setValue(dictonary) {
                                    
                                    (error, reference) in
                                    
                                    if error == nil {
                                        
                                        print("Fetched successfully!")
                                        
                                    }
                                    else {
                                        print("error\(String(describing: error))")
                                    }
                                }
                                //db.child(self.currentUser!).child("chat_list").child(contactNumber).child("messages").setValue(dictonary)
                                
                            }
                            else {
                                
                                print("Not found--------")
                            }
                        }
                    })
                    
                }catch let err {
                    
                    print("Failed to enumerate contacts", err)
                }
            }
            else {
                
                print("Access denied")
            }
        }
    }
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
