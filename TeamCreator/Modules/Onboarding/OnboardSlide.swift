//
//  OnboardingSlides.swift
//  TeamCreator
//
//  Created by Ceren Uludoğan on 30.07.2024.
//

import Foundation
import UIKit

struct OnboardSlide: Decodable {
    let title: String
    let description: String
    let imageName: String
}

struct OnboardData: Decodable {
    let screens: [OnboardSlide]
}
