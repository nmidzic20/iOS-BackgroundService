//
//  ContentView.swift
//  PozadinskiServis_RAMPU
//
//  Created by FOI on 21.11.2022..
//

import SwiftUI

struct ContentView: View {
    
    //property which monitors if app in foreground or background
    //calling onChangeof below
    @Environment(\.scenePhase) var scenePhase
    
    //StateObject property wrapper instead of
    //ObservedObject to ensure reference to Counter
    //is not destroyed anytime the view changes
    @StateObject var counter = Counter()

    var body: some View {
      VStack(alignment: .center, spacing: 30) {

            Spacer()

            Button(
              action: { counter.beginOrPauseCounter() },
              label: {
                VStack {
                  Text(counter.isTaskExecuting ? "Zaustavi brojač" : "Pokreni brojač")
                  Image(systemName: counter.isTaskExecuting ? "stop" : "play")
                }
              })

            Text(counter.message)

            Spacer()
          }
        
      .onChange(of: scenePhase) { newPhase in
        counter.onChangeOfScenePhase(newPhase)
          
      }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
