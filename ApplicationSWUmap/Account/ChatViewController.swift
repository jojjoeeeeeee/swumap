//
//  ChatViewController.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 25/10/2563 BE.
//

import UIKit
import MessageKit
import InputBarAccessoryView

struct Message: MessageType {
    public var sender: SenderType
    public var messageId: String
    public var sentDate: Date
    public var kind: MessageKind
}

extension MessageKind {
    var messageKindString: String {
        switch self {
        
        case .text(_):
            return "text"
        case .attributedText(_):
            return "attributed_text"
        case .photo(_):
            return "photo"
        case .video(_):
            return "video"
        case .location(_):
            return "location"
        case .emoji(_):
            return "emoji"
        case .audio(_):
            return "audio"
        case .contact(_):
            return "contact"
        case .linkPreview(_):
            return "link_preview"
        case .custom(_):
            return "custom"
        }
    }
}

struct Sender: SenderType {
    public var senderId: String
    public var displayName: String
}

class ChatViewController: MessagesViewController {
    
    public static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .long
        formatter.locale = .current
        formatter.dateFormat = "MMM dd', 'yyyy' at 'HH:mm:ss O"
        return formatter
    }()
    
    public var isNewConversation = false
    public var conversationId: String?
    private let otherUserEmail: String
    private var messages = [Message]()
    private var selfSender: Sender? {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        let safeEmail = DatabaseManager.dbEmail(emailAdress: email)
        return Sender(senderId: safeEmail, displayName: "Me")
    }
    
    init(with email: String, id: String?) {
        self.otherUserEmail = email
        self.conversationId = id
        super.init(nibName: nil, bundle: nil)
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        
        /*
         messages.append(Message(sender: selfSender,
         messageId: "1",
         sentDate: Date(),
         kind: .text("Hello World Message!!")))
         */
        
        messagesCollectionView.messagesDataSource = self
        messagesCollectionView.messagesLayoutDelegate = self
        messagesCollectionView.messagesDisplayDelegate = self
        messageInputBar.delegate = self
        
//        self.navigationItem.hidesBackButton = true
//        let newBackButton = UIBarButtonItem(title: "Back", style: UIBarButtonItem.Style.plain, target: self, action: #selector(ConversationViewController.back(sender:)))
//        
//        self.navigationItem.leftBarButtonItem = newBackButton
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        messageInputBar.inputTextView.becomeFirstResponder()
        if let conversationId = conversationId {
            listenForMessages(id: conversationId, shouldScrollToBottom: true)
        }
    }
    
    
    
    private func listenForMessages(id: String, shouldScrollToBottom: Bool) {
        DatabaseManager.shared.getAllMessagesForConversation(with: id, completion: { [weak self] result in
            print("success to connect database")
            switch result {
            case.success(let messages):
                self?.isNewConversation = false
                guard !messages.isEmpty else {
                    return
                }
                print("\n\(messages)\n")
                self?.messages = messages
                DispatchQueue.main.async {
                    self?.messagesCollectionView.reloadData()
                    if shouldScrollToBottom {
                        self?.messagesCollectionView.scrollToBottom()
                    }
                    print("success to get message")
                }
            case.failure(let error):
                print("fail to get message \(error)")
            }
        })
    }
    
}

extension ChatViewController: InputBarAccessoryViewDelegate {
    
    func inputBar(_ inputBar: InputBarAccessoryView, didPressSendButtonWith text: String) {
        guard !text.replacingOccurrences(of: " ", with: "").isEmpty,
              let selfSender = self.selfSender,
              let messageId = createMessageID() else { return }
        
        print("sending...\(text)")
        print("Date########\n",Date())
        let message = Message(sender: selfSender,
                              messageId: messageId,
                              sentDate: Date(),
                              kind: .text(text))
        if isNewConversation {
            print("new conver create")
            self.messageInputBar.inputTextView.text = nil
            DatabaseManager.shared.createNewConversation(with: otherUserEmail, name: self.title ?? "User", firstMessage: message, completion: { [weak self] success in
                if success {
                    print("message sent")
                    let newConversationId = "conversation_\(message.messageId)"
                    self?.conversationId = newConversationId
                    self?.listenForMessages(id: newConversationId, shouldScrollToBottom: true)
                    self?.isNewConversation = false
                }
                else {
                    print("fail to sent")
                }
            })
        }
        else {
            guard let conversationId = conversationId, let name = self.title else { return }
            self.messageInputBar.inputTextView.text = nil
            DatabaseManager.shared.sendMessage(to: conversationId, otherUserEmail: otherUserEmail, name: name, newMessage: message, completion: { success in
                if success {
                    print("message sent")
                }
                else {
                    print("fail to sent")
                }
            })
        }
    }
    
    private func createMessageID() -> String? {
        guard let currentUserEmail = UserDefaults.standard.value(forKey: "email") as? String else { return nil }
        let safeCurrentEmail = DatabaseManager.dbEmail(emailAdress: currentUserEmail)
        let dateAsString = Self.dateFormatter.string(from: Date())
        print("create message id ^^^^^^^^^ \(dateAsString)")
        
//        let df = DateFormatter()
//        df.dateFormat = "MMM dd', 'yyyy' at 'hh:mm:ss a 'GMT+7'"
//        let date = df.date(from: dateAsString)
//        df.dateFormat = "MMM dd', 'yyyy' at 'HH:mm:ss 'GMT+7'"
//        let dateString = df.string(from: date!)//24 hours
        let newIdentifier = "\(otherUserEmail)_\(safeCurrentEmail)_\(dateAsString)"
        print("create messageID",newIdentifier)
        return newIdentifier
    }
}

extension ChatViewController: MessagesDataSource,MessagesLayoutDelegate,MessagesDisplayDelegate {
    
    func currentSender() -> SenderType {
        if let sender = selfSender { return sender }
        fatalError("selfSender is nil")
    }
    
    func messageForItem(at indexPath: IndexPath, in messagesCollectionView: MessagesCollectionView) -> MessageType {
        return messages[indexPath.section]
    }
    
    func numberOfSections(in messagesCollectionView: MessagesCollectionView) -> Int {
        return messages.count
    }
    
}
