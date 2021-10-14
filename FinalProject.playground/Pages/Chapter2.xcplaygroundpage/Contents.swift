//: [Previous](@previous)
// Chapter 2: Created by Antonio Simeone
//: Spritz Makediction: Chapter 2
//: =

import SwiftUI
import PlaygroundSupport
import UIKit
import Darwin
import AVKit


struct Chapter3: View{
    @State var position = CGPoint(x: 0, y: 470)
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View{
        ZStack{
            Image(uiImage: UIImage(named: "chapter2.jpg")!)
                .resizable()
                .frame(width:375, height: 620, alignment: .center)
            
            Image(uiImage: UIImage(named: "badGuy.png")!)
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .position(position)
                .onAppear {
                    withAnimation (Animation.easeIn.speed(0.2)){
                        position = CGPoint(x: 160, y: 470)
                    }
                }
           
        }
        .onAppear{
            let sound = Bundle.main.path(forResource: "audio", ofType: "m4a")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.audioPlayer.play()
            }
        }
  .frame(width: 375, height: 620)
        
    }
}

let chapter3 = Chapter3()
PlaygroundPage.current.setLiveView(chapter3)


//: [Next](@next)
