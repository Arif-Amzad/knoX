//
//  ChatListViewCell.swift
//  knoX
//
//  Created by Arif Amzad on 7/9/19.
//  Copyright © 2019 Arif Amzad. All rights reserved.
//

import UIKit

class ChatListViewCell: UITableViewCell {
    
    
    @IBOutlet weak var avatar: UIImageView!
    @IBOutlet weak var name: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        
        backgroundColor = .clear

        // Configure the view for the selected state
    }
    
}
