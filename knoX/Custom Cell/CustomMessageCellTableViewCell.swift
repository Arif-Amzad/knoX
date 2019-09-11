//
//  CustomMessageCellTableViewCell.swift
//  knoX
//
//  Created by Arif Amzad on 3/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

class CustomMessageCellTableViewCell: UITableViewCell {
    
//    @IBOutlet weak var senderName: UILabel!
//    @IBOutlet weak var messageBackground: UIView!
//    @IBOutlet weak var avatar: UIImageView!
//    @IBOutlet weak var messageBody: UILabel!
    
    let messageBody = UILabel()
    let bubbleBackgroundView = UIView()
    let sender = UILabel()
    
    var leadingConstraint = NSLayoutConstraint()
    var trailingConstraint = NSLayoutConstraint()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        backgroundColor = .clear
        bubbleBackgroundView.backgroundColor = .white
        addSubview(bubbleBackgroundView)
        bubbleBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        bubbleBackgroundView.layer.cornerRadius = 15
        
        //addSubview(sender)
        //sender.isHidden = true
        addSubview(messageBody)

        messageBody.numberOfLines = 0
        
        messageBody.translatesAutoresizingMaskIntoConstraints = false
        messageBody.textColor = .black
        
        let cellConstraints = [messageBody.topAnchor.constraint(equalTo: topAnchor, constant: 20),
        //messageBody.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        messageBody.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
        messageBody.widthAnchor.constraint(lessThanOrEqualToConstant: 250),
        
        
        
        bubbleBackgroundView.topAnchor.constraint(equalTo: messageBody.topAnchor, constant: -10),
        bubbleBackgroundView.leadingAnchor.constraint(equalTo: messageBody.leadingAnchor, constant: -10),
        bubbleBackgroundView.trailingAnchor.constraint(equalTo: messageBody.trailingAnchor, constant: 10),
        bubbleBackgroundView.bottomAnchor.constraint(equalTo: messageBody.bottomAnchor, constant: 10)]
        
        NSLayoutConstraint.activate(cellConstraints)
        
        leadingConstraint = messageBody.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20)
        
        leadingConstraint.isActive = false
        
        trailingConstraint = messageBody.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        
        trailingConstraint.isActive = true
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
