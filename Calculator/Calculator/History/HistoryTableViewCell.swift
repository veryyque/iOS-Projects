
import Foundation
import UIKit

class HistoryTableViewCell: UITableViewCell {
    @IBOutlet weak var expressionLabel: UILabel!
    @IBOutlet weak var resultLabel: UILabel!
    
    func configure(with expression: String, result: String){
        expressionLabel.text = expression
        resultLabel.text = result
    }
}
