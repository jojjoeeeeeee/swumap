//
//  LoginViewController.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 30/9/2563 BE.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class LoginViewController: UIViewController {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    private let imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.image         = UIImage.init(systemName: "person.crop.circle")
        imageView.tintColor     = .gray
        imageView.contentMode   = .scaleAspectFit
        return imageView
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
//        field.placeholder = "email address..."
        field.attributedPlaceholder = NSAttributedString(string: "email address...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let passwordField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .done
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.placeholder = "password..."
        field.attributedPlaceholder = NSAttributedString(string: "password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let loginButton: UIButton = {
        let button = UIButton()
        button.setTitle("login", for: .normal)
        button.backgroundColor = .link
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Login"
        view.backgroundColor = UIColor.white
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Register",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(didTapRegister))
        
        loginButton.addTarget(self, action: #selector(loginButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        // add subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(loginButton)
        
        // Do any additional setup after loading the view.
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        let size = scrollView.frame.size.width / 3
        imageView.frame = CGRect(x: (scrollView.frame.size.width - size) / 2,
                                 y: 20,
                                 width: size,
                                 height: size)
        
        emailField.frame = CGRect(x: scrollView.frame.size.width * 0.1,
                                  y: imageView.frame.origin.y + size + scrollView.frame.size.height * 0.025,
                                  width: scrollView.frame.size.width * 0.8,
                                  height: scrollView.frame.size.height / 20)
        
        passwordField.frame = CGRect(x: scrollView.frame.size.width * 0.1,
                                     y: emailField.frame.origin.y + emailField.frame.size.height + scrollView.frame.size.height * 0.025,
                                     width: scrollView.frame.size.width * 0.8,
                                     height: scrollView.frame.size.height / 20)
        
        loginButton.frame = CGRect(x: scrollView.frame.size.width * 0.1,
                                   y: passwordField.frame.origin.y + passwordField.frame.size.height + scrollView.frame.size.height * 0.05,
                                   width: scrollView.frame.size.width * 0.8,
                                   height: scrollView.frame.size.height / 20)
    }
    
    @objc func loginButtonTapped() {
        spinner.show(in: view)
        
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let email = emailField.text,
              let password = passwordField.text,
              !email.isEmpty,
              !password.isEmpty else {
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            alertUserLoginError()
            return
        }
        
        guard email.isValidEmail() else {
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            alertDontMatchError()
            return
        }
        
        
        // sign in
        FirebaseAuth.Auth.auth().signIn(withEmail: email, password: password, completion: { authResult, error in
            guard let result = authResult,error == nil else {
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                self.alertDontMatchError()
                return
            }
            
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            let user = result.user
            print("is login user \(user)")
            let safeEmail = DatabaseManager.dbEmail(emailAdress: email)
            DatabaseManager.shared.getDataFor(path: safeEmail, completion: { result in
                switch result {
                case.success(let data):
                    guard let userData = data as? [String: Any],
                        let firstName = userData["first_name"] as? String,
                        let lastName = userData["last_name"] as? String else { return }
                    UserDefaults.standard.removeObject(forKey: "name")
                    UserDefaults.standard.set("\(firstName) \(lastName)", forKey: "name")
                case.failure(let error):
                    print("fail to read data with error \(error)")
                }
            })
            
            UserDefaults.standard.removeObject(forKey: "email")
            UserDefaults.standard.setValue(email, forKey: "email")
            let storyboard = UIStoryboard(name: "Main", bundle: nil)
            let vc = storyboard.instantiateViewController(identifier: "Navigation")
            (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
        })
    }
    
    func alertUserLoginError() {
        let alert = UIAlertController(title: "Error!",
                                      message: "Please enter email and password",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertDontMatchError() {
        let alert = UIAlertController(title: "Please try again",
                                      message: "The email or password you enter did not match",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
    @objc func didTapRegister(){
        let vc = RegisterViewController()
        vc.title = "Create Account"
        navigationController?.pushViewController(vc, animated: true)
    }

}

extension LoginViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            loginButtonTapped()
        }
        
        return true
    }
    
}

