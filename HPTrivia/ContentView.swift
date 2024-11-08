//
//  ContentView.swift
//  HPTrivia
//
//  Created by Weerawut Chaiyasomboon on 6/11/2567 BE.
//

import SwiftUI
import AVKit

struct ContentView: View {
    @EnvironmentObject private var store: Store
    @EnvironmentObject private var game: Game
    @State private var audioPlayer: AVAudioPlayer!
    @State private var scalePlayButton = false
    @State private var moveBackgroundImage = false
    @State private var animateViewsIn = false
    @State private var showInstructions = false
    @State private var showSettings = false
    @State private var playGame = false
    
    var body: some View {
        GeometryReader{ geo in
            ZStack{
                Image(.hogwarts)
                    .resizable()
                    .frame(width: geo.size.width*3, height: geo.size.height)
                    .padding(.top,3)
                    .offset(x: moveBackgroundImage ? geo.size.width/1.1 : -geo.size.width/1.1)
                    .onAppear {
                        withAnimation(.linear(duration: 60).repeatForever()) {
                            moveBackgroundImage.toggle()
                        }
                    }
                
                VStack{
                    VStack{
                        if animateViewsIn {
                            VStack{
                                Image(systemName: "bolt.fill")
                                    .font(.largeTitle)
                                    .imageScale(.large)
                                
                                Text("HP")
                                    .font(.custom(Constants.hpFont, size: 70))
                                    .padding(.bottom,-50)
                                
                                Text("Trivia")
                                    .font(.custom(Constants.hpFont, size: 60))
                            }
                            .padding(.top,70)
                            .transition(.move(edge: .top))
                        }
                    }
                    .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)
                    
                    Spacer()
                    
                    VStack{
                        if animateViewsIn {
                            VStack{
                                Text("Recent Scores")
                                    .font(.title2)
                                ForEach(game.recentScores, id: \.self){ score in
                                    Text("\(score)")
                                }
                            }
                            .font(.title3)
                            .padding(.horizontal)
                            .foregroundStyle(.white)
                            .background(.black.opacity(0.7))
                            .clipShape(.rect(cornerRadius: 15))
                            .transition(.opacity)
                        }
                    }
                    .animation(.linear(duration: 1).delay(4), value: animateViewsIn)
                    
                    Spacer()
                    
                    HStack{
                        Spacer()
                        
                        VStack{
                            if animateViewsIn {
                                Button {
                                    //Show Instructions Screen
                                    showInstructions.toggle()
                                } label: {
                                    Image(systemName: "info.circle.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: -geo.size.width/4))
                                .sheet(isPresented: $showInstructions) {
                                    InstructionsView()
                                }
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()
                        
                        VStack{
                            if animateViewsIn {
                                Button {
                                    //Start New Game
                                    filterQuestions()
                                    game.startGame()
                                    playGame.toggle()
                                } label: {
                                    Text(store.books.contains(.active) ? "Play" : "No Book")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .padding(.vertical,7)
                                        .padding(.horizontal,50)
                                        .background(store.books.contains(.active) ? .brown : .gray)
                                        .clipShape(.rect(cornerRadius: 7))
                                        .shadow(radius: 5)
                                }
                                .scaleEffect(scalePlayButton ? 1.2 : 1.0)
                                .onAppear {
                                    withAnimation(.easeInOut(duration: 1.3).repeatForever()) {
                                        scalePlayButton.toggle()
                                    }
                                }
                                .transition(.offset(y: geo.size.height/3))
                                .fullScreenCover(isPresented: $playGame) {
                                    GamePlayView()
                                        .environmentObject(game)
                                        .onAppear {
                                            audioPlayer.setVolume(0, fadeDuration: 2)
                                        }
                                        .onDisappear {
                                            audioPlayer.setVolume(1, fadeDuration: 3)
                                        }
                                }
                                .disabled(store.books.contains(.active) ? false : true)
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2), value: animateViewsIn)

                        Spacer()
                        
                        VStack{
                            if animateViewsIn {
                                Button {
                                    //Show Setting Screen
                                    showSettings.toggle()
                                } label: {
                                    Image(systemName: "gearshape.fill")
                                        .font(.largeTitle)
                                        .foregroundStyle(.white)
                                        .shadow(radius: 5)
                                }
                                .transition(.offset(x: geo.size.width/4))
                                .sheet(isPresented: $showSettings) {
                                    SettingsView()
                                        .environmentObject(store)
                                }
                            }
                        }
                        .animation(.easeOut(duration: 0.7).delay(2.7), value: animateViewsIn)
                        
                        Spacer()

                    }
                    .frame(width: geo.size.width)
                    
                    VStack{
                        if animateViewsIn{
                            if store.books.contains(.active) == false{
                                Text("No questions available, go to settings.⬆️")
                                    .multilineTextAlignment(.center)
                                    .foregroundStyle(.white)
                                    .transition(.opacity)
                            }
                        }
                    }
                    .animation(.easeInOut.delay(3), value: animateViewsIn)
                    
                    Spacer()
                }
                
            }
            .frame(width: geo.size.width, height: geo.size.height)
        }
        .ignoresSafeArea()
        .onAppear {
            animateViewsIn = true
            playAudio()
        }
    }
    
    private func playAudio(){
        let sound = Bundle.main.path(forResource: "magic-in-the-air", ofType: "mp3")
        audioPlayer = try! AVAudioPlayer(contentsOf: URL(filePath: sound!))
        audioPlayer.numberOfLoops = -1
        audioPlayer.play()
    }
    
    private func filterQuestions(){
        var books: [Int] = []
        for (index,status) in store.books.enumerated(){
            if status == .active{
                books.append(index+1)
            }
        }
        game.filterQuestions(to: books)
    }
}

#Preview {
    ContentView()
        .environmentObject(Store())
        .environmentObject(Game())
}
