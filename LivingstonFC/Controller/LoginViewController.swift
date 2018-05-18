//
//  LoginViewController.swift
//  LivingstonFC
//
//  Created by Iza Ledzka on 08/05/2018.
//  Copyright © 2018 Iza Ledzka. All rights reserved.
//

import UIKit

//  Login view
class LoginViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        usernameTextField.layer.cornerRadius = 10
        passwordTextField.layer.cornerRadius = 10
        loginButton.layer.cornerRadius = 10
        hideKeyboardWhenTappedAround()
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

    @IBOutlet weak var usernameTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    @IBAction func loginButtonPressed(_ sender: Any) {
        
        let username = usernameTextField.text
        let password = passwordTextField.text
        
        if (username == "" || password == "") {
            return
        }
        
        doLogin(username: username!, password: password!)
    }
    
    private func doLogin(username: String, password: String){
        var params = [String:String]()
        params["username"] = username
        params["password"] = password
        LivingstonFCAPIManager.sharedInstance.login(params: params, onSuccess: { accessToken in
            DispatchQueue.main.async {
                UserDefaultsManager.addAccessToken(accessToken)
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
                    
                    let alert = CustomAlert.unsuccessfulLogin(errorMsg)
                    self?.present(alert, animated: true, completion: nil)
                }
        })
        dismissKeyboard()
    }
    
    // MARK: - Navigation
    
    @IBAction func goToRegisterPage(_ sender: Any) {
        self.performSegue(withIdentifier: "register", sender: self)
    }

}

extension UIViewController {
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
        
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
}
