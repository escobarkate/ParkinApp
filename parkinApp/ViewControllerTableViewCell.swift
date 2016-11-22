//
//  ViewControllerTableViewCell.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 21/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class ViewControllerTableViewCell: UITableViewCell {

    //@IBOutlet var image: UIImageView!
    @IBOutlet weak var ParqName: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
