//
//  CDPeople+CoreDataProperties.swift
//  CD People Table
//
//  Created by student on 23.04.2024.
//
//

import Foundation
import CoreData


extension CDPeople {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<CDPeople> {
        return NSFetchRequest<CDPeople>(entityName: "CDPeople")
    }

    @NSManaged public var phone: String?
    @NSManaged public var name: String?
    @NSManaged public var address: String?

}

extension CDPeople : Identifiable {

}
