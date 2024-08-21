import UIKit
import Localize_Swift

class SettingsTableViewCell: UITableViewCell {

    @IBOutlet weak var titleSetting: UILabel!
    @IBOutlet weak var logoImage: UIImageView!
    
    @IBOutlet weak var viewBackgound: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        selectionStyle = .none
        viewBackgound.addShadow(color: .black, opacity: 0.2, offset: CGSize(width: 0, height: 1), radius: 5)
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
}
