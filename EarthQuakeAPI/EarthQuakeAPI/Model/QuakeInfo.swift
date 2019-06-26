//
//  QuakeInfo.swift
//  EarthQuakeAPI
//
//  Created by Boss on 6/26/19.
//  Copyright © 2019 Boss. All rights reserved.
//

import UIKit
class QuakeInfo {
    var mag: Double
    var place: String
    var distainsString: String
    var locationName: String
    var dateString: String
    var timeString: String
    var url: String
    var detail: String
    
    init?(mag: Double, place: String, timeInterval: TimeInterval, url: String, detail: String) {
        self.mag = mag
        self.place = place
        self.url = url
        self.detail = detail
        
        guard !url.isEmpty else {return nil}
        guard !detail.isEmpty else {return nil}
        
        if place.contains(" of ") {
            let placeDetail = place.components(separatedBy: " of ")
            distainsString = (placeDetail.first ?? "") + " OF"
            locationName = placeDetail.last ?? ""
        } else {
            self.distainsString = "NEAR THE"
            self.locationName = place
        }
        let dataForMater = DateFormatter()
        dataForMater.timeStyle = .short
        self.timeString = dataForMater.string(from: Date(timeIntervalSince1970: timeInterval/1000))
        dataForMater.timeStyle = .none
        dataForMater.dateStyle = .medium
        self.dateString = dataForMater.string(from: Date(timeIntervalSince1970: timeInterval/1000))
    }
    
    convenience init?(dict: JSON) {
        guard let mag = dict["mag"] as? Double else {return nil}
        guard let place = dict["place"] as? String else {return nil}
        guard let timeInterval = dict["time"] as? TimeInterval else {return nil}
        guard let url = dict["url"] as? String else {return nil}
        guard let detail = dict["detail"] as? String else {return nil}
        self.init(mag: mag, place: place, timeInterval: timeInterval, url: url, detail: detail)
    }
}
