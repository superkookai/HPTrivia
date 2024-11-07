//
//  Constants.swift
//  HPTrivia
//
//  Created by Weerawut Chaiyasomboon on 6/11/2567 BE.
//

import SwiftUI
import AVKit

enum Constants{
    static let hpFont = "PartyLetPlain"
}

struct InfoBackgroundImage: View{
    var body: some View{
        Image(.parchment)
            .resizable()
            .ignoresSafeArea()
            .background(.brown)
    }
}

extension Button{
    func doneButton() -> some View{
        self
            .font(.largeTitle)
            .padding()
            .buttonStyle(.borderedProminent)
            .tint(.brown)
    }
}

