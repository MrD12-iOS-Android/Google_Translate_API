//
//  TableViewCell.swift
//  HomeWork_72_Google_Translate_API
//
//  Created by Oybek Iskandarov on 6/19/21.
//

import UIKit

class TableViewCell: UITableViewCell {
    @IBOutlet weak var langLabel: UILabel!
    
    @IBOutlet weak var backView: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        backView.layer.cornerRadius = backView.layer.frame.height / 2
        backView.layer.shadowColor = UIColor.red.cgColor
        backView.layer.shadowRadius = 10
        backView.layer.shadowOpacity = 0.7
        self.selectionStyle = .none
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
}
