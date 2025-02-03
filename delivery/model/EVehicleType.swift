//
//  EVehicleType.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//



import SwiftUI
enum EVehicleType: Int, CaseIterable, Identifiable {
    case bicycle
    case scooter
    case car
    case van
    
    var id : Int { return rawValue}
    
    var pricePerKm: Double {
        
        switch self {
        case .bicycle:
            return 0.729
        case .scooter:
            return 1.29
        case .car:
            return 2.29
        case .van:
            return 3.58
        }
    }
    var speedKmHour: Double {
        switch self {
        case .bicycle:
            return 35.0
        case .scooter:
            return 70.0
        case .car:
            return 100
        case .van:
            return 80
        }
    }
    var title: String {
        switch self {
        case .bicycle: return "Bicycle"
        case .scooter: return "Scooter"
        case .car: return "Car"
        case .van: return "Van"
        }
    }
    var maxPackageLimit: EPackageType {
        switch self {
        case .bicycle:
            return .s
        case .scooter:
            return .s
        case .car:
            return .m
        case .van:
            return .l
        }
    }
    var cantWork: [EWeatherType] {
        switch self {
        case .bicycle:
            return [.snow, .rain, .tooHot]
        case .scooter:
            return [.snow]
        case .car:
            return []
        case .van:
            return []
        }
    }
    var image: String {
        switch self {
        case .bicycle: return "bicycle"
        case .scooter: return "figure.outdoor.cycle"
        case .car: return "car"
        case .van: return "box.truck"
        }
    }
    
    var icon: String {
        switch self {
        case .bicycle: return "leaf.fill"
        case .scooter: return "speedometer"
        case .car: return "bolt.shield"
        case .van: return "person.3.fill"
        }
    }
    var iconColor: Color {
        switch self {
        case .bicycle: return .green
        case .scooter: return .cyan
        case .car: return Color(.systemBlue)
        case .van: return .gray
        }
    }
}
