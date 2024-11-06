//
//  InstructionsView.swift
//  HPTrivia
//
//  Created by Weerawut Chaiyasomboon on 6/11/2567 BE.
//

import SwiftUI

struct InstructionsView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack{
            InfoBackgroundImage()
            
            VStack{
                Image(.appiconwithradius)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 150)
                    .padding(.top)
                
                ScrollView{
                    Text("How To Play?")
                        .font(.largeTitle)
                        .padding()
                    
                    VStack(alignment: .leading) {
                        Text("Welcome to HP Trivia! In this game, you will be asked random questions from the HP books and you must guess the right answer or you will lose points! 😱")
                            .padding([.horizontal,.bottom])
                        
                        Text("Each question is worth 5 points, but if you guess a wrong answer, you lose 1 point.")
                            .padding([.horizontal,.bottom])
                        
                        Text("If you are struggling with a question, there is an option to reveal a hint or reveal the book that answers the question. But beware! Using this also minuses 1 point each")
                            .padding([.horizontal,.bottom])
                        
                        Text("When you select the correct answer, you will award all the points left for that question and they will be added to your total scores.")
                            .padding(.horizontal)
                    }
                    .font(.title3)
                    
                    Text("Good Luck!")
                        .font(.title)
                }
                .foregroundStyle(.black)
                
                Button("Done") {
                    dismiss()
                }
                .doneButton()
            }
        }
    }
}

#Preview {
    InstructionsView()
}
