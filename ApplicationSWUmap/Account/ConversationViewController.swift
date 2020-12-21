//
//  ConversationViewController.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 24/10/2563 BE.
//

import UIKit
import FirebaseAuth
import JGProgressHUD

struct Conversation {
    let id: String
    let name: String
    let otherUserEmail: String
    let latestMessage: LatestMessage
}

struct LatestMessage {
    let date: String
    let text: String
    let isRead: Bool
}

class ConversationViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    private let spinner = JGProgressHUD(style: .dark)
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return conversations.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let model = conversations[indexPath.row]
        let cell = tableView.dequeueReusableCell(withIdentifier: ConversationTableViewCell.identifier, for: indexPath) as! ConversationTableViewCell
        cell.configure(with: model)
        return cell
    }

    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)

        let model = conversations[indexPath.row]
        openConversation(model)
    }
    
    func openConversation(_ model: Conversation) {
        let vc = ChatViewController(with: model.otherUserEmail, id: model.id)
        vc.title = model.name
        vc.navigationItem.largeTitleDisplayMode = .never
        navigationController?.pushViewController(vc, animated: true)
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 70
    }
    
    func tableView(_ tableView: UITableView, editingStyleForRowAt indexPath: IndexPath) -> UITableViewCell.EditingStyle {
        return .delete
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // begin delete
            let conversationId = conversations[indexPath.row].id
            tableView.beginUpdates()
            self.conversations.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .left)
            DatabaseManager.shared.deleteConversation(conversationId: conversationId, completion: { [weak self] success in
                if success {
                    self?.startListeingForConversations()
                }
            })
            DispatchQueue.main.async {
                tableView.reloadData()
            }
            tableView.endUpdates()
        }
    }
    
    private var conversations = [Conversation]()
    
    private let tableView: UITableView = {
        let table = UITableView()
        table.register(ConversationTableViewCell.self, forCellReuseIdentifier: ConversationTableViewCell.identifier)
        return table
    }()
    
    private let txtLabel: UILabel = {
        let txtLabel = UILabel()
        txtLabel.textColor = .black
        txtLabel.textAlignment = .left
        txtLabel.font = UIFont.boldSystemFont(ofSize: 36)
        txtLabel.text = "Chat"
        return txtLabel
    }()
    
    private let scrollView: UIScrollView = {
        let scrollView = UIScrollView()
        scrollView.clipsToBounds = true
        return scrollView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpTableView()
        view.backgroundColor = UIColor.white
        view.addSubview(scrollView)
        scrollView.addSubview(txtLabel)
        scrollView.addSubview(tableView)
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .compose,
                                                            target: self,
                                                            action: #selector(didTapComposeButton))
        fetchConversations()
        startListeingForConversations()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        startListeingForConversations()
    }
    
//    @objc func back(sender: UIBarButtonItem) {
//        // Perform your custom actions
//        // ...
//        // Go back to the previous ViewController
//        self.navigationController?.popViewController(animated: true)
//        startListeingForConversations()
//    }
    
    private func startListeingForConversations() {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        var safeEmail = DatabaseManager.dbEmail(emailAdress: email)
        DatabaseManager.shared.getAllConversations(for: safeEmail, completion: { [weak self] result in
            switch result {
            case.success(let conversations):
                guard !conversations.isEmpty else { return }
                self?.conversations = conversations
                DispatchQueue.main.async {
                    self?.tableView.reloadData()
                }
                print("success to get conversation")
            case.failure(let error):
                print("fail to get conversation \(error)")
            }
        })
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        scrollView.frame = view.bounds
        
        txtLabel.frame = CGRect(x: scrollView.bounds.width * 0.045,
                                y: scrollView.bounds.width * 0.045,
                                width: 200,
                                height: 40)
        tableView.frame = CGRect(x: -10,
                                 y: scrollView.bounds.height * 0.05 + txtLabel.bounds.height,
                                 width: scrollView.frame.size.width,
                                 height: scrollView.frame.size.height)
    }
    
    private func setUpTableView() {
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    private func fetchConversations() {
        
    }
    
    @objc private func didTapComposeButton() {
        let vc = NewConversationViewController()
        vc.completion = { [weak self] result in
            print(result)
            guard let strongSelf = self else { return }
            let currentConversations = strongSelf.conversations
            if let targetConversation = currentConversations.first(where: {
                $0.otherUserEmail == DatabaseManager.dbEmail(emailAdress: result["email"]!)
            }) {
                let vc = ChatViewController(with: targetConversation.otherUserEmail, id: targetConversation.id)
                vc.isNewConversation = true
                vc.title = targetConversation.name
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
            else {
                strongSelf.createNewConversation(result: result)
            }
        }
        let navvc = UINavigationController(rootViewController: vc)
        present(navvc, animated: true, completion: nil)
    }
    
    private func createNewConversation(result: [String: String]) {
        guard let first = result["first"], let last = result["last"] , let email = result["email"] else { return }
        let safeEmail = DatabaseManager.dbEmail(emailAdress: email)
        // check in database if conversation with these two user exists
        // if it does reuse conversationId
        // otherwise user existing code
        DatabaseManager.shared.conversationExist(with: safeEmail, completion: { [weak self] result in
            guard let strongSelf = self else { return }
            switch result {
            case.success(let conversationId):
                let vc = ChatViewController(with: email, id: conversationId)
                vc.isNewConversation = false
                vc.title = first + " " + last
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            case.failure(_):
                let vc = ChatViewController(with: email, id: nil)
                vc.isNewConversation = true
                vc.title = first + " " + last
                vc.navigationItem.largeTitleDisplayMode = .never
                strongSelf.navigationController?.pushViewController(vc, animated: true)
            }
        })
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
