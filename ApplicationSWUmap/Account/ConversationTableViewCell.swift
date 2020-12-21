//
//  ConversationTableViewCell.swift
//  ApplicationSWUmap
//
//  Created by Thiti Watcharasottikul on 19/11/2563 BE.
//

import UIKit

class ConversationTableViewCell: UITableViewCell {

    static let identifier = "ConversationTableViewCell"
    
    private let userNameLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 20, weight: .medium)
        return lb
    }()
    
    private let userMessageLabel: UILabel = {
        let lb = UILabel()
        lb.font = .systemFont(ofSize: 16, weight: .regular)
        lb.numberOfLines = 0
        return lb
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        contentView.addSubview(userNameLabel)
        contentView.addSubview(userMessageLabel)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        userNameLabel.frame = CGRect(x: contentView.bounds.width * 0.05 + 10,
                                     y: contentView.bounds.height * 0.05,
                                     width: contentView.bounds.width * 0.9,
                                     height: (contentView.bounds.height - 20) / 2)
        userMessageLabel.frame = CGRect(x: contentView.bounds.width * 0.05 + 10,
                                        y: (contentView.bounds.height * 0.05) + userNameLabel.frame.size.height,
                                        width: contentView.bounds.width * 0.9,
                                        height: (contentView.bounds.height - 20) / 2)
        
    }
    
    public func configure(with model: Conversation) {
        self.userMessageLabel.text = model.latestMessage.text
        self.userNameLabel.text = model.name
    }
    
}
