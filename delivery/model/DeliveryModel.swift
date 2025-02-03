//
//  DeliveryModel.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//

import Foundation
struct DeliveryModel {
    let id: String
    let sender: UserModel
    let receiver: UserModel
    let driver: DriverModel
    let vehicle: EVehicleType
    let statuses: [DeliveryStatusModel]
    let pickUpLocation: LocationModel
    let dropOffLocation: LocationModel
    let weather: EWeatherType
    let note: String?
    let tips: Double
    let price: Double
    let distanceInMeters: Double
    let durationInMinutes: Double
    var mustTips: Double {
        return Double(weather.difficulty*2)
    }
    var lastStatus: DeliveryStatusModel {
        return  statuses.last ?? DeliveryStatusModel(status: .findingDriver, dateTime: Date())
    }
}
