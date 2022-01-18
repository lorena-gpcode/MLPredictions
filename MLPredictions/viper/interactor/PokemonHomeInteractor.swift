//
//  PokemonHomeInteractor.swift
//  MLPredictions
//
//  Created by Lorena on 26/12/21.
//

import Foundation
import Alamofire
import UIKit

class PokemonHomeInteractor {
    
    var presenter: PokemonHomePresenter?
        
    func sendPicture(with picture: PictureModel, _ completion: @escaping(PictureResponse?) -> Void){
        
        guard let img = picture.img, let png = img.pngData() else {
            return
        }
        AF.upload(multipartFormData: { multipartFormData in
            multipartFormData.append(png, withName: "img",fileName: "img.png", mimeType: "image/png")
        }, to: "http://192.168.0.163:5005/pokemon", method: .post)
            .responseDecodable(of: PictureResponse.self) { response in
                completion(response.value)
            }
        
    }
}
