//: [Previous](@previous)
// Chapter 3 & 4: Created by Rishabh Dev & Fabiana Ferrara
// We merged chapter 3 & 4 for easy transition between the chapters due to playground limitations
// Fabiana Ferrara handled the MapKit with in-game and Rishabh Dev implemented the different case scenarios depending upon the user's choices such as "You Survive!" and "You Die" with Buttons.
//: Spritz Makediction: Chapter 3 & 4
//: =

import MapKit
import SwiftUI
import PlaygroundSupport

struct Bar: Identifiable, Equatable {
    static func == (lhs: Bar, rhs: Bar) -> Bool {
        return lhs.id == rhs.id
    }
    
    
    let id = UUID()
    let title: String
    let subtitle: String
    let barImage: String
    let coordinate: CLLocationCoordinate2D
}

let uiImage1 = UIImage(#imageLiteral(resourceName: "example.jpg"))

let uiImage2 = UIImage(#imageLiteral(resourceName: "bloodmoon.jpg"))

let bars: [Bar] = [
    Bar(title: "Cammarota Spritz", subtitle: "Vico Lungo Teatro Nuovo, 31", barImage: "cammarota", coordinate: .init(latitude: 40.842128, longitude: 14.247632)),
    Bar(title: "Shanti Art Musik Bar", subtitle: "Via Giovanni Paladino, 56/58", barImage: "Shanti.jpg", coordinate: .init(latitude: 40.848504, longitude: 14.256267)),
    Bar(title: "Bar Fiorillo", subtitle: "Via Santa Maria di Costantinopoli, 89", barImage: "rill.png", coordinate: .init(latitude: 40.849766, longitude: 14.251930)),
    Bar(title: "Iris Bar Sas", subtitle: "Via Guantai Nuovi, 5", barImage: "iris.jpg", coordinate: .init(latitude: 40.842534, longitude: 14.251548)),
    Bar(title: "OAK Napoli", subtitle: "Vico Quercia, 10", barImage: "oak", coordinate: .init(latitude: 40.847101, longitude: 14.250415))
    ]

let MAX_LIVES = 3

struct ContentView:View {
    
    @State var maxLives: Int = MAX_LIVES
    @State var lives: Int = MAX_LIVES
    @State var win: Bool = false
    
    var body:some View {
        if(win) {
            ZStack {
                Image(uiImage: uiImage1)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 375, height: 620, alignment: .center)
                
                VStack {
                    
                    Spacer()
                    
                    Text("You Survived! \n 🎊🎊🎊")
                        .bold()
                        .kerning(2.0)
                        .fontWeight(.black)
                        .multilineTextAlignment(.center)
                        .lineSpacing(4.0)
                        .font(.largeTitle)
                    
                    Spacer()

                    Button(action: {
                        print("Exit Navigation Button Pressed!")
                    }) {
                        HStack {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                                .font(.title)
                            Text("Exit Navigation")
                                .fontWeight(.semibold)
                                .font(.title)
                        }
                        .padding()
                        .foregroundColor(.white)
                        .background(Color.red)
                        .cornerRadius(40)
                    }
                    
                    Spacer()
                }
                
                VStack {
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Close")
                        }) {
                            HStack {
                                Image(systemName: "xmark.circle.fill")
                                    .font(.title)
                                    .foregroundColor(Color.red)
                               
                            }
                            
                        }
                        
                    }
                    
                    Spacer()
                }
                .padding()

            }
        }
        else if(lives > 0) {
            ZStack {
                MapView(onAnnotationSelect: {
                    bar in
                                        
                    if(lives == 0) {
                        print("gameover")
                        return
                    }

                    if(bar != bars.first!) {
                        print("miss")
                        lives -= 1
                    }
                    else {
                        win = true
                        print("hit")
                    }
                })
                    .frame(width: 375, height: 620)
                Lives(maxLives: $maxLives, lives: $lives)
                    .frame(width: 350, height: 550, alignment: .topLeading)
            }
        }
        else {
            
            ZStack {
                Image(uiImage: uiImage2)
                    .resizable()
                    .scaledToFill()
                    .edgesIgnoringSafeArea(.all)
                    .frame(width: 375, height: 620, alignment: .center)
                
            VStack {
                Spacer()
                Text("You die! \n ☠️☠️☠️")
                    .bold()
                    .kerning(2.0)
                    .fontWeight(.black)
                    .multilineTextAlignment(.center)
                    .lineSpacing(4.0)
                    .font(.largeTitle)
                    .foregroundColor(Color.red)
                Spacer()
                Button(action: {
                    print("retry")
                    lives = MAX_LIVES
                }) {
                    HStack {
                        Image(systemName: "gobackward")
                            .font(.title)
                        Text("Try Again")
                            .fontWeight(.semibold)
                            .font(.title)
                    }
                    .padding()
                    .foregroundColor(.white)
                    .background(Color.red)
                    .cornerRadius(40)
                }
                Spacer()
            }
        }
        }
    }
}

struct Lives: View {
    @Binding var maxLives: Int
    @Binding var lives: Int
    
    var body: some View {
        VStack {
            ForEach(0...maxLives - 1, id: \.self) { life in
                life < lives ? Image(uiImage: UIImage(named: "full_life")!)
                    .frame(width: 24, height: 24)
                : Image(uiImage: UIImage(named: "lost_life")!)
                    .frame(width: 24, height: 24)
            }
        }
    }
}

class CustomAnnotationView: MKMarkerAnnotationView {
    override init(annotation: MKAnnotation?, reuseIdentifier: String?) {
        super.init(annotation: annotation, reuseIdentifier: reuseIdentifier)
        
        canShowCallout = true
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        detailCalloutAccessoryView = nil
    }
    
    override func prepareForDisplay() {
        super.prepareForDisplay()
        
        if let customAnnotation = annotation as? CustomAnnotation {
            
            self.detailCalloutAccessoryView = UIImageView(image: UIImage(named: customAnnotation.bar.barImage))

            NSLayoutConstraint.activate([
                self.detailCalloutAccessoryView!.widthAnchor.constraint(equalToConstant: 300),
                self.detailCalloutAccessoryView!.heightAnchor.constraint(equalToConstant: 200)
            ])
        }
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
}

final class MapView: NSObject, UIViewRepresentable, MKMapViewDelegate {
    var onAnnotationSelect: (Bar?) -> Void
    
    private var map: MKMapView?
    
    init(onAnnotationSelect: @escaping (Bar?) -> Void) {
        self.onAnnotationSelect = onAnnotationSelect

        super.init()
    }
    
    func makeUIView(context: Context) -> MKMapView {
        let _map = MKMapView()
        
        _map.delegate = self
        _map.register(CustomAnnotationView.self, forAnnotationViewWithReuseIdentifier: MKMapViewDefaultAnnotationViewReuseIdentifier)
        _map.mapType = .standard
        _map.isRotateEnabled = false
        _map.isScrollEnabled = true
        _map.isZoomEnabled = false
        addAnnotations(_map, barArray: bars)
    
        _map.showAnnotations(_map.annotations, animated: true)
        
        self.map = _map
        
        return self.map!
    }

    
    func updateUIView(_ uiView: MKMapView, context: Context) {
        self.map = uiView
        map?.delegate = self
    }
    
    func addAnnotations(_ mapView: MKMapView, barArray: [Bar]) {
        barArray.forEach({
            bar in
            
            let CLLCoordType = CLLocationCoordinate2D(
                latitude: bar.coordinate.latitude,
                longitude: bar.coordinate.longitude)
            
            let point = CustomAnnotation(bar: bar)
            
            point.coordinate = CLLCoordType
            point.title = bar.title
            point.subtitle = bar.subtitle

            mapView.addAnnotation(point)
        })
    }
    
    func mapView(_ mapView: MKMapView, didSelect view: MKAnnotationView) {

        if let customAnnotation = view.annotation as? CustomAnnotation {

            self.onAnnotationSelect(customAnnotation.bar)
        }
    }
}

class CustomAnnotation: MKPointAnnotation {
    let bar: Bar
    
    init(bar: Bar) {
        self.bar = bar
        super.init()
    }
}

//let contentView = ContentView()

PlaygroundPage.current.setLiveView(ContentView())



//: [Next](@next)
