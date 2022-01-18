//
//  ContentView.swift
//  MLPredictions
//
//  Created by Lorena on 26/12/21.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        NavigationView {
            ScrollView{
                let route = PokemonHomeRoute.getEntryPoint()
                NavigationLink(destination: route.entryPoint) {
                    InitialCard(title: "Detect Pokemon", message: "Online Version", img: "pokemon1", color: .green)
                }
                NavigationLink(destination: route.entryPoint) {
                    InitialCard(title: "Detect Pokemon", message: "Local Version", img: "pokemon2", color: .red)
                }
            }
            .navigationTitle("Deep Learning Apps")
        }
        
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
