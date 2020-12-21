//
//  SearchViewController.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 12/11/2563 BE.
//

import UIKit
import JGProgressHUD
import FirebaseDatabase
import FirebaseAuth

class SearchViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return result.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.adjustsFontSizeToFitWidth = true
        
        var txt = ""
        if result[indexPath.row]["tag4"] == "" {
            txt = "[\(result[indexPath.row]["id"]!)] " + result[indexPath.row]["type"]! + " " + result[indexPath.row]["name"]!
        }
        else {
            txt = "[\(result[indexPath.row]["id"]!)] " + result[indexPath.row]["type"]! + " " + result[indexPath.row]["name"]! + " " + "(\(result[indexPath.row]["tag4"]!))"
        }
        
        cell.textLabel?.text = txt
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        let targetAnnotation = result[indexPath.row]
        var strAnnotationID = targetAnnotation["id"]
        UserDefaults.standard.removeObject(forKey: "AnnotationID")
        UserDefaults.standard.setValue(strAnnotationID, forKey: "AnnotationID")
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let vc = storyboard.instantiateViewController(identifier: "Navigation")
        (UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate)?.changeRootViewController(vc)
    }
    
    private let spinner = JGProgressHUD(style: .dark)
    private var hashFetched = false
    private var annotation = [[String:String]]()
    private var result = [[String:String]]()
    private var result1 = [[String:String]]()

    private let searchBar: UISearchBar = {
        let searchBar = UISearchBar()
        searchBar.placeholder = "ค้นหาสถานที่"
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
        // Do any additional setup after loading the view.
    }
    
    @objc private func dismissSelf() {
        dismiss(animated: true, completion: nil)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        tableView.frame = view.bounds
        noResultLabel.frame = CGRect(x: view.frame.width/4, y: (view.frame.width - 200)/2, width: view.frame.width/2, height: 200)
    }
    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}

extension SearchViewController: UISearchBarDelegate {
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        guard let text = searchBar.text?.replacingOccurrences(of: " ", with: ""),!text.replacingOccurrences(of: " ", with: "").isEmpty else { return }
        searchBar.resignFirstResponder()
        
        result.removeAll()
        spinner.show(in: view)
        self.searchAnnotation(query: text)
        
    }
    
    func searchAnnotation(query: String) {
        if hashFetched {
            filterbyName(with: query)
        }
        else {
            DatabaseManager.shared.getAllAnnotation(completion: {[weak self] result in
                switch result {
                case.success(let userCollection):
                    self?.hashFetched = true
                    self?.annotation = userCollection
                    self?.filterbyName(with: query)
                case.failure(let error):
                    print("Fail to get annotation \(error)")
                }
            })
        }
    }

    func filterbyName(with term: String) {
        guard hashFetched else {
            return
        }
        self.spinner.dismiss()
        let result: [[String:String]] = self.annotation.filter({
            guard let name = $0["name"]?.lowercased() as? String else { return false }
            guard let tag1 = $0["tag1"]?.lowercased() as? String else { return false }
            guard let tag2 = $0["tag2"]?.lowercased() as? String else { return false }
            guard let tag3 = $0["tag3"]?.lowercased() as? String else { return false }
            guard let tag4 = $0["tag4"]?.lowercased() as? String else { return false }
            guard let type = $0["type"]?.lowercased() as? String else { return false }
            guard let id = $0["id"]?.lowercased() as? String else { return false }
            if name.hasPrefix(term.lowercased()) == true {
                return true
            }
            else if tag1.hasPrefix(term.lowercased()) == true {
                return true
            }
            else if tag2.hasPrefix(term.lowercased()) == true {
                return true
            }
            else if tag3.hasPrefix(term.lowercased()) == true {
                return true
            }
            else if tag4.hasPrefix(term.lowercased()) == true {
                return true
            }
            else if type.hasPrefix(term.lowercased()) == true {
                return true
            }
            else if id.hasPrefix(term.lowercased()) == true {
                return true
            }
            return false
        })
        self.result = result
        print(result)
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

