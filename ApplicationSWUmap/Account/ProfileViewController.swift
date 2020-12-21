//
//  ProfileViewController.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 25/10/2563 BE.
//

import UIKit
import FirebaseAuth
import FirebaseDatabase

class ProfileViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    private var users = [[String:String]]()
    private var hashFetched = false
    private var resultUID = [[String:String]]()
    private var resultArr = [String]()
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return resultUID.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = "\(resultUID[indexPath.row]["first"]!) " + "\(resultUID[indexPath.row]["last"]!) " + "\(resultUID[indexPath.row]["uid"]!) " + "\(resultUID[indexPath.row]["email"]!)"
        resultArr = (cell.textLabel?.text?.components(separatedBy: " "))!
        print(resultArr)
        firstnameField.text = resultArr[0]
        lastnameField.text = resultArr[1]
        //        var tempEmail:String = resultArr[3]
        //        var count = 0
        //        var index = tempEmail.lastIndex(of: "-")!
        //        for _ in 0..<resultArr[3].count {
        //            if tempEmail.lastIndex(of: "-") != nil {
        //                index = tempEmail.lastIndex(of: "-")!
        //            }
        //            if count == 0{
        //                tempEmail.remove(at: index)
        //                tempEmail.insert(".", at: index)
        //            }
        //            else if count == 1{
        //                tempEmail.remove(at: index)
        //                tempEmail.insert("@", at: index)
        //            }
        //            count += 1
        //        }
        emailField.text = UserDefaults.standard.string(forKey: "email")
        return cell
    }
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    
    private let firstnameField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.text = ""
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let lastnameField: UITextField = {
        let field = UITextField()
        field.textColor = .black
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.text = ""
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        return field
    }()
    
    private let emailField: UITextField = {
        let field = UITextField()
        field.autocapitalizationType = .none
        field.autocorrectionType = .no
        field.returnKeyType = .continue
        field.layer.cornerRadius = 8
        field.layer.borderWidth = 1
        field.layer.borderColor = UIColor.lightGray.cgColor
        field.text = ""
        field.textColor = .gray
        field.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 5, height: 0))
        field.leftViewMode = .always
        field.backgroundColor = .white
        field.isUserInteractionEnabled = false
        return field
    }()
    
    private let firstnameLabel: UILabel = {
        let txtLabel = UILabel()
        txtLabel.textColor = .black
        txtLabel.textAlignment = .left
        txtLabel.font = UIFont.systemFont(ofSize: 17)
        txtLabel.text = "Firstname"
        return txtLabel
    }()
    
    private let lastnameLabel: UILabel = {
        let txtLabel = UILabel()
        txtLabel.textColor = .black
        txtLabel.textAlignment = .left
        txtLabel.font = UIFont.systemFont(ofSize: 17)
        txtLabel.text = "Lastname"
        return txtLabel
    }()
    
    private let emailLabel: UILabel = {
        let txtLabel = UILabel()
        txtLabel.textColor = .black
        txtLabel.textAlignment = .left
        txtLabel.font = UIFont.systemFont(ofSize: 17)
        txtLabel.text = "Email"
        return txtLabel
    }()
    
    private let saveButton: UIButton = {
        let button = UIButton()
        button.backgroundColor = .systemGreen
        button.layer.cornerRadius = 8
        button.setTitle("save changes", for: .normal)
        button.addTarget(self, action: #selector(didTapSaveButton), for: .touchUpInside)
        return button
    }()
    
    private let lineView: UIView = {
        let line = UIView()
        line.clipsToBounds = true
        line.backgroundColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        return line
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(firstnameField)
        view.addSubview(lastnameField)
        view.addSubview(emailField)
        view.addSubview(saveButton)
        view.addSubview(firstnameLabel)
        view.addSubview(lastnameLabel)
        view.addSubview(emailLabel)
        view.addSubview(lineView)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        loadUserData()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds

        firstnameLabel.frame = CGRect(x: view.frame.size.width * 0.05,
                                      y: 130,
                                      width: view.frame.size.width * 0.25,
                                      height: view.bounds.height / 20)
        
        firstnameField.frame = CGRect(x: firstnameLabel.frame.size.width + view.frame.size.width * 0.1,
                                      y: 130,
                                      width: view.frame.size.width * 0.6,
                                      height: view.bounds.height / 20)

        lastnameLabel.frame = CGRect(x: view.frame.size.width * 0.05,
                                     y: firstnameLabel.frame.origin.y + firstnameLabel.frame.size.height + view.frame.size.height * 0.025,
                                     width: view.frame.size.width * 0.25,
                                     height: view.bounds.height / 20)
        
        lastnameField.frame = CGRect(x: firstnameLabel.frame.size.width + view.frame.size.width * 0.1,
                                     y: firstnameField.frame.origin.y + firstnameField.frame.size.height + view.frame.size.height * 0.025,
                                     width: view.frame.size.width * 0.6,
                                     height: view.bounds.height / 20)
        
        emailLabel.frame = CGRect(x: view.frame.size.width * 0.05,
                                  y: lastnameField.frame.origin.y + lastnameField.frame.size.height + view.frame.size.height * 0.075,
                                  width: view.frame.size.width * 0.25,
                                  height: view.bounds.height / 20)
        
        emailField.frame = CGRect(x: firstnameLabel.frame.size.width + view.frame.size.width * 0.1,
                                  y: lastnameField.frame.origin.y + lastnameField.frame.size.height + view.frame.size.height * 0.075,
                                  width: view.frame.size.width * 0.6,
                                  height: view.bounds.height / 20)
        
        saveButton.frame = CGRect(x: view.frame.size.width * 0.6,
                                  y: emailField.frame.origin.y + emailField.frame.size.height + view.frame.size.height * 0.05,
                                  width: view.frame.size.width * 0.35,
                                  height: view.bounds.height / 20)
        
        lineView.frame = CGRect(x: view.frame.size.width * 0.05,
                                y: lastnameField.frame.origin.y + (0.75 * (emailField.frame.origin.y - lastnameField.frame.origin.y)),
                                width: view.frame.size.width * 0.9,
                                height: view.bounds.height / 448)
        
    }
    
    @objc func didTapSaveButton() {
        guard let firstName = firstnameField.text,
              let lastName = lastnameField.text,
              let email = emailField.text,
              !firstName.isEmpty,
              !lastName.isEmpty,
              !email.isEmpty else {
            alertInformationError()
            return
        }
        let firstNameNospace = firstName.replacingOccurrences(of: " ", with: "")
        let lastNameNospace = lastName.replacingOccurrences(of: " ", with: "")
        UserDefaults.standard.removeObject(forKey: "name")
        UserDefaults.standard.set("\(firstNameNospace) \(lastNameNospace)", forKey: "name")
        DatabaseManager.shared.userEditing(with: UserInfo(firstName: firstNameNospace, lastName: lastNameNospace, emailAdress: email))
        alertUpdateSuccessful()
    }
    
    func alertUpdateSuccessful() {
        let alert = UIAlertController(title: "Success!",
                                      message: "Your infomation was updated",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    func alertInformationError() {
        let alert = UIAlertController(title: "Error!",
                                      message: "Please enter firstname and lastname",
                                      preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "OK", style: .cancel, handler: nil))
        present(alert, animated: true)
    }
    
    
}

extension ProfileViewController {
    func loadUserData(){
        //        resultFirst.removeAll()
        //        resultLast.removeAll()
        //        resultUID.removeAll()
        self.loadAllUserData(uid: FirebaseAuth.Auth.auth().currentUser!.uid)
    }
    
    func loadAllUserData(uid: String){
        if hashFetched {
            filterUID(with: uid)
        }
        else {
            DatabaseManager.shared.getAllUser(completion: {[weak self] result in
                switch result {
                case.success(let userCollection):
                    self?.hashFetched = true
                    self?.users = userCollection
                    self?.filterUID(with: uid)
                case.failure(let error):
                    print("Fail to get user \(error)")
                }
            })
        }
    }
    
    func filterUID(with term: String) {
        guard hashFetched else {
            return
        }
        let resultUID: [[String:String]] = self.users.filter({
            guard let uid = $0["uid"] as? String else { return false }
            return uid.hasPrefix(term)
        })
        self.resultUID = resultUID
        updateField()
    }
    
    func updateField(){
        //        firstnameField.reloadInputViews()
        tableView.reloadData()
    }
    //    func filterUser(with term: String) {
    //        guard hashFetched else {
    //            return
    //        }
    //        let resultFirst: [[String:String]] = self.users.filter({
    //            guard let first = $0["first"]?.lowercased() as? String else { return false }
    //            return first.hasPrefix(term.lowercased())
    //        })
    //        let resultLast: [[String:String]] = self.users.filter({
    //            guard let last = $0["last"]?.lowercased() as? String else { return false }
    //            return last.hasPrefix(term.lowercased())
    //        })
    //        let resultUID: [[String:String]] = self.users.filter({
    //            guard let uid = $0["uid"]?.lowercased() as? String else { return false }
    //            return uid.hasPrefix(term.lowercased())
    //        })
    //        self.resultFirst = resultFirst
    //        self.resultLast = resultLast
    //        self.resultUID = resultUID
    //    }
    
}

