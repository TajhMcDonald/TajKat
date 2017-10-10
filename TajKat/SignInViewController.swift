//
//  SignInViewController.swift
//  TajKat
//
//  Created by Admin on 7/7/17.
//  Copyright © 2017 Adames-McDonald. All rights reserved.
//

import UIKit
import LocalAuthentication
import FirebaseAuth
import GoogleSignIn
class SignInViewController: UIViewController, GIDSignInUIDelegate {

    @IBOutlet weak var googleButton: UIButton!
    @IBOutlet weak var eMail: UITextField!
    @IBOutlet weak var passWord: UITextField!
    @IBOutlet weak var loader: UIActivityIndicatorView!

    override func viewDidLoad() {
        super.viewDidLoad()

        NotificationCenter.default.addObserver(self, selector: #selector(showingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillShowNotification"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(hidingKeyboard), name: NSNotification.Name(rawValue: "UIKeyboardWillHideNotification"), object: nil)
        
        let authenticationContext = LAContext()
        var error: NSError?
        if authenticationContext.canEvaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, error: &error){
        authenticationContext.evaluatePolicy(.deviceOwnerAuthenticationWithBiometrics, localizedReason: "Verify Identity", reply: { (success, error) in
            if success {
                print ("User Verified")
            } else {
                if let error = error {
                    print (error)
                } else {
                    print("Did not authenticate")
                }
            }
        })} else {
            print ("Device doesn't have touch-ID")
        }

    
}
    

    
    
    @IBAction func forgotPawword(_ sender: Any) {
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
    
    

    @IBAction func googleSignIn(_ sender: Any) {
        GIDSignIn.sharedInstance().uiDelegate = self
        GIDSignIn.sharedInstance().signIn()

        let table =  self.storyboard?.instantiateViewController(withIdentifier: "CreateAccountSuccessSegue") as! MessagesTableViewController
        self.navigationController?.show(table, sender: nil)
    }
    
    @IBAction func signIN(_ sender: Any) {
        self.loader.startAnimating()
        self.loader.isHidden = false
        guard let email = eMail.text, let password = passWord.text else{return}
        Auth.auth().signIn(withEmail: email, password: password) { [weak self]
            (user, error) in
            if let error = error{
                self?.loader.stopAnimating()
                self?.loader.isHidden = true
                self?.alert(message: error.localizedDescription)
                return
            }
            
            if let user = Auth.auth().currentUser {
                if !user.isEmailVerified{
                    let alertVC = UIAlertController(title: "Error", message: "Sorry. Your email address has not yet been verified. Do you want us to send another verification email to \((email)).", preferredStyle: .alert)
                    let alertActionOkay = UIAlertAction(title: "Okay", style: .default) {
                        (_) in
                        user.sendEmailVerification(completion: nil)
                    }
                    let alertActionCancel = UIAlertAction(title: "Cancel", style: .default, handler: nil)

                    alertVC.addAction(alertActionOkay)
                    alertVC.addAction(alertActionCancel)
                    self?.present(alertVC, animated: true, completion: nil)
                } else {
                    Auth.auth().signIn(withEmail: email, password: password){ [weak self] (user, error) in
                        if let error = error{
                            self?.alert(message: error.localizedDescription)
                            return
                        }

                    print ("Email verified. Signing in...")
                }
            }
        }
        
        
        print("successfully signed in!")
        self?.loader.stopAnimating()
        self?.loader.isHidden = true
        let table =  self?.storyboard?.instantiateViewController(withIdentifier: "CreateAccountSuccessSegue") as! MessagesTableViewController
        self?.navigationController?.show(table, sender: nil)
    }

    
            }


    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        self.view.endEditing(true)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
