//
//  NewConversationViewController.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 25/10/2563 BE.
//

import UIKit
import JGProgressHUD
import FirebaseDatabase
import FirebaseAuth

class NewConversationViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = result[indexPath.row]["first"]! + " " + result[indexPath.row]["last"]!
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetUserData = result[indexPath.row]
        
        dismiss(animated: true, completion: { [weak self] in
            self?.completion?(targetUserData)
        })
    }
    
    public var completion: (([String: String]) -> (Void))?
    
    private let spinner = JGProgressHUD(style: .dark)
    private var hashFetched = false
    private var users = [[String:String]]()
    private var result = [[String:String]]()
    
    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "Search ID"
        return searchBar
    }()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(UITableViewCell.self, forCellReuseIdentifier: "cell")
        table.isHidden = true
        return table
    }()
    
    private let noResultLabel: UILabel = {
        let label = UILabel()
        label.text = "No result"
        label.textAlignment = .center
        label.textColor = .black
        label.font = .systemFont(ofSize: 21, weight: .medium)
        label.isHidden = false
        return label
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(tableView)
        view.addSubview(noResultLabel)
        tableView.delegate = self
        tableView.dataSource = self
        searchBar.delegate = self
        navigationController?.navigationBar.topItem?.titleView = searchBar
        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Cancel",
                                                            style: .done,
                                                            target: self,
                                                            action: #selector(dismissSelf))
        searchBar.becomeFirstResponder()
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.frame.width/4, y: (view.frame.width - 200)/2, width: view.frame.width/2, height: 200)
    }

    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
}

extension NewConversationViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.replacingOccurrences(of: " ", with: ""),!text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        searchBar.resignFirstResponder()
        
        result.removeAll()
        spinner.show(in: view)
        self.searchUser(query: text)
        
    }
    
    func searchUser(query: String) {
        if hashFetched {
            filterUser(with: query)
        }
        else {
            DatabaseManager.shared.getAllUser(completion: {[weak self] result in
                switch result {
                case.success(let userCollection):
                    self?.hashFetched = true
                    self?.users = userCollection
                    self?.filterUser(with: query)
                case.failure(let error):
                    print("Fail to get user \(error)")
                }
            })
        }
    }
    
    func filterUser(with term: String) {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String, hashFetched else {
            return
        }
        let safeEmail = DatabaseManager.dbEmail(emailAdress: currentUserEmail)
        self.spinner.dismiss()
        let result: [[String:String]] = self.users.filter({
            guard let email = $0["email"], email != safeEmail else { return false }
            guard let first = $0["first"]?.lowercased() as? String else { return false }
            return first.hasPrefix(term.lowercased())
        })
        self.result = result
        updateUI()
    }
    
    func updateUI() {
        if result.isEmpty {
            tableView.isHidden = true
            noResultLabel.isHidden = false
        }
        else {
            noResultLabel.isHidden = true
            tableView.isHidden = false
            tableView.reloadData()
        }
    }
}
