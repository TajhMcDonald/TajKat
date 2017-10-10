//
//  MessagesTableViewController.swift
//  TajKat
//
//  Created by Admin on 7/10/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

//import UIKit
//import FirebaseAuth
//import SwiftyJSON
//import FirebaseDatabase
//import FirebaseDatabaseUI
//import Chatto
//import ChattoAdditions
//
//class MessagesTableViewController: UIViewController, FUICollectionDelegate, UITableViewDelegate, UITableViewDataSource {
//    let Contacts = FUISortedArray(query: Database.database().reference().child("Users").child(Me.uid).child("Contacts"), delegate: nil) { (lhs, rhs) -> ComparisonResult in
//        let lhs = Date(timeIntervalSinceReferenceDate: JSON(lhs.value as Any)["lastMessage"]["date"].doubleValue)
//        let rhs = Date(timeIntervalSinceReferenceDate:JSON(rhs.value as Any)["lastMessage"]["date"].doubleValue)
//        return rhs.compare(lhs)
//    }
//    let usersRef = Database.database().reference(withPath: "online")
//
//    var users = [User]()
//
//    @IBOutlet weak var tableView: UITableView!
//    override func viewDidLoad() {
//        super.viewDidLoad()
////        fetchUser()
//
//        self.Contacts.observeQuery()
//        self.Contacts.delegate = self
//        self.tableView.delegate = self
//        self.tableView.dataSource = self
//        Database.database().reference().child("User-messages").child(Me.uid).keepSynced(true)
//        // Do any additional setup after loading the view.
//
//    }
//
//
//    override func didReceiveMemoryWarning() {
//        super.didReceiveMemoryWarning()
//        // Dispose of any resources that can be recreated.
//    }
//
//    func showChatControllerForUser(user: User){
//        let chatLogController = ChatLogController()
//        chatLogController.user = user
//        navigationController?.pushViewController(chatLogController, animated: true)
//
//    }
//
//    @IBAction func Add(_ sender: Any) {
//        self.presentAlert()
////        let newMessageController = NewMessageTableViewController()
////        newMessageController.messagesController = self
////        let navController = UINavigationController(rootViewController: newMessageController)
////        self.present(navController, animated: true, completion: nil)
//
//
//    }
//
////        var messagesController:MessagesTableViewController?
//
//    func presentAlert() {
//        let alertController = UIAlertController(title: "Email?", message: "Please write email", preferredStyle: .alert)
//        alertController.addTextField { (textField) in textField.placeholder = "Email" }
//        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
//        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
//            if let email = alertController.textFields?[0].text {
//                self?.addContact(email: email)
//
//            }
//        }
//        alertController.addAction(cancelAction)
//        alertController.addAction(confirmAction)
//        self.present(alertController, animated: true, completion: nil)
//
//        }
//
//
//        func addContact(email: String) {
//            Database.database().reference().child("users").observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
//                let snapshot = JSON(snapshot.value as Any).dictionaryValue
//                if let index = snapshot.index(where: { (key, value) -> Bool in
//                    return value["email"].stringValue == email
//
//                }) {
//
//
//                    let allUpdate = ["/users/\(Me.uid)/Contacts/\(snapshot[index].key)": (["email": snapshot[index].value["email"].stringValue, "name": snapshot[index].value["name"].stringValue]),
//
//                                     "/users/\(snapshot[index].key)/Contacts/\(Me.uid)": (["email": Auth.auth().currentUser!.email!, "name": Auth.auth().currentUser!.displayName!])]
//                    Database.database().reference().updateChildValues(allUpdate)
//
//
//
//
//
//                    self?.alert(message: "success")
//                } else {
//                    self?.alert(message: "e-mail doesn't exist")
//                }
//
//                })
//
//        }
//
//    deinit {
//
//        print("deinit")
//    }
//
//
//
//
//    /*
//    // MARK: - Navigation
//
//    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
//        // Get the new view controller using segue.destinationViewController.
//        // Pass the selected object to the new view controller.
//    }
//    */
//
//}
//
//extension MessagesTableViewController {
//    func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
//        self.tableView.insertRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
//    }
//
//    func array(_ array: FUICollection, didMove object: Any, from fromIndex: UInt, to toIndex: UInt) {
//        self.tableView.insertRows(at: [IndexPath(row: Int(toIndex), section: 0)], with: .automatic)
//        self.tableView.deleteRows(at: [IndexPath(row: Int(fromIndex), section: 0)], with: .automatic)
//
//    }
//
//    func array(_ array: FUICollection, didChange object: Any, at index: UInt) {
//        self.tableView.reloadRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
//
//    }
//
//    func array(_ array: FUICollection, didRemove object: Any, at index: UInt) {
//        self.tableView.deleteRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
//
//    }
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        return Int(self.Contacts.count)
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MesagesTableViewCell
//        let info = JSON((Contacts[(UInt(indexPath.row))] as? DataSnapshot)?.value as Any).dictionaryValue
//        cell.name.text = info["name"]?.stringValue
//        cell.lastMessage.text = info["lastMessage"]?["text"].string
//        cell.lastMessageDate.text = dateFormatter(timestamp: info["lastMessage"]?["date"].double)
//
//        return cell
//    }
//
//
//    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        let uid = (Contacts[UInt(indexPath.row)] as? DataSnapshot)!.key
//        let reference = Database.database().reference().child("User-messages").child(Me.uid).child(uid).queryLimited(toLast: 51)
//        self.tableView.isUserInteractionEnabled = false
//
//        reference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
//
//            let messages = Array(JSON(snapshot.value as Any).dictionaryValue.values).sorted(by: { (lhs, rhs) -> Bool in
//                return lhs["date"].doubleValue < rhs["date"].doubleValue
//            })
//            let converted = self!.convertToChatItemProtocol(messages: messages)
//            let chatlog = ChatLogController()
//            chatlog.userUID = uid
//            chatlog.dataSource = DataSource(initialMessages: converted, uid: uid)
//            chatlog.MessagesArray = FUIArray(query: Database.database().reference().child("User-messages").child(Me.uid).child(uid).queryStarting(atValue: nil, childKey: converted.last?.uid), delegate: nil)
//            self?.navigationController?.show(chatlog, sender: nil)
//            self?.tableView.deselectRow(at: indexPath, animated: true)
//            self?.tableView.isUserInteractionEnabled = true
//            messages.filter({ (message) -> Bool in
//                return message["type"].stringValue == PhotoModel.chatItemType
//            }).forEach({ (message) in
//                self?.parseURLs(UID_URL: (key: message["uid"].stringValue, value: message["image"].stringValue))
//            })
//
//        })
//
//    }
//}
//func dateFormatter(timestamp: Double?) -> String? {
//
//    if let timestamp = timestamp {
//        let date = Date(timeIntervalSinceReferenceDate: timestamp)
//        let dateFormatter = DateFormatter()
//        let timeSinceDateInSeconds = Date().timeIntervalSince(date)
//        let secondInDays: TimeInterval = 24*60*60
//        if timeSinceDateInSeconds > 7 * secondInDays {
//            dateFormatter.dateFormat = "MM/dd/yy"
//        } else if timeSinceDateInSeconds > secondInDays {
//            dateFormatter.dateFormat = "EEE"
//        } else {
//            dateFormatter.dateFormat = "h:mm a"
//        }
//        return dateFormatter.string(from: date)
//    } else {
//        return nil
//    }
//
//}

import UIKit
import FirebaseAuth
import SwiftyJSON
import FirebaseDatabase
import FirebaseDatabaseUI
import Chatto
class MessagesTableViewController: UIViewController, FUICollectionDelegate, UITableViewDelegate, UITableViewDataSource {
    
    
    let Contacts = FUISortedArray(query: Database.database().reference().child("Users").child(Me.uid).child("Contacts"), delegate: nil) { (lhs, rhs) -> ComparisonResult in
        let lhs = Date(timeIntervalSinceReferenceDate: JSON(lhs.value as Any)["lastMessage"]["date"].doubleValue)
        let rhs = Date(timeIntervalSinceReferenceDate:JSON(rhs.value as Any)["lastMessage"]["date"].doubleValue)
        return rhs.compare(lhs)
    }
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()
        self.Contacts.observeQuery()
        self.Contacts.delegate = self
        self.tableView.delegate = self
        self.tableView.dataSource = self
        Database.database().reference().child("User-messages").child(Me.uid).keepSynced(true)
        
        // Do any additional setup after loading the view.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func Add(_ sender: Any) {
        self.presentAlert()
    }
    
    @IBAction func SignOut(_ sender: Any) {
        try! Auth.auth().signOut()
        self.navigationController?.popToRootViewController(animated: true)
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Email?", message: "Please write the email:", preferredStyle: .alert)
        
        alertController.addTextField { (textField) in
            textField.placeholder = "Email"
        }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
            
            if let email = alertController.textFields?[0].text {
                self?.addContact(email: email)
            }
        }
        
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        
    }
    
    func addContact(email: String) {
        
        Database.database().reference().child("Users").observeSingleEvent(of: .value, with: {  [weak self] (snapshot) in
            
            let snapshot = JSON(snapshot.value as Any).dictionaryValue
            if let index = snapshot.index(where: { (key, value) -> Bool in
                return value["email"].stringValue == email
            }) {
                
                
                
                let allUpdates =  ["/Users/\(Me.uid)/Contacts/\(snapshot[index].key)": (["email": snapshot[index].value["email"].stringValue, "name": snapshot[index].value["name"].stringValue]),
                                   "/Users/\(snapshot[index].key)/Contacts/\(Me.uid)": (["email": Auth.auth().currentUser!.email!, "name": Auth.auth().currentUser!.displayName!])]
                Database.database().reference().updateChildValues(allUpdates)
                
                
                
                self?.alert(message: "success")
                
            } else {
                self?.alert(message: "Email doesn't exist")
            }
            
            
        })
        
        
        
        
    }
    
    deinit {
        
        print("deinit")
    }
    
}


extension MessagesTableViewController {
    
    func array(_ array: FUICollection, didAdd object: Any, at index: UInt) {
        self.tableView.insertRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
    }
    
    func array(_ array: FUICollection, didMove object: Any, from fromIndex: UInt, to toIndex: UInt) {
        self.tableView.insertRows(at: [IndexPath(row: Int(toIndex), section: 0)], with: .automatic)
        self.tableView.deleteRows(at: [IndexPath(row: Int(fromIndex), section: 0)], with: .automatic)
        
        
    }
    func array(_ array: FUICollection, didRemove object: Any, at index: UInt) {
        self.tableView.deleteRows(at: [IndexPath(row: Int(index), section: 0)], with: .automatic)
        
        
    }
    func array(_ array: FUICollection, didChange object: Any, at index: UInt) {
        self.tableView.reloadRows (at: [IndexPath(row: Int(index), section: 0)], with: .none)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return Int(self.Contacts.count)
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath) as! MesagesTableViewCell
        let info = JSON((Contacts[(UInt(indexPath.row))] as? DataSnapshot)?.value as Any).dictionaryValue
        cell.name.text = info["name"]?.stringValue
        cell.lastMessage.text = info["lastMessage"]?["text"].string
        cell.lastMessageDate.text = dateFormatter(timestamp: info["lastMessage"]?["date"].double)
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let uid = (Contacts[UInt(indexPath.row)] as? DataSnapshot)!.key
        let reference = Database.database().reference().child("User-messages").child(Me.uid).child(uid).queryLimited(toLast: 51)
        self.tableView.isUserInteractionEnabled = false
        
        reference.observeSingleEvent(of: .value, with: { [weak self] (snapshot) in
            
            let messages = Array(JSON(snapshot.value as Any).dictionaryValue.values).sorted(by: { (lhs, rhs) -> Bool in
                return lhs["date"].doubleValue < rhs["date"].doubleValue
            })
            let converted = self!.convertToChatItemProtocol(messages: messages)
            let chatlog = ChatLogController()
            chatlog.userUID = uid
            chatlog.dataSource = DataSource(initialMessages: converted, uid: uid)
            chatlog.MessagesArray = FUIArray(query: Database.database().reference().child("User-messages").child(Me.uid).child(uid).queryStarting(atValue: nil, childKey: converted.last?.uid), delegate: nil)
            self?.navigationController?.show(chatlog, sender: nil)
            self?.tableView.deselectRow(at: indexPath, animated: true)
            self?.tableView.isUserInteractionEnabled = true
            messages.filter({ (message) -> Bool in
                return message["type"].stringValue == PhotoModel.chatItemType
            }).forEach({ (message) in
                self?.parseURLs(UID_URL: (key: message["uid"].stringValue, value: message["image"].stringValue))
            })
            
        })
        
    }
    
    
    func dateFormatter(timestamp: Double?) -> String? {
        
        if let timestamp = timestamp {
            let date = Date(timeIntervalSinceReferenceDate: timestamp)
            let dateFormatter = DateFormatter()
            let timeSinceDateInSeconds = Date().timeIntervalSince(date)
            let secondInDays: TimeInterval = 24*60*60
            if timeSinceDateInSeconds > 7 * secondInDays {
                dateFormatter.dateFormat = "MM/dd/yy"
            } else if timeSinceDateInSeconds > secondInDays {
                dateFormatter.dateFormat = "EEE"
            } else {
                dateFormatter.dateFormat = "h:mm a"
            }
            return dateFormatter.string(from: date)
        } else {
            return nil
        }
        
    }
    
}

