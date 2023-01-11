//
//  CustomMigrationPolicy.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 11.01.2023.
//

import CoreData

class CustomMigrationPolicy: NSEntityMigrationPolicy {

     func transformNumEmployees(forNum: NSNumber) -> String {
        if forNum.intValue < 150 {
            return "small"
        } else {
            return "very large"
        }
    }
}
