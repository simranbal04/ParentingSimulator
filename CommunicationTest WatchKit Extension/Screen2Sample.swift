//
//  Screen2Sample.swift
//  CommunicationTest WatchKit Extension
//
//  Created by Parrot on 2019-10-31.
//  Copyright © 2019 Parrot. All rights reserved.
//

import Foundation
import WatchKit
import WatchConnectivity

class Screen2Sample: WKInterfaceController, WCSessionDelegate {
    
    // MARK: Outlets
    // ---------------------

    // 1. Outlet for the image view
    @IBOutlet var pokemonImageView: WKInterfaceImage!
    
    // 2. Outlet for the label
    @IBOutlet var nameLabel: WKInterfaceLabel!
    
    
    private var pokemonName = ""
    private var StartGame: Bool = false
    
    private var timing = Timer()
    
    private var TimeIntervalUpdation:Double = 0.5 // after every 5 sec
    
    private var PointsforHungar = 0;
    private var PointsforHealth = 100;
    
    // MARK: Delegate functions
    // ---------------------
    
    // Default function, required by the WCSessionDelegate on the Watch side
    func session(_ session: WCSession, activationDidCompleteWith activationState: WCSessionActivationState, error: Error?) {
        //@TODO
    }
    
    // MARK: WatchKit Interface Controller Functions
    // ----------------------------------
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        // 1. Check if the watch supports sessions
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
        }
        
        
    }
    
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("Watch:Got message from phone 2 ")
        
                let name = message["name"] as! String
                print("\(name)")
                nameSelection(name: name)

    }
    
    func nameSelection(name:String) {
        if (name == "Pikachu") {
            print("pikachu is ")
            
            
            //             self.nameLabel.setText("Pikachu is selected")
//            selectNameButtonPressed()
            //            self.pokemonImageView.setImage(pikachu)
            //            nameLabel(name: name)
        }
        else {
            print("caterpie is selected")
            //            self.nameLabel.setText("")
            
        }
    }
    
    
    override func willActivate() {
        // This method is called when watch view controller is about to be visible to user
        super.willActivate()
        
        
    }
    
    override func didDeactivate() {
        // This method is called when watch view controller is no longer visible
        super.didDeactivate()
    }
    
    
    
    @IBAction func nameselect() {
        print("Name button is pressed")
        self.namePokemon()
    }
    
    func namePokemon()
    {
        // to select name
        let PokemonName = ["Jimmy", "tom", "rolo"]
        presentTextInputController(withSuggestions: PokemonName, allowedInputMode: .plain)
        {
            (results) in
            
            if(results != nil && results!.count > 0) {
                // 2. write your code to process the person's response
                let userResponse = results?.first as? String
                print(userResponse)
                self.pokemonName = userResponse!
                self.nameLabel.setText(userResponse)
            }
        }
        
    }
    // MARK: Actions
    @IBAction func startButtonPressed() {
        print("Start button pressed")
        print("Start button pressed")
        print(pokemonName)
        if(pokemonName != "") {
            self.nameLabel.setText("\(self.pokemonName) is Hungry")
            self.StartGame = true
                        self.scheduleTimer()
            
        }
        else {
            print("Name not Given")
        }
    }
    
    func scheduleTimer(){
        //Call UpdateGame every 5 seconds
        self.timing = Timer.scheduledTimer(timeInterval: self.TimeIntervalUpdation, target: self, selector: Selector(("updateGame")), userInfo: nil, repeats: true)
    }
    
    
    
    @IBAction func feedButton() {
        print("Feed button pressed")
        // condition to check hunger stats with heath stats
        if (PointsforHungar>=1 && PointsforHealth>0)
        {
            self.PointsforHungar = self.PointsforHealth - 12
            
        }
        else if(PointsforHealth==0)
        {
            nameLabel.setText("Pokemon is dead")
        }
    }
    
    
    
    
    
    
//    @IBAction func selectNameButtonPressed() {
//        print("select name button pressed")
////        self.nameLabel.setText("You Got Pikachu")
//    }
//

}
