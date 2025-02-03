//
//  EDeliveryChoiceSteps.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//

import Foundation
import SwiftUI
enum EDeliveryChoiceSteps: Int, CaseIterable, Identifiable {
    case pickup
    case package
    case dropoff
    case request
    
    var id : Int { return rawValue}
    
    
    var image: String {
        switch self {
        case .pickup: return "shippingbox.and.arrow.backward.fill"
        case .package: return "shippingbox.fill"
        case .dropoff: return "shippingbox.and.arrow.backward.fill"
        case .request: return "shippingbox.circle"
        }
    }
    
    var title: String {
        switch self {
        case .pickup: return "Pickup"
        case .package: return "Package"
        case .dropoff: return "Drop off"
        case .request: return "Ready"
        }
    }
    
    var scale: Double {
        switch self {
        case .pickup: return 1
        case .package: return 1
        case .dropoff: return -1
        case .request: return 1
        }
    }
}
