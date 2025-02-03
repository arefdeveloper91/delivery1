//
//  LinearGradient+StrokeStyle.swift
//  delivery
//
//  Created by Aref Chucri on 03/02/25.
//

import SwiftUI



extension LinearGradient {
    static let gradientWalk = LinearGradient(
        colors: [.red, .orange, .yellow],
        startPoint: .leading, endPoint: .trailing)
    
    static let gradientDrive = LinearGradient(
        colors: [.blue, .green],
        startPoint: .leading, endPoint: .trailing)
}

extension RadialGradient {
    static let gradientDoneSteps = RadialGradient(colors: [.red, .orange, .yellow], center: .center,startRadius: 0,endRadius: 64)
    static let gradientWaitedSteps = RadialGradient(colors: [.gray, Color(.systemGray3)], center: .center,startRadius: 0,endRadius: 64)
}
extension StrokeStyle {
    static let strokeWalk = StrokeStyle(
        lineWidth: 5,
        lineCap: .round, lineJoin: .bevel, dash: [10, 10])
}
