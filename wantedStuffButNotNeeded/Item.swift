//
//  Item.swift
//  wantedStuffButNotNeeded
//
//  Created by Chase McElroy on 7/9/16.
//  Copyright © 2016 Chase McElroy. All rights reserved.
//

import Foundation
import CoreData


class Item: NSManagedObject {

    override func awakeFromInsert() {
        super.awakeFromInsert()
        
        self.created = NSDate()
    }

}
