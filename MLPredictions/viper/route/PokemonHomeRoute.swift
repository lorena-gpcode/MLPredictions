//
//  PokemonHomeRoute.swift
//  MLPredictions
//
//  Created by Lorena on 26/12/21.
//

import Foundation

class PokemonHomeRoute {
    
    var entryPoint: PokemonHomeView?
    
    static func getEntryPoint() -> PokemonHomeRoute {
        let interactor = PokemonHomeInteractor()
        let presenter = PokemonHomePresenter()
        let view = PokemonHomeView(presenter: presenter)
        let route = PokemonHomeRoute()
        route.entryPoint = view
        presenter.interactor = interactor
        presenter.view = view
        interactor.presenter = presenter
        return route
    }
}
