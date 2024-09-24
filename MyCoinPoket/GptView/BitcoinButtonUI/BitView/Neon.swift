//
//  Neon.swift
//  MyCoinPoket
//
//  Created by 이윤지 on 9/24/24.
//

import UIKit
import SwiftUI

struct MySwiftUIView: View {
    var body: some View {
        let text = (
        """
        Bitcoin
        """
        )
        
        let smallBlur:CGFloat = 2
        let mediumBlur: CGFloat = 8
        
        ZStack {
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.yellow)
                .blur(radius: 16)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.pink)
                .blur(radius: mediumBlur)
                .offset(x: 8, y: 0)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.pink)
                .blur(radius: mediumBlur)
                .offset(x: 0, y: 8)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.pink)
                .blur(radius: mediumBlur)
                .offset(x: -8, y: 0)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.pink)
                .blur(radius: mediumBlur)
                .offset(x: 0, y: -8)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .blur(radius: smallBlur)
                .offset(x: 3, y: 0)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .blur(radius: smallBlur)
                .offset(x: 0, y: 3)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .blur(radius: smallBlur)
                .offset(x: -3, y: 0)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .blur(radius: smallBlur)
                .offset(x: 0, y: -3)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
                .blur(radius: 4)
            Text(text)
                .backgroundStyle(.clear)
                .font(Font.custom("ZenMaruGothic-Light", size: 100))
                .multilineTextAlignment(.center)
                .foregroundColor(.white)
        }
    }
    
}

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        neonGlowEffect()
        
    }
    
    func neonGlowEffect() {
        
        let mainView = UIView()
        self.view.addSubview(mainView)
        mainView.frame = self.view.frame
        let gradient = CAGradientLayer()
        gradient.colors = [UIColor(red: 0, green: (1/255) * 6, blue: (1/255) * 62, alpha: 1).cgColor, UIColor(red: (1/255) * 62, green: 0, blue: (1/255) * 37, alpha: 1).cgColor]
        gradient.frame = mainView.frame
        mainView.layer.addSublayer(gradient)
        
        let mySwiftUIView = MySwiftUIView()
        let swiftUIViewHost = UIHostingController(rootView: mySwiftUIView)

        self.addChild(swiftUIViewHost)
        mainView.addSubview(swiftUIViewHost.view)
        swiftUIViewHost.didMove(toParent: self)
        swiftUIViewHost.view.frame = self.view.frame
        swiftUIViewHost.view.backgroundColor = .clear
    }
}


#Preview{
    ContentView2()
  //  MySwiftUIView()
        
}

struct ContentView2: View {
    var body: some View {
        VStack {
            NeonBorderView()
                .frame(width: 200, height: 200)
                .padding()
        }
    }
}

struct NeonBorderView: View {
    @State private var startGradient = UnitPoint.topLeading
    @State private var endGradient = UnitPoint.bottomLeading

    var body: some View {
        ZStack {
          Circle()
                .strokeBorder(
                    LinearGradient(
                        gradient: Gradient(colors: [.red,.black,.red]),
                        startPoint: startGradient,
                        endPoint: endGradient
                    ),
                    lineWidth: 5
                        
                )
                .shadow(color: .red, radius: 4)
                .onAppear {
                    let animation = Animation.linear(duration: 6 ).repeatForever(autoreverses: false)
                    
                    withAnimation(animation) {
                        startGradient = UnitPoint.bottomTrailing
                        endGradient = UnitPoint.topLeading
                    }
                }

            // Content inside the border
            Text("Neon Border")
                .foregroundColor(.white)
                .font(.title)
        }
        .background(Color.black)
        .cornerRadius(10)
    }
}

