//
//  DataServices.swift
//  EarthQuakeAPI
//
//  Created by Boss on 6/26/19.
//  Copyright © 2019 Boss. All rights reserved.
//

import Foundation
typealias JSON = Dictionary<AnyHashable, Any>
class DataServices {
    static var sharedInstance = DataServices()
    var HOST = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/4.5_week.geojson"
    var quakeInfo: [QuakeInfo] = []
    var selectedQuake: QuakeInfo?
    
    func convertCoodinate(latitude: String, longitude: String) -> (lat: String, long: String) {
        var lati: String = "", longi: String = ""
        if let latitudeDouble = Double(latitude) {
            lati = String(format: "%.3f°%@", abs(latitudeDouble), latitudeDouble >= 0 ? "N" : "S") // kieu dinh dang, gia tri tuyet doi.
        }
        if let longitudeDouble = Double(longitude) {
            longi = String(format: "%.3f°%@", abs(longitudeDouble), longitudeDouble >= 0 ? "N" : "S")
        }
        return (lati, longi)
    }
    func makeDataTaskRequest(urlString: String, completeBlock:  @escaping (JSON) -> Void) {
        guard let url = URL(string: urlString) else {return}
        let urlRequest = URLRequest(url: url, cachePolicy: .returnCacheDataElseLoad, timeoutInterval: 10)
        URLSession.shared.dataTask(with: urlRequest) {(data, _, error) in
            guard error == nil else {
                return
            }
            guard let jsonObject = try? JSONSerialization.jsonObject(with: data!, options: .mutableContainers) else {
                return
            }
            guard let json = jsonObject as? JSON else {
                return
            }
            DispatchQueue.main.async {
                completeBlock(json)
                
            }
            }.resume()
    }
    
    func loadInfo(completeHandler: @escaping ([QuakeInfo]) -> Void) {
        quakeInfo = []
        makeDataTaskRequest(urlString: HOST) { [unowned self] json in
            guard let dictFeatures = json["features"] as? [JSON] else {return}
            for featuresJson in dictFeatures {
                guard let propertiesJson = featuresJson["properties"] as? JSON else { return }
                guard let quake = QuakeInfo(dict: propertiesJson) else { return }
                self.quakeInfo.append(quake)
            }
            completeHandler(self.quakeInfo)
        }
    }
    func loadDataDetail(from urlString: String, completionHandler: @escaping (QuakeDetail) -> Void) {
        makeDataTaskRequest(urlString: urlString) { json in
            let dictDet = json["properties"] as? JSON ?? [:]
            completionHandler(QuakeDetail(dictionary: dictDet))
        }
    }
}
