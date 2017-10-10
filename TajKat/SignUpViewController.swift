//
//  SignUpViewController.swift
//  TajKat
//
//  Created by Admin on 7/7/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import UIKit
import Firebase
import FirebaseAuth
import FirebaseDatabase
class SignUpViewController: UIViewController, UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    var imagePicker: UIImagePickerController!

    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var fullname: UITextField!
    @IBOutlet weak var userPhoto: UIImageView!
    @IBOutlet weak var email: UITextField!
    @IBOutlet weak var password: UITextField!
 

    override func viewDidLoad() {
        super.viewDidLoad()
        imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        let tapGestureRecognizer = UITapGestureRecognizer(target:self, action:#selector(imageTapped(img:)))
        
        userPhoto.isUserInteractionEnabled = true
        userPhoto.addGestureRecognizer(tapGestureRecognizer)
        NotificationCenter.default.addObserver(self, selector: #selector(showingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    
  
    
    //Image Upload
    func imageTapped(img: AnyObject)
    {
        print("Image tapped")
        imagePicker.allowsEditing = false
        imagePicker.sourceType = .photoLibrary
        imagePicker.mediaTypes = UIImagePickerController.availableMediaTypes(for: .photoLibrary)!
        present(imagePicker, animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any])
    {
        let chosenImage = info[UIImagePickerControllerOriginalImage] as! UIImage
        self.userPhoto.contentMode = .scaleAspectFit
        self.userPhoto.image = chosenImage
        dismiss(animated:true, completion: nil)
    }
    
    func imagePickerControllerDidCancel(_ imagePicker: UIImagePickerController) {
        dismiss(animated: true, completion: nil)
    }

    @IBAction func addPicBtnPressed(_ sender: AnyObject) {
        present(imagePicker, animated: true, completion: nil)
    }
    
 
    @IBAction func signUp(_ sender: Any) {
        
//        let controller = storyboard?.instantiateViewController(withIdentifier: "SignUpSuccessSegue") as! UserSetupViewController
//        self.navigationController?.show(controller, sender: nil)
        
        guard let email = email.text, let password = password.text, let fullname = fullname.text else{return}
       
        Auth.auth().createUser(withEmail: email, password: password) { [weak self] (user, error) in
            guard let uid = user?.uid else {
                return
            }
            if let error = error {
                self?.alert(message: error.localizedDescription)
                return
            }
            if error != nil {
                print(error!)
            } else {
                
                let imageName = NSUUID().uuidString
                let storageRef = Storage.storage().reference().child("displayPictures").child("\(imageName).jpg")
                
                if let profileImage = self?.userPhoto.image , let uploadData = UIImageJPEGRepresentation(profileImage, 0.1) {
                    
                    storageRef.putData(uploadData, metadata: nil, completion: { (metaData, Error) in
                        if error != nil {
                            print(error!)
                            return
                        }
                        print(metaData!)
                        if let profileImageUrl = metaData?.downloadURL()?.absoluteString {
                            let values = ["name":fullname, "email":email, "displayPictures":profileImageUrl]
                            self?.registerUserIntoDataBase(uid, values: values as [String : AnyObject])
                        }
                    })

            
            
                    Database.database().reference().child("Users").child(user!.uid).updateChildValues(["email": email, "name": fullname, "status": FirechatDefaultStatus])
            print("success")

            let changeRequest = user!.createProfileChangeRequest()
            changeRequest.displayName = fullname
            changeRequest.commitChanges(completion: nil)
            print("signup successful")
                    
            
//            Auth.auth().signIn(withEmail: email, password: password) {
//                (user, error) in
//                if let user = Auth.auth().currentUser {
//                    if !user.isEmailVerified{
//                        let alertVC = UIAlertController(title: "Verify Email", message: "Your email address has to be verified before signing in. Verify your account and signin.", preferredStyle: .alert)
//                        let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
//                            (_) in
//                            user.sendEmailVerification(completion: nil)
//                        }
//                        let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)
//                        
//                        alertVC.addAction(alertActionOkay)
//                        alertVC.addAction(alertActionCancel)
//                        self?.present(alertVC, animated: true, completion: nil)
//                    } else {
//                        print ("Email verified. Signing in...")
//                    }
//                }
//            }

            
//            let table =  self?.storyboard?.instantiateViewController(withIdentifier: "table") as! MessagesTableViewController
//            self?.navigationController?.show(table, sender: nil)
    }
        
            }}}
//    @IBAction func back(_ sender: Any) {
//        self.dismiss(animated: true, completion: nil)
//    }
//   
    
    func registerUserIntoDataBase(_ uid: String, values: [String: AnyObject]) {
        
        
        let ref = Database.database().reference(fromURL: "https://tajkat-cd7c3.firebaseio.com/")
        let usersReference = ref.child("Users").child((uid))
        usersReference.updateChildValues(values as [AnyHashable: Any], withCompletionBlock: {
            (err,ref) in
            if err != nil {
                print(err!)
                return
            }
//            self.registerComplete.stopAnimating()
            print("Saved to Database")
//            self.registerComplete.hidden = true
//            self.goToProfile()
        })
    }
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }

    
    // MARK: Validation
    /** Determine if all text fields in the view controller are filled in. */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
