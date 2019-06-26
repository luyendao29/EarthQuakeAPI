//
//  QuakeDetail.swift
//  EarthQuakeAPI
//
//  Created by Boss on 6/26/19.
//  Copyright © 2019 Boss. All rights reserved.
//

import Foundation
class QuakeDetail {
    var felt: Double
    var cdi: Double
    var mmi: Double
    var alert: String
    
    var eventTime: String
    var latitude: String
    var longitude: String
    var depth: String
    init(dictionary: JSON) {
        cdi = dictionary["cdi"] as? Double ?? 999
        mmi = dictionary["mmi"] as? Double ?? 999
        alert = dictionary["alert"] as? String ?? "999"
        felt = dictionary["felt"] as? Double ?? 999
        let dictProducts = dictionary["products"] as? JSON ?? [:]
        let arrOrigin = dictProducts["origin"] as? [JSON] ?? []
        let dictpropertiesOfOrigin = arrOrigin[0]["properties"] as? JSON ?? [:]
        let evenTime = dictpropertiesOfOrigin["eventtime"]  as? String ?? ""
        eventTime = evenTime.replacingOccurrences(of: "T", with: " ").components(separatedBy: ".").first! + " (UTC)"
        depth = (dictpropertiesOfOrigin["depth"] as? String ?? "999") + " Km"
        let latitude = dictpropertiesOfOrigin["latitude"] as? String ?? "999"
        let longitude = dictpropertiesOfOrigin["longitude"] as? String ?? "999"
        let (newLat, newLong) = DataServices.sharedInstance.convertCoodinate(latitude: latitude, longitude: longitude)
        self.latitude = newLat
        self.longitude = newLong
    }
}
