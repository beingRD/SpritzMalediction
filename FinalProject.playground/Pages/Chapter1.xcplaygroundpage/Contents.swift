//
//  FinalProject.playground
//  Spritz Malediction
//
//  Created by Namaste Group on 14/10/21.
//


//: ![Spritz Malediction](Namaste.png)
//: Spritz Makediction: Chapter 1
//: =
// Chapter 1: Created by Marina Sessa

import UIKit
import SwiftUI
import PlaygroundSupport
import AVKit

struct Background: View {
    @State private var position = CGPoint(x: 360,y:220)
    @State private var movement = 220.0
    @State private var timer2 = 6
    @State var actualing: Image!
    @State var timeGif = 1
    
    
    var giffoni: [Image] = [Image(uiImage: UIImage(named: "02.jpg")!),Image(uiImage: UIImage(named: "01.jpg")!)]
    
    
    let timer = Timer.publish(every:5, on: .main, in: .common).autoconnect()
    
    @State var audioPlayer: AVAudioPlayer!
    
    var body: some View {
        ZStack {
            giffoni[timeGif%2]
                .resizable()
                .frame(width: 375, height: 620, alignment: .center)
                .onReceive(timer) {_ in

                    if timeGif > 0
                    {
                        timeGif -= 1
                    
                    }
                }

        }
        
        .onAppear {
            let sound = Bundle.main.path(forResource: "AudioChapter1", ofType: "m4a")
            self.audioPlayer = try! AVAudioPlayer(contentsOf: URL(fileURLWithPath: sound!))
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                self.audioPlayer.play()
            }
        }
        
    }
}

PlaygroundPage.current.setLiveView(Background())





//: [Next](@next)
