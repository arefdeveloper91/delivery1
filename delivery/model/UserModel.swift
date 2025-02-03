//
//  UserModel.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//

import Foundation
struct UserModel {
    let name: String
    let surname: String
    let phoneNumber: String
    var email: String? = ""
    let userType: EUserType
}
