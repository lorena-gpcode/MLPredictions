//
//  Pokemon.swift
//  MLPredictions
//
//  Created by Lorena on 26/12/21.
//

import Foundation
import UIKit

struct PictureModel {
    var img: UIImage?
}

struct PictureResponse: Codable {
    var success: Bool?
    var prediction: String?
}

