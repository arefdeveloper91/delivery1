//
//  DeliveryStatusModel.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//

import Foundation
struct DeliveryStatusModel {
    let status: EDeliveryStatus
    let dateTime: Date
    internal enum EDeliveryStatus {
       case findingDriver
       case driverComing
       case driverOnRoad
       case packageDelivered
       case cancelled
    }
}
