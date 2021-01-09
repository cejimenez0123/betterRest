//
//  ContentView.swift
//  BetterRest
//
//  Created by /fam on 1/7/21.
//

import SwiftUI
import CoreML
struct ContentView: View {
    @State private var wakeUp=Date()
    @State private var sleepAmount = 8.0
    @State private var coffeeAmount=1
    var body: some View {
        NavigationView{
            VStack{
                Text("When do you want to wake up")
                    .font(.headline)
                DatePicker("Please enter a time",selection: $wakeUp,displayedComponents: .hourAndMinute)
                    .labelsHidden()
                Text("Desired hours of sleep")
                    .font(.headline)
                Text("\(sleepAmount,specifier:"%.3g") hours")
                Stepper(value: $sleepAmount,in:4...12,step:0.25){
                    Text("Sleep")
                       
                } .labelsHidden()
                Stepper(value: $coffeeAmount,in: 1...20){
                    if(coffeeAmount==1){
                        Text("\(coffeeAmount) cup")}
                    else{
                        Text("\(coffeeAmount) cup")
                    }
                }
                                
                    
                }
            .navigationTitle("BetterRest")
            .navigationBarItems(trailing: Button(action:calculateBedTime){
                Text("Calculate")
            })
        }
    }
    func calculateBedTime(){
        let model: SleepCalculator = {
            do {
                let config = MLModelConfiguration()
                return try SleepCalculator(configuration: config)
            } catch {
                print(error)
                fatalError("Couldn't create SleepCalculator")
            }
        }()
        let components = Calendar.current.dateComponents([.hour,.minute],from: wakeUp)
        let hour = Int(components.hour ?? 0) * 60 * 60
        let minute = Int(components.minute ?? 0) * 60
        do {
            let predictions = try
                model.prediction(wake: Double( hour + minute ), estimatedSleep: sleepAmount,coffee: Double(coffeeAmount))
            let sleepTime = wakeUp-predictions.actualSleep
        }catch{
            
        }
    }
      
        
        
}

           


    
    
    
            


struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
