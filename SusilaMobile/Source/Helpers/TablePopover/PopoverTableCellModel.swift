//
//  PopoverTableCellModel.swift
//  CAMS
//
//  Created by Isuru Jayathissa on 7/23/15.
//  Copyright (c) 2015 Isuru Jayathissa. All rights reserved.
//

import UIKit

class PopoverTableCellModel {
   
    var id: Int
    var userId: Int
    var name: String
    var parentID: Int
    
    init(id: Int, userId: Int, name: String, parentID: Int){
        self.id = id
        self.userId = userId        
        self.name = name
        self.parentID = parentID
    }
    
}
