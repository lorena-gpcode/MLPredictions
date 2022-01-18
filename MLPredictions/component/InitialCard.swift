//
//  InitialCard.swift
//  MLPredictions
//
//  Created by Lorena on 26/12/21.
//

import SwiftUI

struct InitialCard: View {
    
    @State var title = ""
    @State var message = ""
    @State var img = ""
    @State var color: Color = .white
    var body: some View {
        ZStack{
            VStack{
                Text(title)
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.top, 4)
                    .padding(.leading)
                HStack{
                    Text(message)
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 16)
                        .overlay(RoundedRectangle(cornerRadius: 20)
                                    .fill(Color.white.opacity(0.25)))
                        .frame(width: 200, height: 24)
                    
                    Image(img)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 100, height: 100)
                        .padding(.bottom, 4)
                        .padding(.trailing, 4)
                }
            }
        }
        .background(color)
        .cornerRadius(12)
        .shadow(color: color, radius: 6, x: 0.0, y: 0.0)
    }
}

struct InitialCard_Previews: PreviewProvider {
    static var previews: some View {
        InitialCard()
    }
}
