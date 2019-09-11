//
//  ChatListViewController.swift
//  knoX
//
//  Created by Arif Amzad on 5/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit
import Firebase
import Contacts
import ChameleonFramework

class ChatListViewController: UITableViewController {
    
    var chatListArray: [ChatList] = [ChatList]()

    var currentUser: String = Auth.auth().currentUser?.phoneNumber ?? "current user phone"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.backgroundColor = UIColor.init(white: 0.95, alpha: 1)
        
        navigationItem.title = "Contact"
        
        tableView.register(UINib(nibName: "ChatListViewCell", bundle: nil), forCellReuseIdentifier: "chatListViewCellXIB")
        
        retrieveChatList()
        configureTableView()
    }

    
    
    // MARK: - Table view data source
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return chatListArray.count
    }
    
    

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "chatListViewCellXIB", for: indexPath) as! ChatListViewCell
        
        cell.name.text = chatListArray[indexPath.row].name
        
        cell.avatar.image = UIImage(named: "avatar")
        return cell
    }
    
    
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        tableView.deselectRow(at: indexPath as IndexPath, animated: true)
        
        let vc = storyboard?.instantiateViewController(withIdentifier: "ChatViewControllerID") as! ChatViewController
        
        vc.messageId1 = "\(currentUser)\(chatListArray[indexPath.row].userName)"
        vc.messageId2 = "\(chatListArray[indexPath.row].userName)\(currentUser)"
        
        vc.topTitle = "\(chatListArray[indexPath.row].name)"
        
        vc.tappedUserName = chatListArray[indexPath.row].userName
        
        self.navigationController?.pushViewController(vc, animated: true)
    }

    
    
    func configureTableView() {
        
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 120.0
    }
    
    
    
    func retrieveChatList() {
        
        currentUser = currentUser.replacingOccurrences(of: "+", with: "")
        
        let db = Database.database().reference().child("knox_user").child(currentUser)
        
        //db.observe(.value) { (dataSnapshot) in
            
            //if dataSnapshot.hasChild("chat_list") {
                
                db.child("chat_list").observe(.childAdded) { (snapshot) in
                    
                    let snapshotValue = snapshot.value as! Dictionary<String,String>
                    
                    let tappedName = snapshotValue["name"]
                    
                    let tappedUserName = snapshot.key
                    
                    let chatList = ChatList()
                    
                    chatList.name = tappedName!
                    
                    chatList.userName = tappedUserName
                    
                    self.chatListArray.append(chatList)
                    
                    self.tableView.reloadData()
                    
                    //print("This is children \(tappedUser)")
                    //print(tappedName!)
                    //print("")
                    
                    
                }
            //}
        //}
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
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
