import Combine
import SwiftUI
import UserNotifications

extension ContentView {
  //observableObject allows triggering a redraw
  class Counter: ObservableObject {
      
    //trigger redraw whenever change occurs for these variables (button icon and text)
    @Published var isTaskExecuting = false
    @Published var message = initialMessage

    static let initialMessage = "Counter"
    static let maxValue = 1000

    var number = 0
    var backgroundTask: UIBackgroundTaskIdentifier = .invalid
    var timer: Timer?

    func beginOrPauseCounter()
    {
      isTaskExecuting = !isTaskExecuting
        
      //if we are starting counter, reset number and set up timer to execute goToNextNumber each second
      if isTaskExecuting
      {
        number = 0
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
          self?.goToNextNumber()
        }
      }
      else //or if stopping counter, then end timer and background task, and display Counter text instead of number
      {
        timer?.invalidate()
        timer = nil
        endBackgroundTaskIfActive()
        message = Self.initialMessage
      }
    }

    func goToNextNumber() {
    
      number = number + 1
      message = "\(self.number)"
        
      //create notification if number reaches a mutiple of 10
      if Int(number) % 10 == 0
      {
        sendNotification(title: "Notifikacija", text: "Rezultat je dosegao \(self.number)")
      }

      switch UIApplication.shared.applicationState {
          case .background:
              let timeRemaining = UIApplication.shared.backgroundTimeRemaining
              let secondsRemaining = String(format: "%.1f sekundi preostalo", timeRemaining)
              print("App je sad u pozadini - \(message) - \(secondsRemaining)")
              if timeRemaining < 0.5
              {
                    sendNotification(title: "Pozadinski zadatak gotov", text: "Rezultat je stao na \(self.number+1), za nastavak brojača se vratite u aplikaciju")
              }
          default:
            break
      }
    }
      
      
    func startBackgroundTask()
    {
        //once this time is up, iOS may or may not give some more time to background task
        //but here it will be stopped in any case, so to keep counting we would need to bring
        //the app back to foreground
        backgroundTask = UIApplication.shared.beginBackgroundTask { [weak self] in
            print("Vrijeme koje je iOS dodijelio pozadinskom zadatku je isteklo")
            self?.endBackgroundTaskIfActive()
        }
    }

    func endBackgroundTaskIfActive() {
        let isBackgroundTaskActive = backgroundTask != .invalid
        if isBackgroundTaskActive {
          UIApplication.shared.endBackgroundTask(backgroundTask)
          backgroundTask = .invalid
        }
    }
      

    //monitoring scenePhase in ContentView, registers change foreground to background
    //and vice versa
    //if app is moved to background, start background task of counting
    //stop it when app back to foreground
    func onChangeOfScenePhase(_ newPhase: ScenePhase)
    {
      switch newPhase
      {
          case .background:
            let isTimerRunning = timer != nil
            let isTaskUnregistered = backgroundTask == .invalid

            if isTimerRunning && isTaskUnregistered {
              startBackgroundTask()
            }
              
          case .active:
            endBackgroundTaskIfActive()
          
          default:
            break
      }
    }
      
      
    func sendNotification(title : String, text : String)
    {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert,.sound])
          { (granted, error) in
          }

        let content = UNMutableNotificationContent()
        content.title = title
        content.body = text

        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 0.1, repeats: false)
        let uuidString = UUID().uuidString
        let request = UNNotificationRequest(identifier: uuidString, content: content, trigger: trigger)
        center.add(request) { (error) in
        }
    }
     
      
  }
}

