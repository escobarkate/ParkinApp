//
//  CalificacionesTableViewCell.swift
//  parkinApp
//
//  Created by Mario Gironza Cerón on 18/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import UIKit

class CalificacionesTableViewCell: UITableViewCell {

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    
    // MARK: NSCoding
    
    func saveMeals() {
        let isSuccessfulSave = NSKeyedArchiver.archiveRootObject(meals, toFile: Meal.ArchiveURL.path!)
        
    }
}
