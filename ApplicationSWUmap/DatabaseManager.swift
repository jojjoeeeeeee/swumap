//
//  DatabaseManager.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 25/10/2563 BE.
//

import Foundation
import FirebaseDatabase
import FirebaseAuth

struct UserInfo {
    let firstName: String
    let lastName: String
    let emailAdress: String
    
    var dbEmail: String {
        var dbEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        dbEmail = dbEmail.replacingOccurrences(of: "@", with: "-")
        dbEmail = dbEmail.lowercased()
        return dbEmail
    }
}

final class DatabaseManager {
    static let shared = DatabaseManager()
    private let database = Database.database().reference()

    static func dbEmail(emailAdress: String) -> String {
        var dbEmail = emailAdress.replacingOccurrences(of: ".", with: "-")
        dbEmail = dbEmail.replacingOccurrences(of: "@", with: "-")
        dbEmail = dbEmail.lowercased()
        return dbEmail
    }
    
    public enum DatabaseError: Error {
            case failedToFetch

            public var localizedDescription: String {
                switch self {
                case .failedToFetch:
                return "Database fetching failed"
            }
        }
    }
}

// add new user
extension DatabaseManager {
    func insertUser(with user: UserInfo, completion: @escaping (Bool) -> Void) {
        database.child(user.dbEmail).setValue([
            "first_name":user.firstName,
            "last_name":user.lastName
        ], withCompletionBlock: {error, _ in
            guard error == nil else {
                print("fail to write to Database")
                completion(false)
                return
            }
            self.database.child("users").observeSingleEvent(of: .value, with: { snapshot in
                if var userCollection = snapshot.value as? [[String:String]] {
                    let newElement = [
                        "first" : user.firstName,
                        "last" : user.lastName,
                        "email" : user.dbEmail,
                        "uid" : FirebaseAuth.Auth.auth().currentUser!.uid
                    ]
                    userCollection.append(newElement)
                    self.database.child("users").setValue(userCollection, withCompletionBlock: {error, _ in
                        guard error == nil else { return }
                        completion(true)
                    })
                }
                else {
                    let newCollection: [[String:String]] = [
                        [
                            "first" : user.firstName,
                            "last" : user.lastName,
                            "email" : user.dbEmail,
                            "uid" : FirebaseAuth.Auth.auth().currentUser!.uid
                        ]
                    ]
                    self.database.child("users").setValue(newCollection, withCompletionBlock: {error, _ in
                        guard error == nil else { return }
                        completion(true)
                    })
                }
            })
        })
    }
    
    func userEditing(with user: UserInfo) {
        
        database.child("users").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let snapkey = snap.key
                for grandchild in snap.children {
                    let snapg = grandchild as! DataSnapshot
                    let value = snapg.value
                    if value as! String == FirebaseAuth.Auth.auth().currentUser!.uid {
                        self?.database.child("users/\(snapkey)").updateChildValues([
                            "first" : user.firstName,
                            "last" : user.lastName
                        ])
                        break
                    }
                }
            }
        })
        
        database.child(user.dbEmail).updateChildValues([
            "first_name":user.firstName,
            "last_name":user.lastName
        ])
        
        database.child("\(user.dbEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            for child in snapshot.children {
                let snap = child as! DataSnapshot
                let snapkey = snap.key
                let snapvalue = snap.value
                for grandchild in snap.children {
                    let snapg = grandchild as! DataSnapshot
                    let key = snapg.key
                    let value = snapg.value
                    if key == "other_user_email" && value as! String != user.dbEmail {
                        self?.database.child("\(value!)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot3 in
                            for child3 in snapshot3.children {
                                let snap3 = child3 as! DataSnapshot
                                let snapkey3 = snap3.key
                                let snapvalue3 = snap3.value
                                for grandchild3 in snap3.children {
                                    let snapg3 = grandchild3 as! DataSnapshot
                                    let key3 = snapg3.key
                                    let value3 = snapg3.value
                                    if key3 == "other_user_email" && value3 as! String == user.dbEmail {
                                        self?.database.child("\(value!)/conversations/\(snapkey3)").updateChildValues([
                                            "name": user.firstName + " " + user.lastName
                                        ])
                                    }
                                }
                            }
                        })
                    }
                    if key == "id" {
                        self?.database.child("\(value!)/message").observeSingleEvent(of: .value, with: { [weak self] snapshot2 in
                            for child2 in snapshot2.children {
                                let snap2 = child2 as! DataSnapshot
                                let snapkey2 = snap2.key
                                let snapvalue2 = snap2.value
                                for grandchild2 in snap2.children {
                                    let snapg2 = grandchild2 as! DataSnapshot
                                    let key2 = snapg2.key
                                    let value2 = snapg2.value
                                    let str = value as! String
                                    let dateIndex = str.lastIndex(of: "_")
                                    if key2 == "id" && value2 as! String == "\(user.dbEmail)_\(user.dbEmail)\(str.suffix(from: dateIndex!))" {
                                        // edit in conversation
                                        self?.database.child("\(value!)/message/\(snapkey2)").updateChildValues([
                                            "name": user.firstName + " " + user.lastName
                                        ])
                                        // edit in user email conversation
                                        self?.database.child("\(user.dbEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot5 in
                                            for child5 in snapshot5.children {
                                                let snap5 = child5 as! DataSnapshot
                                                let snapkey5 = snap5.key
                                                let snapvalue5 = snap5.value
                                                for grandchild5 in snap5.children {
                                                    let snapg5 = grandchild5 as! DataSnapshot
                                                    let key5 = snapg5.key
                                                    let value5 = snapg5.value
                                                    if key5 == "other_user_email" && value5 as! String == user.dbEmail {
                                                        self?.database.child("\(user.dbEmail)/conversations/\(snapkey5)").updateChildValues([
                                                            "name": user.firstName + " " + user.lastName
                                                        ])
                                                    }
                                                }
                                            }
                                        })
                                    }
//                                    if key2 == "sender_email" && value2 as! String != user.dbEmail {
//                                        print("sender email condition")
//                                        let converID = "conversation_\(user.dbEmail)_\(value2!)\(str.suffix(from: dateIndex!))"
//                                        print(converID)
//                                        self?.database.child("\(converID)/message").observeSingleEvent(of: .value, with: { [weak self] snapshot4 in
//                                            for child4 in snapshot4.children {
//                                                let snap4 = child4 as! DataSnapshot
//                                                let snapkey4 = snap4.key
//                                                let snapvalue4 = snap4.value
//                                                for grandchild4 in snap4.children {
//                                                    let snapg4 = grandchild4 as! DataSnapshot
//                                                    let key4 = snapg4.key
//                                                    let value4 = snapg4.value
//                                                    let idIndex = converID.firstIndex(of: "_")
//                                                    var afterSuffix = converID.suffix(from: idIndex!)
//                                                    print(afterSuffix)
//                                                    if key4 == "id" && value4 as! String == "\(afterSuffix.dropFirst())" {
//                                                        self?.database.child("\(converID)/message/\(snapkey4)").updateChildValues([
//                                                            "name": user.firstName + " " + user.lastName
//                                                        ])
//                                                        print("\(value4!) svmaperiokmverjvemriov ")
//                                                    }
//                                                }
//                                            }
//                                        })
//                                    }
                                    
                                }
                            }
                        })
                    }
                }
            }
        })
    }
    
    func getAllUser(completion: @escaping(Result<[[String:String]], Error>) -> Void ) {
        Database.database().reference().child("users").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String:String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    func getDataFor(path: String, completion: @escaping(Result<Any,Error>) -> Void) {
        self.database.child("\(path)").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
    
    func getAllAnnotation(completion: @escaping(Result<[[String:String]], Error>) -> Void) {
        Database.database().reference().child("annotation").observeSingleEvent(of: .value, with: { snapshot in
            guard let value = snapshot.value as? [[String:String]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            completion(.success(value))
        })
    }
}

// MARK: - sending message
extension DatabaseManager {
    /// create a new conversation with target user email and first message
    public func createNewConversation(with otherUserEmail: String, name: String, firstMessage: Message, completion: @escaping(Bool) -> Void) {
        guard let currentEmail = UserDefaults.standard.value(forKey: "email") as? String, let currentName = UserDefaults.standard.value(forKey: "name") as? String else { return }
        let safeEmail = DatabaseManager.dbEmail(emailAdress: currentEmail)
        let ref = database.child("\(safeEmail)")
        ref.observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard var userNode = snapshot.value as? [String: Any] else {
                completion(false)
                print("user not found")
                return
            }
            let messageDate = firstMessage.sentDate
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            var message = ""
            switch firstMessage.kind {
            
            case .text(let messageText):
                message = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            let conversationID = "conversation_\(firstMessage.messageId)"
            let newConversationData: [String: Any] = [
                "id": conversationID,
                "other_user_email": otherUserEmail,
                "name": name,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            let recipient_newConversationData: [String: Any] = [
                "id": conversationID,
                "other_user_email": safeEmail,
                "name": currentName,
                "latest_message": [
                    "date": dateString,
                    "message": message,
                    "is_read": false
                ]
            ]
            // update recipient conversation entry
            self?.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { [weak self] snapshot in
                if var conversations = snapshot.value as? [[String: Any]] {
                    // append
                    conversations.append(recipient_newConversationData)
                    self?.database.child("\(otherUserEmail)/conversations").setValue(conversations)
                }
                else {
                    // create
                    self?.database.child("\(otherUserEmail)/conversations").setValue([
                        recipient_newConversationData
                    ])
                }
            })
            // update current user conversation entry
            if var conversations = userNode["conversations"] as? [[String: Any]] {      // conversation array already exists for current user (append)
                conversations.append(newConversationData)
                userNode["conversations"] = conversations
                ref.setValue(userNode, withCompletionBlock: { [weak self] error,_ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name, conversationID: conversationID, firstMessage: firstMessage, completion: completion)
                })
            }
            else {
                // conversation array doesn't exist (create)
                userNode["conversations"] = [
                    newConversationData
                ]
                ref.setValue(userNode, withCompletionBlock: { [weak self] error,_ in
                    guard error == nil else {
                        completion(false)
                        return
                    }
                    self?.finishCreatingConversation(name: name, conversationID: conversationID, firstMessage: firstMessage, completion: completion)
                })
            }
        })
    }
    private func finishCreatingConversation(name: String, conversationID: String, firstMessage: Message, completion: @escaping(Bool) -> Void) {
//        {
//            "id": String,
//            "type": text,
//            "content": String,
//            "date": Date(),
//            "sender_email": String,
//            "isRead": true/false,
//        }
        let messageDate = firstMessage.sentDate
        let dateString = ChatViewController.dateFormatter.string(from: messageDate)
        var messageRaw = ""
        switch firstMessage.kind {
        
        case .text(let messageText):
            messageRaw = messageText
        case .attributedText(_):
            break
        case .photo(_):
            break
        case .video(_):
            break
        case .location(_):
            break
        case .emoji(_):
            break
        case .audio(_):
            break
        case .contact(_):
            break
        case .linkPreview(_):
            break
        case .custom(_):
            break
        }
        
        guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
            completion(false)
            return
        }
        completion(true)
        let currentUserEmail = DatabaseManager.dbEmail(emailAdress: myEmail)
        let message: [String: Any] = [
            "id": firstMessage.messageId,
            "type": firstMessage.kind.messageKindString,
            "content": messageRaw,
            "date": dateString,
            "sender_email": currentUserEmail,
            "is_read": false,
            "name": name
        ]
        let value: [String: Any] = [
            "message": [message]
        ]
        database.child("\(conversationID)").setValue(value, withCompletionBlock: { error,_ in
            guard error == nil else {
                completion(false)
                return
            }
            completion(true)
        })
    }
    
    /// fertches and return all conversations for the user with passed in email
    public func getAllConversations(for email: String, completion: @escaping(Result<[Conversation],Error>) -> Void) {
        database.child("\(email)/conversations").observe(.value, with: { snapshot in
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            let conversations: [Conversation] = value.compactMap({ dictionary in
                guard let conversationId = dictionary["id"] as? String,
                      let name = dictionary["name"] as? String,
                      let otherUserEmail = dictionary["other_user_email"] as? String,
                      let latestMessage = dictionary["latest_message"] as? [String: Any],
                      let date = latestMessage["date"] as? String,
                      let message = latestMessage["message"] as? String,
                      let isRead = latestMessage["is_read"] as? Bool
                      else { return nil }
                let latestMessageObject = LatestMessage(date: date, text: message, isRead: isRead)
                return Conversation(id: conversationId, name: name, otherUserEmail: otherUserEmail, latestMessage: latestMessageObject)
            })
            completion(.success(conversations))
        })
    }
    
    /// get all message for a given conversation
    public func getAllMessagesForConversation(with id: String, completion: @escaping(Result<[Message],Error>) -> Void) {
        database.child("\(id)/message").observe(.value, with: { snapshot in
            print("conversation id ############ \(id)")
            guard let value = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            print("####### value \(value) #########")
            let messages: [Message] = value.compactMap({ dictionary in
                guard let name = dictionary["name"] as? String,
                      let isRead = dictionary["is_read"] as? Bool,
                      let messageID = dictionary["id"] as? String,
                      let content = dictionary["content"] as? String,
                      let senderEmail = dictionary["sender_email"] as? String,
                      let type = dictionary["type"] as? String,
                      let dateString = dictionary["date"] as? String,
                      let date = ChatViewController.dateFormatter.date(from: dateString)
                else {
                    print("#########fail to get compact map##########")
                    return nil
                }
                let sender = Sender(senderId: senderEmail, displayName: name)
                return Message(sender: sender, messageId: messageID, sentDate: date, kind: .text(content))
            })
//            for child in snapshot.children {
//
//            }
//            let sender = Sender(senderId: "email", displayName: "name")
//            let messages = Message(sender: sender, messageId: "messageID", sentDate: "date", kind: .text("content"))
            completion(.success(messages))
        })
    }
    
    /// send a message with target conversation and message
    public func sendMessage(to conversation: String, otherUserEmail: String, name: String, newMessage: Message, completion: @escaping(Bool) -> Void) {
        // add new message to conversations
        // update sender latest message
        // update recipient message
        
        database.child("\(conversation)/message").observeSingleEvent(of: .value, with: { [weak self] snapshot in
            guard let strongSelf = self else { return }
            guard var currentMessages = snapshot.value as? [[String: Any]] else {
                completion(false)
                return
            }
            let messageDate = newMessage.sentDate
            print("SEND MESSAGE %%%%%%%%%%%%%% \(messageDate)")
            let dateString = ChatViewController.dateFormatter.string(from: messageDate)
            var messageRaw = ""
            switch newMessage.kind {
            
            case .text(let messageText):
                messageRaw = messageText
            case .attributedText(_):
                break
            case .photo(_):
                break
            case .video(_):
                break
            case .location(_):
                break
            case .emoji(_):
                break
            case .audio(_):
                break
            case .contact(_):
                break
            case .linkPreview(_):
                break
            case .custom(_):
                break
            }
            
            guard let myEmail = UserDefaults.standard.value(forKey: "email") as? String else {
                completion(false)
                return
            }
            completion(true)
            let currentUserEmail = DatabaseManager.dbEmail(emailAdress: myEmail)
            let newMessageEntry: [String: Any] = [
                "id": newMessage.messageId,
                "type": newMessage.kind.messageKindString,
                "content": messageRaw,
                "date": dateString,
                "sender_email": currentUserEmail,
                "is_read": false,
                "name": name
            ]
            currentMessages.append(newMessageEntry)
            strongSelf.database.child("\(conversation)/message").setValue(currentMessages, withCompletionBlock: { error, _ in
                guard error == nil else {
                    completion(false)
                    return
                }
                strongSelf.database.child("\(currentUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                    guard var otherUserConversations = snapshot.value as? [[String: Any]] else {
                        completion(false)
                        return
                    }
                    let updateValue: [String: Any] = [
                        "date": dateString,
                        "is_read": false,
                        "message": messageRaw
                    ]
                    var targetConversation: [String: Any]?
                    var position = 0
                    for conversationsDictionary in otherUserConversations {
                        if let currentId = conversationsDictionary["id"] as? String, currentId == conversation {
                            targetConversation = conversationsDictionary
                            break
                        }
                        position += 1
                    }
                    targetConversation?["latest_message"] = updateValue
                    guard let finalConversation = targetConversation else {
                        completion(false)
                        return
                    }
                    otherUserConversations[position] = finalConversation
                    strongSelf.database.child("\(currentUserEmail)/conversations").setValue(otherUserConversations, withCompletionBlock: { error, _ in
                        guard error == nil else {
                            completion(false)
                            return
                        }
                        // update latest message for recipient user
                        strongSelf.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
                            guard var otherUserConversations = snapshot.value as? [[String: Any]] else {
                                completion(false)
                                return
                            }
                            let updateValue: [String: Any] = [
                                "date": dateString,
                                "is_read": false,
                                "message": messageRaw
                            ]
                            var targetConversation: [String: Any]?
                            var position = 0
                            for conversationsDictionary in otherUserConversations {
                                if let currentId = conversationsDictionary["id"] as? String, currentId == conversation {
                                    targetConversation = conversationsDictionary
                                    break
                                }
                                position += 1
                            }
                            targetConversation?["latest_message"] = updateValue
                            guard let finalConversation = targetConversation else {
                                completion(false)
                                return
                            }
                            otherUserConversations[position] = finalConversation
                            strongSelf.database.child("\(otherUserEmail)/conversations").setValue(otherUserConversations, withCompletionBlock: { error, _ in
                                guard error == nil else {
                                    completion(false)
                                    return
                                }
                                completion(true)
                            })
                        })
                    })
                })
            })
        })
    }
    
    public func deleteConversation(conversationId: String, completion: @escaping(Bool) -> Void) {
        guard let email = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeEmail = DatabaseManager.dbEmail(emailAdress: email)
        print("deleting conversation with id: \(conversationId)")
        // get all conversation for current user
        // delete conversation in collection with targetID
        // reset those conversations for the user in database
        let ref = database.child("\(safeEmail)/conversations")
        ref.observeSingleEvent(of: .value, with: { snapshot in
            if var conversations = snapshot.value as? [[String: Any]] {
                var positionToRemove = 0
                for conversation in conversations {
                    if let id = conversation["id"] as? String,
                        id == conversationId {
                        print("found conversation with id to delete")
                        if let otherUserEmail = conversation["other_user_email"] as? String {
                            print("get other user email from current id to delete")
                            self.database.child("\(otherUserEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot2 in
                                if var otherUserConversations = snapshot2.value as? [[String: Any]] {
                                    var otherUserPositionToRemove = 0
                                    for otherUserConversation in otherUserConversations {
                                        if let otherUserId = otherUserConversation["id"] as? String,
                                           otherUserId == conversationId {
                                            print("found other user conversation with id to delete")
                                            break
                                        }
                                        otherUserPositionToRemove += 1
                                    }
                                    otherUserConversations.remove(at: otherUserPositionToRemove)
                                    self.database.child("\(otherUserEmail)/conversations").setValue(otherUserConversations, withCompletionBlock: { error, _ in
                                        guard error == nil else {
                                            completion(false)
                                            print("fail to write other user new conversation array")
                                            return
                                        }
                                        print("delete other user conversation")
                                        self.database.root.child("\(conversationId)").removeValue()
//                                        completion(true)
                                    })
                                }
                            })
                        }
                        break
                    }
                    positionToRemove += 1
                }
                conversations.remove(at: positionToRemove)
                ref.setValue(conversations, withCompletionBlock: { error, _ in
                    guard error == nil else {
                        completion(false)
                        print("fail to write new conversation array")
                        return
                    }
                    print("deleted conversation")
                    completion(true)
                })
            }
        })
    }
    
    public func conversationExist(with targetRecipientEmail: String, completion: @escaping(Result<String,Error>) -> Void) {
        let safeRecipientEmail = DatabaseManager.dbEmail(emailAdress: targetRecipientEmail)
        guard let senderEmail = UserDefaults.standard.value(forKey: "email") as? String else { return }
        let safeSenderEmail = DatabaseManager.dbEmail(emailAdress: senderEmail)
        database.child("\(safeRecipientEmail)/conversations").observeSingleEvent(of: .value, with: { snapshot in
            guard let collection = snapshot.value as? [[String: Any]] else {
                completion(.failure(DatabaseError.failedToFetch))
                return
            }
            // recall and find conversation with target sender
            if let conversation = collection.first(where: {
                guard let targetSenderEmail = $0["other_uesr_email"] as? String else { return false }
                return safeSenderEmail == targetSenderEmail
            }) {
                // get ID
                guard let id = conversation["id"] as? String else {
                    completion(.failure(DatabaseError.failedToFetch))
                    return
                }
                completion(.success(id))
                return
            }
            completion(.failure(DatabaseError.failedToFetch))
            return
        })
    }
}
