//
//  RegisterViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 08/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  Register page
//  Handles keyboard events
//  Upon registration, this controller sends POST HTTP request to Livingston FC API and saves returned API key.
class RegisterViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        usernameLabel.layer.cornerRadius = 10
        emailLabel.layer.cornerRadius = 10
        passwordLabel.layer.cornerRadius = 10
        confirmPasswordLabel.layer.cornerRadius = 10
        signInButton.layer.cornerRadius = 10
        NotificationCenter.default.addObserver(self,
                                               selector: #selector(self.keyboardNotification(notification:)),
                                               name: NSNotification.Name.UIKeyboardWillChangeFrame,
                                               object: nil)
    }
    
    deinit {
        NotificationCenter.default.removeObserver(self)
    }
   
    
    @IBOutlet weak var keyboardHeightLayoutConstraint: NSLayoutConstraint!
    
    @objc func keyboardNotification(notification: NSNotification) {
        if let userInfo = notification.userInfo {
            let endFrame = (userInfo[UIKeyboardFrameEndUserInfoKey] as? NSValue)?.cgRectValue
            let endFrameY = endFrame?.origin.y ?? 0
            let duration:TimeInterval = (userInfo[UIKeyboardAnimationDurationUserInfoKey] as? NSNumber)?.doubleValue ?? 0
            let animationCurveRawNSN = userInfo[UIKeyboardAnimationCurveUserInfoKey] as? NSNumber
            let animationCurveRaw = animationCurveRawNSN?.uintValue ?? UIViewAnimationOptions.curveEaseInOut.rawValue
            let animationCurve:UIViewAnimationOptions = UIViewAnimationOptions(rawValue: animationCurveRaw)
            if endFrameY >= UIScreen.main.bounds.size.height {
                self.keyboardHeightLayoutConstraint?.constant = 80.0
            } else {
                self.keyboardHeightLayoutConstraint?.constant = endFrame?.size.height ?? 80.0
            }
            UIView.animate(withDuration: duration,
                           delay: TimeInterval(0),
                           options: animationCurve,
                           animations: { self.view.layoutIfNeeded() },
                           completion: nil)
        }
    }

    
    @IBOutlet weak var usernameLabel: UITextField!
    
    @IBOutlet weak var emailLabel: UITextField!
    
    @IBOutlet weak var passwordLabel: UITextField!
    
    @IBOutlet weak var confirmPasswordLabel: UITextField!
    @IBOutlet weak var partialMembershipSwitch: UISwitch!
    
    @IBOutlet weak var signInButton: UIButton!
    
    @IBAction func doSignIn(_ sender: Any) {
        let username = usernameLabel.text
        let password = passwordLabel.text
        let email = emailLabel.text
        let confirmPassword = confirmPasswordLabel.text
        let partialMembership = partialMembershipSwitch.isOn
        
        //  Validate user input
        if (username == "" || email == "" || password == "") {
            return
        }
        if (password != confirmPassword){
            let alert = UIAlertController(title: "Error", message: "The passwords you entered aren't the same.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            alert.view.tintColor = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
            self.show(alert, sender: nil)
            return
        }
        guard isValidEmail(testStr: email!) else {
            let alert = UIAlertController(title: "Invalid Email", message: "Please enter valid email address.", preferredStyle: .alert)
            alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
            alert.view.tintColor = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
            self.show(alert, sender: nil)
            return
        }
        signIn(username: username!, email: email!, password: password!, partialMembership: partialMembership)
    }
    
    private func signIn(username: String, email: String, password: String, partialMembership: Bool){
        var params = [String:String]()
        params["username"] = username
        params["email"] = email
        params["password"] = password
        params["partial_membership"] = partialMembership ? "true" : "false"
        
        LivingstonFCAPIManager.sharedInstance.register(params: params, onSuccess: { apiKey in
            DispatchQueue.main.async {
                UserDefaultsManager.addApiKey(apiKey)
                Switcher.updateRootVC()
            }
        }, onFailure: { [weak self] error in
            DispatchQueue.main.async {
                var errorMsg = error.localizedDescription
                if let error = error as? ErrorResponse {
                    switch error {
                    case .internalServerError:
                        errorMsg = "There is something wrong on our side. Please try again later."
                    case .unauthorized:
                        errorMsg = "The username/email address or password is invalid."
                    case .unprocessableEntity:
                        errorMsg = "Could not process your request."
                    case .connectionFailed:
                        errorMsg = "It appears you are offline. Connect to internet to log in."
                    case .invalidRequest:
                        errorMsg = "Invalid Request"
                    }
                }
                let alert = UIAlertController(title: "Could Not Connect", message: errorMsg, preferredStyle: .alert)
                alert.addAction(UIAlertAction(title: "Okay", style: .default, handler: nil))
                alert.view.tintColor = UIColor(red: 237/255, green: 116/255, blue: 47/255, alpha: 1)
                self?.show(alert, sender: nil)
            }
        })
    }
    
    @IBAction func goToLogin(_ sender: Any) {
        self.performSegue(withIdentifier: "login", sender: self)
    }
    
    //  Validate if email entered has correct format
    func isValidEmail(testStr:String) -> Bool {
        let emailRegEx = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        
        let emailTest = NSPredicate(format:"SELF MATCHES %@", emailRegEx)
        return emailTest.evaluate(with: testStr)
    }
}
