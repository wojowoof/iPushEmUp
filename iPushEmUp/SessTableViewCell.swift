//
//  SessTableViewCell.swift
//  iPushEmUp
//
//  Created by Jack Woychowski on 8/10/18.
//  Copyright © 2018 Jack Woychowski. All rights reserved.
//

import UIKit

class SessTableViewCell: UITableViewCell {

    static let reuseId = "SessCell"

    // MARK: -

    @IBOutlet var dateLabel: UILabel!
    @IBOutlet var countLabel: UILabel!

    // MARK: - Initialization
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
