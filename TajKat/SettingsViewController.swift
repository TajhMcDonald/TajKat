//
//  SettingsViewController.swift
//  TajKat
//
//  Created by Admin on 7/7/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import UIKit
import Photos
import Firebase

class SettingsViewController: UIViewController, AlertController {
    lazy var databaseManager = DatabaseController()
    var Usher: User = User()

    lazy var userInformationRef: DatabaseReference = Database.database().reference().child("Users")
    lazy var userDisplayPictureRef: StorageReference = Storage.storage().reference().child("displayPictures")
    var user: User = User()
    var currentAttributeChanging: Constants.UserAttribute = Constants.UserAttribute.none
    var attributePrompt: String = ""

    @IBOutlet weak var userPictureImageView: UIImageView!
    @IBOutlet weak var userDisplayNameLabel: UILabel!
    @IBOutlet weak var usernameLabel: UILabel!
    @IBOutlet weak var statusTextField: UITextField!
    @IBOutlet weak var editStatusButton: UIButton!
    @IBOutlet weak var status: UILabel!
    @IBOutlet weak var emailID: UILabel!
    
    // ==========================================
    // ==========================================
    override func viewDidLoad() {
        super.viewDidLoad()
        self.navigationController?.isNavigationBarHidden = false
        loadCurrentUserInformation()
        self.status.text = self.user.status

        // Add gesture recognizer to the profile picture UIImageView
        let imageGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(SettingsViewController.promptImageSelection))
        self.updateUserDisplayPicture()
        userPictureImageView.addGestureRecognizer(imageGestureRecognizer)
        userPictureImageView.isUserInteractionEnabled = true
    }
    
    // ==========================================
    // ==========================================
    override func viewWillAppear(_ animated: Bool) {
        print("TajKat:: Settings screen appeared, loading user information...")
        loadCurrentUserInformation()
        
        userPictureImageView.layer.masksToBounds = true
        userPictureImageView.clipsToBounds = true
        userPictureImageView.layer.cornerRadius = userPictureImageView.frame.width / 2
    }
    
    // ==========================================
    // ==========================================
    func updateUserDisplayPicture() {
        
        let uid = UserState.currentUser.uid
        let url = "displayPictures/\(uid)/\(uid).JPG"
        
        // Redownload into image into image view
        // Although user may not even have profile picture yet, this method is safe and will clear if cached
        databaseManager.reloadImage(into: userPictureImageView, from: url, completion: { error in
            if let error = error { print("Error: \(error.localizedDescription)") }
            else { print("Good") }
        })
        
        databaseManager.setDisplayPicture(path: "displayPictures/\(uid)/\(uid).JPG")

    }
    
    // ==========================================
    // ==========================================
    private func loadCurrentUserInformation() {
        
        // Should never happen, app blocks until these have been set at login
//        userDisplayNameLabel.text = UserState.currentUser.name
//        userDisplayNameLabel.text = "Display Name"
        let uid = UserState.currentUser.uid
//        usernameLabel.text = UserState.currentUser.username
        self.usernameLabel.text = Auth.auth().currentUser?.displayName
        self.emailID.text = Auth.auth().currentUser?.email
//        guard let picture = UserState.currentUser.displayPicture
//            else {
//            presentSimpleAlert(title: "Could Not Set Picture", message: Constants.Errors.DisplayPictureMissing, completion: nil)
//            return
//        }

        // Display picture may very well be nil if not set or loaded yet
        // This is because display pictures are loaded asynchronously at launch

        databaseManager.downloadImage(into: userPictureImageView,
                                      from: "displayPictures/\(uid)/\(uid).JPG", completion: { error in
                                        
                                       
        })
    }
    

    
    // ==========================================
    // ==========================================
    func promptImageSelection() {
        
        // Create picker, and set this controller as delegate
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.allowsEditing = true
        
        // Call AlertController method to display ActionSheet allowing Camera or Photo Library selection
        // Use callback to set picker source type determined in the alert controller
        
        presentPhotoSelectionPrompt(completion: { (sourceType: UIImagePickerControllerSourceType?) in
            
            if let sourceType = sourceType {
                picker.sourceType = sourceType
                self.present(picker, animated: true, completion: nil)
            }
        })
    }
    
    
    // ==========================================
    // ==========================================
    func dismissKeyboard() {
        self.view.endEditing(true)
    }
    
    // ==========================================
    // ==========================================
    

    
    @IBAction func changeEmail(_ sender: Any) {
        
    }
    
    @IBAction func editStatusAction(_ sender: AnyObject) {
        self.status.isHidden = true
        self.editStatusButton.isHidden = true
        self.statusTextField.isHidden = false
        self.statusTextField.text = ""
        self.statusTextField.becomeFirstResponder()
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        if textField.text?.characters.count == 0{
            return false
        }
        updateUserStatus(status: textField.text!) { (result) in
            if result{
                self.status.text = textField.text!
            }
        }
        self.status.isHidden = false
        self.editStatusButton.isHidden = false
        self.statusTextField.isHidden = true
        textField.resignFirstResponder()
        return true
    }
//    func fetchCurrentUser() {
//            fetchContactForKey(contactKey: (Auth.auth().currentUser?.uid)!) { (user) in
//                self.currentUser = user
//            }
//        }
    
    
    func updateUserStatus(status: String, CompletionHandler: @escaping (Bool) -> ()) {
        let child = Database.database().reference().child(FirechatUsersString).child(Auth.auth().currentUser!.uid)
        child.updateChildValues([FirechatStatusString: status])
        CompletionHandler(true)
    }
            
    @IBAction func deleteAccount(_ sender: Any) {
        let user = Auth.auth().currentUser
        
        user?.delete { error in
            if error != nil {
                let ac = UIAlertController(title: "Error", message: "Error deleting account.", preferredStyle: .alert)
                ac.view.tintColor = Constants.Colors.primaryDark
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                ac.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in }
                    // An error happened.
                ))} else {
                let ac = UIAlertController(title: "Confirm", message: "You are about to permanently delete your account. Are you sure?", preferredStyle: .alert)
                ac.view.tintColor = Constants.Colors.primaryDark
                ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
                ac.addAction(UIAlertAction(title: "Delete", style: .default, handler: { (action) in }
                    // An error happened.
                ))
                // Account deleted.
                self.present(ac, animated: true, completion: nil)
                
                //                self.dismiss(animated: true, completion: nil)
                
                
            }
        }
        
    }
    
    @IBAction func changeName(_ sender: Any) {
        self.presentAlert()
    }
    
    func presentAlert() {
        let alertController = UIAlertController(title: "Display Name", message: "Enter Display Name", preferredStyle: .alert)
        alertController.addTextField { (textField) in textField.placeholder = "Display Name" }
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let confirmAction = UIAlertAction(title: "Confirm", style: .default) { [weak self] (_) in
            if (alertController.textFields?[0].text) != nil {
                let cuUser = Auth.auth().currentUser
                if let cuUser = cuUser {
                    let changeRequest = cuUser.createProfileChangeRequest()
                    changeRequest.displayName = alertController.textFields?[0].text
                    changeRequest.commitChanges { error in
                        if error != nil {
                            print("there was an error")
                            
                        } else {
                            self?.usernameLabel.text = Auth.auth().currentUser?.displayName
                            
                        }
                    }
                    
                }
                
            }
            
        }
        alertController.addAction(cancelAction)
        alertController.addAction(confirmAction)
        self.present(alertController, animated: true, completion: nil)
        
        
    }
    
    
    @IBAction func changePassword(_ sender: Any) {
        //        let user = Auth.auth().currentUser
        //        var credential: AuthCredential
        //
        let ac = UIAlertController(title: "Password Reset", message: "sending password reset link", preferredStyle: .alert)
        ac.view.tintColor = Constants.Colors.primaryDark
        //        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Okay", style: .default, handler: { (action) in }
            // An error happened.
        ))
        Auth.auth().sendPasswordReset(withEmail: Auth.auth().currentUser!.email!) { error in
            print("TajKat:: \(String(describing: error?.localizedDescription))")
            
        }
        self.present(ac, animated: true, completion: nil)
        
        do {
            // Attempt to logout, may throw error
            try Auth.auth().signOut()
            self.navigationController?.popToRootViewController(animated: true)
            
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
        
        
    }
    @IBAction func signout(_ sender: Any) {
        // Present a confirmation dialog to logout
        let ac = UIAlertController(title: "Confirm Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        ac.view.tintColor = Constants.Colors.primaryDark
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in
            
            do {
                // Attempt to logout, may throw error
                try Auth.auth().signOut()
                self.navigationController?.popToRootViewController(animated: true)
                
                
            } catch let error as NSError {
                print("AtMe:: \(error.localizedDescription)")
            }
        }))
        
        // Present the alert
        self.present(ac, animated: true, completion: nil)
    }
    
    

    

    func logout() {
        
        // Present a confirmation dialog to logout
        let ac = UIAlertController(title: "Confirm Logout", message: "Are you sure you want to logout?", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
        ac.addAction(UIAlertAction(title: "Logout", style: .default, handler: { (action) in
            
            do {
                // Attempt to logout, may throw error
                try Auth.auth().signOut()
                
                // At this point, signOut() succeeded by not throwing any errors
                self.performSegue(withIdentifier: "SignIn", sender: self)
                print("TajKat:: Successfully logged out")
                
            } catch let error as NSError {
                print("TajKat:: \(error.localizedDescription)")
            }
        }))
        
        // Present the alert
        self.present(ac, animated: true, completion: nil)
    }
    
    // ==========================================
    // ==========================================
    
}


// MARK: Image Picker Delegate Methods
extension SettingsViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    // TODO: In future update, refactor
    /** Called when media has been selected by the user in the image picker. */
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        // Immediately dismiss for responsiveness
        dismiss(animated: true)
        
        let uid = UserState.currentUser.uid
        let path = "displayPictures/\(uid)/\(uid).JPG"
        
        // Extract the image after editing, upload to database as Data object
        if let image = info[UIImagePickerControllerEditedImage] as? UIImage {
            if let data = convertImageToData(image: image) {
                
                databaseManager.uploadImage(data: data, to: path, completion: { (error) in
                    if let error = error {
                        print("TajKat:: Error uploading display picture to Firebase. \(error.localizedDescription)")
                        return
                    }
                    
                    self.updateUserDisplayPicture()
                })
                
            } else { print("TajKat:: Error extracting image from camera source") }
        } else { print("TajKat:: Error extracting edited UIImage from info dictionary") }
    }
    
    // ==========================================
    // ==========================================
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        dismiss(animated: true)
    }
}




