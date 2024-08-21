//
//  ProfileTableViewCell.swift
//  Tavel
//
//  Created by user245540 on 8/4/24.
//

import UIKit

class ProfileTableViewCell: UITableViewCell {


    @IBOutlet weak var viewBackground: UIView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var profileImage: UIImageView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        viewBackground.addShadow(color: .black, opacity: 0.2, offset: CGSize(width: 0, height: 1), radius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    
    
}
