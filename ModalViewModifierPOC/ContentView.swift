//
//  ContentView.swift
//  ModalViewModifierPOC
//
//  Created by Ike Mattice on 6/21/23.
//

import SwiftUI


struct ContentView: View {
    @State var isPresentingModal: Bool = false
    
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundColor(.accentColor)
            Text("Hello, world!")
                .padding(.bottom)
            Button(action: presentModal) {
                Text("Present Modal")
            }
        }
        .padding()
        .modifier(ModalViewModifier(isPresenting: $isPresentingModal) {
            ModalView()
        })
    }
    
    private func presentModal() {
        withAnimation {
            isPresentingModal = true
        }
    }
}

struct ModalView: View {
    var body: some View {
        Image(systemName: "person.fill")
            .imageScale(.large)
            .padding()
            .background(Color.green)
            .cornerRadius(8)
    }
}

extension View {
    func modal<Content:View>(isPresenting: Binding<Bool>, modalContent: @escaping ()->Content) -> some View {
        modifier(ModalViewModifier(isPresenting: isPresenting, modalContent: modalContent))
    }
}

struct ModalViewModifier<ModalContent:View>: ViewModifier {
    @Binding var isPresenting: Bool
    var modalContent: ()->ModalContent
    
    let animationDuration: Double = 0.5
    
    func body(content: Content) -> some View {
        ZStack {
            Color.clear
            
            content

            if isPresenting {
                contentShade
                
                modalView
            }
        }
//        .animation(.easeInOut(duration: 1), value: isPresenting)
    }
    
    // MARK: View Components
    var contentShade: some View {
        Color.black
            .opacity(isPresenting ? 0.3 : 0)
            .frame(maxWidth: .infinity)
            .ignoresSafeArea()
            .transition(.opacity)
            .animation(.easeIn(duration: animationDuration), value: isPresenting)
            .onTapGesture(perform: dismiss)
    }
    
    var modalView: some View {
        modalContent()
//            .opacity(isPresenting ? 1 : 0)
            .transition(.offset(y: 1000))
            .animation(.easeOut(duration: animationDuration), value: isPresenting)
    }
    
    func dismiss() {
        withAnimation {
            isPresenting = false
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
