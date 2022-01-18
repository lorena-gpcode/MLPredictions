//
//  PokemonHomePresenter.swift
//  MLPredictions
//
//  Created by Lorena on 26/12/21.
//

import Foundation
import UIKit

class PokemonHomePresenter: ObservableObject {
    
    @Published var pictureResponse: PictureResponse? 
    
    var interactor: PokemonHomeInteractor?
    var view: PokemonHomeView?
    
    func sendPicture(the image: UIImage, _ completion: @escaping(PictureResponse?) -> Void){
        interactor?.sendPicture(with: PictureModel(img: image)) { [weak self] model in
            guard let model = model else {
                print("erro")
                return
            }
            self?.pictureResponse = model
            completion(model)
        }
    }
    
}
