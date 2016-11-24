//
//  Player.swift
//  parkinApp
//
//  Created by cdt creatic on 23/11/16.
//  Copyright © 2016 movil unicauca. All rights reserved.
//

import Foundation
import UIKit

struct Player {
    var name : String?
    var game: String?
    var rating :Int
    
    init(name: String?, game: String? , rating: Int){
        self.name = name
        self.game = game
        self.rating = rating
        
    }
}
