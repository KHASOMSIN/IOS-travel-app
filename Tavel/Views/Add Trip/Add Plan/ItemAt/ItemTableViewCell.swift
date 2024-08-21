//
//  ItemTableViewCell.swift
//  Tavel
//
//  Created by user245540 on 8/11/24.
//

import UIKit

class ItemTableViewCell: UITableViewCell {

    @IBOutlet weak var priceLabel: UILabel!
    @IBOutlet weak var itemsLabel: UILabel!
    @IBOutlet weak var titleItemLabel: UILabel!
    @IBOutlet weak var itemBackground: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        itemBackground.addShadow(opacity: 0.3)
    }
    
}
