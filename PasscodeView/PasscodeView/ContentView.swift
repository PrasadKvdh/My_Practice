//
//  ContentView.swift
//  DisplayScreen
//
//  Created by mac_admin on 10/15/25.
//

import SwiftUI
import CoreText

struct ContentView: View {
    @State var isPresented: Bool = false
    
    var body: some View {
        ZStack {
            Color.red.opacity(0.4)
                .edgesIgnoringSafeArea(.all)
            VStack {
                Image(systemName: "globe")
                    .imageScale(.large)
                    .foregroundStyle(.tint)
                Text("Hello, world!")
                    .padding()
                
                Button {
                    isPresented.toggle()
                } label: {
                    Label("Show View iOS Native transparent view", systemImage: "person.fill")
                }
                
                .fullScreenCover(isPresented: $isPresented) {
                    //HomeView()
                    HoldingView()
                }
            }
            .padding()
        }
    }
}

struct HomeView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        ZStack(alignment: .top) {
            Rectangle()
                .cornerRadius(50)
                .glassEffect(.clear)
                .ignoresSafeArea(.all)
            
            HStack(alignment: .top) {
                VStack(alignment: .center) {
                    Image(systemName: "lock.fill")
                        .glassEffect(.identity)
                        .foregroundStyle(.white)
                        .padding(2)
                    Text(Date(), format: Date.FormatStyle(date: .long, time: .omitted))
                        .foregroundStyle(.white)
                        .glassEffect(.identity)
                        .padding(2)
                    TimelineView(.periodic(from: .now, by: 1)) { timeline in
                        let str = timeline.date.formatted(.dateTime.hour(.conversationalDefaultDigits(amPM: .omitted)).minute(.defaultDigits))
                        LiquidGlassText(text: str, font: .system(size: 100, weight: .bold))
                            .foregroundStyle(.white.opacity(0.8))
                    }
                    
                    Spacer()
                    
                    HStack(alignment: .center) {
                        Button(action:  {
                            dismiss()
                        }) {
                            Image(systemName: "flashlight.off.fill")
                                //.clipShape(Circle())
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                        .frame(maxWidth: 50, maxHeight: 50, alignment: .bottom)
                        .foregroundStyle(Color.white)
                        .buttonStyle(.glass)
                        //.glassEffect(.regular)
                        
                        Text("Swipe Up")
                            .foregroundStyle(Color.white)
                            .padding(.horizontal, 80)
                        
                        Button(action:  {
                            dismiss()
                        }) {
                            Image(systemName: "camera.fill")
                                .frame(width: 40, height: 40, alignment: .center)
                        }
                        .frame(maxWidth: 50, maxHeight: 50, alignment: .bottom)
                        .foregroundStyle(Color.white)
                        .buttonStyle(.glass)
                        //.glassEffect(.regular)
                        //.position(x: 0, y: 0)
                    }

                }
                
                
            }
                    }
    }
}


struct PaasCodeView: View {
    @State var isFill: Bool = false
    @State var passCodes: [PasscodeData]
    @State var tapCount: Int = 0
    let onCancleTapped: () -> Void
    
   var body: some View {
       ZStack {
           VStack {
               Text("Enter PassCode")
                   .foregroundStyle(Color.white)
                   .padding()

               LazyHGrid(rows: Array(repeating: GridItem(.fixed(15)), count: 1), alignment: .top, spacing: 20) {
                   ForEach(self.passCodes) { code in
                       CircleView(showColor: code.color)
                   }
               }
                .frame(height: 50)
               
               LazyVGrid(columns: Array(repeating: GridItem(.fixed(80)), count: 3), alignment: .center, spacing: 20) {
                   ForEach(1..<10) { i in
                       Button("\(i)") {
                           buttonTap()
                       }
                       .fontWeight(.bold)
                       .frame(width:70, height: 70)
                       .foregroundStyle(Color.white)
                       .glassEffect(.clear)
                   }
               }
               
               Button("0") {
                   buttonTap()
               }
               .fontWeight(.bold)
               .frame(width:70, height: 70)
               .foregroundStyle(Color.white)
               .glassEffect(.clear)
               .padding(20)
               
               HStack(alignment: .bottom) {
                   
                   Button("Cancel") {
                        onCancleTapped()
                   }
                   .foregroundStyle(Color.white)
               }
           }
       }
       .onAppear() {
           self.passCodes = [PasscodeData(color: Color.clear, tag: 0),                          PasscodeData(color: Color.clear, tag: 1),
                             PasscodeData(color: Color.clear, tag: 2),
                             PasscodeData(color: Color.clear, tag: 3),
                             PasscodeData(color: Color.clear, tag: 4),
                             PasscodeData(color: Color.clear, tag: 5)]
       }
   }
    
    func buttonTap() {
        if let codeIndex = self.passCodes.firstIndex(where: { $0.tag == tapCount }) {
            self.passCodes[codeIndex].color = .white
        }
                                                            
        tapCount += 1
        if tapCount == 7 {
            tapCount = 0
            self.passCodes = self.passCodes.map({ code in
                var newCode = code
                newCode.color = .clear
                return newCode
            })
        }
    }
}

struct CircleView: View {
    var showColor: Color
    var body: some View {
        Circle()
            .stroke(Color.white, lineWidth: 1)
            .frame(width: 16)
            .background(showColor)
            .cornerRadius(10)
    }
}

struct PasscodeData: Identifiable {
    let id = UUID()
    var color: Color
    var tag: Int
}


struct HoldingView: View {
    @State var showFirstView: Bool = true
    @State var showSecondView: Bool = false
    @State private var viewOffset: CGSize = .zero
    
    var body: some View {
        ZStack {
            Image("BeachView")
                .resizable()
                .aspectRatio(contentMode: .fill)
                .ignoresSafeArea(.all)
            
            if showFirstView {
                HomeView()
                    .offset(y: viewOffset.height)
                    .transition(.move(edge: .top))
            }
            
            if showSecondView {
                PaasCodeView(passCodes: [], onCancleTapped: {
                    withAnimation(.easeInOut) {
                        showSecondView = false
                        showFirstView = true
                    }
                })
                .transition(.move(edge: .bottom))
            }
                
        }
        .gesture(
            DragGesture()
                .onChanged { gesture in
                    self.viewOffset.height = min(0, gesture.translation.height)
                }
                .onEnded { value in
                    withAnimation(.bouncy()) {
                        showSecondView = true
                        self.viewOffset = .zero
                        showFirstView = false
                    }
                }
        )
    }
}

#Preview() {
    HomeView()
}
