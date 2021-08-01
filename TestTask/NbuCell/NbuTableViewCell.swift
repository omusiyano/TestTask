import UIKit

class NbuTableViewCell: UITableViewCell {

    @IBOutlet weak var titleCurrencies: UILabel!
    @IBOutlet weak var titleRate: UILabel!
    @IBOutlet weak var titleCc: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
}
