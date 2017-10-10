//  TajKat
//
//  Created by Admin on 7/1/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import UIKit
import Firebase

class NewMessageTableViewController: UITableViewController {
 
    
    let cellId = "cellId"
    var users = [User]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))
        tableView.register(UserCell.self, forCellReuseIdentifier: cellId)
        fetchUser()
    }
    
    
    
        func fetchUser() {
            Database.database().reference().child("Users").observe(.childAdded, with: { (snapshot) in
    
                print("User Founds")
                print(snapshot)
                if let dict = snapshot.value as? [String:AnyObject] {
                    let user = User()
                    //                user.setValuesForKeysWithDictionary(dict)
                    user.name = dict["name"] as? String
                    user.email = dict["email"] as? String
                    user.profileImageUrl = dict["profileImageUrl"] as? String
                    //                user.id = snapshot.key
    
                    self.users.append(user)
    
                    DispatchQueue.main.async(execute: {
                        self.tableView.reloadData()
                    })
                }
    
                
            }, withCancel: nil)
            
        }
    
    func handleCancel(){
        dismiss(animated: true, completion: nil)
    }
    
    
    
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return users.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellId, for: indexPath) as! UserCell
        cell.user = users[indexPath.row]
        
        return cell
    }
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat{
        return 72
    }
    
 
    weak var messagesController:MessagesTableViewController?
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {


        self.dismiss(animated: true) {
            print("Dismiss Completed")
            let user = self.users[indexPath.row]
            
//            self.messagesController?.showChatControllerForUser(user: user)
        }
    }
    
}

class UserCell:UITableViewCell{
    
    override func layoutSubviews() {
        super.layoutSubviews()
        textLabel?.frame = CGRect(x: 64, y: textLabel!.frame.origin.y - 2, width: textLabel!.frame.width, height: textLabel!.frame.height)
        detailTextLabel?.frame = CGRect(x: 64, y: detailTextLabel!.frame.origin.y + 2, width: detailTextLabel!.frame.width, height: detailTextLabel!.frame.height)
    }
    
    let profileImageView:UIImageView = {
        let imageView = UIImageView()
        imageView.image = UIImage(named: "user_male_circle")
        imageView.layer.cornerRadius = 24
        imageView.contentMode = .scaleAspectFill
        imageView.layer.masksToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: .subtitle, reuseIdentifier: reuseIdentifier)
        addSubview(profileImageView)
        profileImageView.leftAnchor.constraint(equalTo: self.leftAnchor, constant: 8).isActive = true
        profileImageView.centerYAnchor.constraint(equalTo: self.centerYAnchor).isActive = true
        profileImageView.widthAnchor.constraint(equalToConstant: 48).isActive = true
        profileImageView.heightAnchor.constraint(equalToConstant: 48).isActive = true
        
        
        
    }
    
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    var user: User?{
        didSet{
            textLabel?.text = user?.name
            detailTextLabel?.text = user?.email
            imageView?.contentMode = .scaleAspectFill
            setupProfileImage()
            
        }
    }
    
    let imageCache = NSCache<AnyObject, AnyObject>()
    
    private func setupProfileImage(){
        if let profileImageURL = user?.profileImageUrl{
            print(profileImageURL)
            let url = URL(string: profileImageURL)
            if let imgUrl = user?.email{
                if let imageFromCache = imageCache.object(forKey: imgUrl as AnyObject) as? UIImage{
                    self.profileImageView.image = imageFromCache
                    return
                }
            }
            
            URLSession.shared.dataTask(with: url!, completionHandler: { (data, response, error) in
                if error != nil{
                    return
                }
                DispatchQueue.main.async {
                    if let pImage = UIImage(data: data!){
                        self.imageCache.setObject(pImage, forKey: self.user?.profileImageUrl as AnyObject)
                        self.profileImageView.image = pImage
                    }
                    
                }
            }).resume()
            
        }
    }
    
}
