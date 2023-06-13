//
//  MoviesData+CoreDataProperties.swift
//  Movie List Demo
//
//  Created by Kruti on 13/06/23.
//
//

import Foundation
import CoreData


extension MoviesData {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<MoviesData> {
        return NSFetchRequest<MoviesData>(entityName: "MoviesData")
    }

    @NSManaged public var backdropPath: String?
    @NSManaged public var overview: String?
    @NSManaged public var posterPath: String?
    @NSManaged public var releaseDate: String?
    @NSManaged public var title: String?
    @NSManaged public var id: Int16

}

extension MoviesData : Identifiable {

}
