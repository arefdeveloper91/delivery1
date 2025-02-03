//
//  DriverModel.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//

import Foundation
struct DriverModel: Identifiable {
    let id: UUID
    let user: UserModel
    let location: LocationModel
    let vehicle: EVehicleType
    let isAvailable: Bool
}
