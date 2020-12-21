//
//  RegisterViewController.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 30/9/2563 BE.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

class RegisterViewController: UIViewController {
    
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
    
    private let firstNameField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
//        field.placeholder = "first name..."
        field.attributedPlaceholder = NSAttributedString(string: "first name...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let lastNameField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
//        field.placeholder = "last name..."
        field.attributedPlaceholder = NSAttributedString(string: "last name...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
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
//        field.placeholder = "password..."
        field.attributedPlaceholder = NSAttributedString(string: "password...", attributes: [NSAttributedString.Key.foregroundColor: UIColor.lightGray])
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isSecureTextEntry = true
        return field
    }()
    
    private let registerButton: UIButton = {
        let button = UIButton()
        button.setTitle("register", for: .normal)
        button.backgroundColor = .systemGreen
        button.setTitleColor(.white, for: .normal)
        button.layer.cornerRadius = 8
        button.layer.masksToBounds = true
        button.titleLabel?.font = .systemFont(ofSize: 20, weight: .semibold)
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Create Account"
        view.backgroundColor = UIColor.white
        
        registerButton.addTarget(self, action: #selector(registerButtonTapped), for: .touchUpInside)
        
        emailField.delegate = self
        passwordField.delegate = self
        
        // add subview
        view.addSubview(scrollView)
        scrollView.addSubview(imageView)
        scrollView.addSubview(firstNameField)
        scrollView.addSubview(lastNameField)
        scrollView.addSubview(emailField)
        scrollView.addSubview(passwordField)
        scrollView.addSubview(registerButton)
        
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
        
        firstNameField.frame = CGRect(x: scrollView.frame.size.width * 0.1,
                                      y: imageView.frame.origin.y + size + scrollView.frame.size.height * 0.05,
                                      width: scrollView.frame.size.width * 0.8,
                                      height: scrollView.frame.size.height / 20)
        
        lastNameField.frame = CGRect(x: scrollView.frame.size.width * 0.1,
                                     y: firstNameField.frame.origin.y + firstNameField.frame.size.height + scrollView.frame.size.height * 0.025,
                                     width: scrollView.frame.size.width * 0.8,
                                     height: scrollView.frame.size.height / 20)
        
        emailField.frame = CGRect(x: scrollView.frame.size.width * 0.1,
                                  y: lastNameField.frame.origin.y + lastNameField.frame.size.height + scrollView.frame.size.height * 0.025,
                                  width: scrollView.frame.size.width * 0.8,
                                  height: scrollView.frame.size.height / 20)
        
        passwordField.frame = CGRect(x: scrollView.frame.size.width * 0.1,
                                     y: emailField.frame.origin.y + emailField.frame.size.height + scrollView.frame.size.height * 0.025,
                                     width: scrollView.frame.size.width * 0.8,
                                     height: scrollView.frame.size.height / 20)
        
        registerButton.frame = CGRect(x: scrollView.frame.size.width * 0.1,
                                      y: passwordField.frame.origin.y + passwordField.frame.size.height + scrollView.frame.size.height * 0.05,
                                      width: scrollView.frame.size.width * 0.8,
                                      height: scrollView.frame.size.height / 20)
    }
    
    @objc func registerButtonTapped() {
        
        firstNameField.resignFirstResponder()
        lastNameField.resignFirstResponder()
        emailField.resignFirstResponder()
        passwordField.resignFirstResponder()
        
        guard let firstName = firstNameField.text,
              let lastName = lastNameField.text,
              let email = emailField.text,
              let password = passwordField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty,
              !password.isEmpty else {
            alertInformationError()
            return
        }
        
        guard email.isValidEmail() else {
            alertEmailError()
            return
        }
        
        guard password.count >= 6 else {
            alertPasswordError()
            return
        }
        
        spinner.show(in: view)
        
        // register firebase
        FirebaseAuth.Auth.auth().createUser(withEmail: email, password: password, completion: { authResult, error in
            guard authResult != nil, error == nil else {
                print("fail to create user in database")
                DispatchQueue.main.async {
                    self.spinner.dismiss()
                }
                self.alertAlreadyExistError()
                return
            }
            DispatchQueue.main.async {
                self.spinner.dismiss()
            }
            
            // store data
            let firstNameNospace = firstName.replacingOccurrences(of: " ", with: "")
            let lastNameNospace = lastName.replacingOccurrences(of: " ", with: "")
            let userinfo = UserInfo(firstName: firstNameNospace, lastName: lastNameNospace, emailAdress: email)
            DatabaseManager.shared.insertUser(with: userinfo, completion: {sucess in 
                if sucess {
                    print("create user in database")
                }
                else {
                    print("fail to create user in database")
                }
            })
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
//            self.navigationController?.popViewController(animated: true)
        })
        
    }
    
    
    
    func alertInformationError() {
        let alert = UIAlertController(title: "Error!",
                                      message: "Please enter all information",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertEmailError() {
        let alert = UIAlertController(title: "Error!",
                                      message: "Email is invalid",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertPasswordError() {
        let alert = UIAlertController(title: "Error!",
                                      message: "Password must be at least 6 character",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertAlreadyExistError() {
        let alert = UIAlertController(title: "Error!",
                                      message: "Email is already exist",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }

}

extension String {
    func isValidEmail() -> Bool {
        // here, try! will always succeed because the pattern is valid
        let regex = try! NSRegularExpression(pattern: "[a-zA-Z0-9_-]+@[a-zA-Z0-9_-]+\\.[a-zA-Z]{2,64}", options: .caseInsensitive)
        return regex.firstMatch(in: self, options: [], range: NSRange(location: 0, length: count)) != nil
    }
}

extension RegisterViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        
        if textField == emailField {
            passwordField.becomeFirstResponder()
        }
        else if textField == passwordField {
            registerButtonTapped()
        }
        return true
    }
    
}
