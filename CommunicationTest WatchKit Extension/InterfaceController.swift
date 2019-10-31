//
//  InterfaceController.swift
//  CommunicationTest WatchKit Extension
//
//  Created by Parrot on 2019-10-26.
//  Copyright © 2019 Parrot. All rights reserved.
// simi

import WatchKit
import Foundation
import WatchConnectivity

class InterfaceController: WKInterfaceController, WCSessionDelegate {

    
    // MARK: Outlets
    // ---------------------
    @IBOutlet var messageLabel: WKInterfaceLabel!
   
    // Imageview for the pokemon
    @IBOutlet var pokemonImageView: WKInterfaceImage!
    // Label for Pokemon name (Albert is hungry)
    @IBOutlet var nameLabel: WKInterfaceLabel!
    // Label for other messages (HP:100, Hunger:0)
    @IBOutlet var outputLabel: WKInterfaceLabel!
    
    
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
    
    // 3. Get messages from PHONE
    func session(_ session: WCSession, didReceiveMessage message: [String : Any]) {
        print("WATCH: Got message from Phone")
        // Message from phone comes in this format: ["course":"MADT"]
//        let messageBody = message["course"] as! String
//        messageLabel.setText(messageBody)
//
  // connection check 
        let name = message["name"] as! String
        print("\(name)")
        nameSelection(name: name)
//
//
    }
    
    
    func nameSelection(name:String) {
        if (name == "Pikachu") {
            print("pikachu is ")


//             self.nameLabel.setText("Pikachu is selected")
            nameButtonPressed()
//            self.pokemonImageView.setImage(pikachu)
            //            nameLabel(name: name)
        }
        else {
            print("caterpie is selected")
//            self.nameLabel.setText("")

        }
   }


    
    // MARK: WatchKit Interface Controller Functions
    // ----------------------------------
    override func awake(withContext context: Any?) {
        super.awake(withContext: context)
        
        
        // 1. Check if teh watch supports sessions
        if WCSession.isSupported() {
            WCSession.default.delegate = self
            WCSession.default.activate()
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

    
    // MARK: Actions
    // ---------------------
    
    // 2. When person presses button on watch, send a message to the phone
    @IBAction func buttonPressed() {
        
        if WCSession.default.isReachable {
            print("Attempting to send message to phone")
            self.messageLabel.setText("Sending msg to watch")
            WCSession.default.sendMessage(
                ["name" : "Pritesh"],
                replyHandler: {
                    (_ replyMessage: [String: Any]) in
                    // @TODO: Put some stuff in here to handle any responses from the PHONE
                    print("Message sent, put something here if u are expecting a reply from the phone")
                    self.messageLabel.setText("Got reply from phone")
            }, errorHandler: { (error) in
                //@TODO: What do if you get an error
                print("Error while sending message: \(error)")
                self.messageLabel.setText("Error sending message")
            })
        }
        else {
            print("Phone is not reachable")
            self.messageLabel.setText("Cannot reach phone")
        }
    }
    
    
    // MARK: Functions for Pokemon Parenting
    @IBAction func nameButtonPressed() {
        print("name button pressed")
         self.namePokemon()
//        self.nameLabel.setText("You Got Pikachu")
        
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
    
    @IBAction func startButtonPressed() {
        print("Start button pressed")
        print(pokemonName)
        if(pokemonName != "") {
            self.nameLabel.setText("\(self.pokemonName) is Hungry")
            self.StartGame = true
//            self.scheduleTimer()
        
        }
        else {
            print("Name not Given")
        }
        
    }
    
    
    func scheduleTimer(){
        //Call UpdateGame every 5 seconds
        self.timing = Timer.scheduledTimer(timeInterval: self.TimeIntervalUpdation, target: self, selector: Selector(("updateGame")), userInfo: nil, repeats: true)
    }
    
    
    @IBAction func feedButtonPressed() {
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
    
    
    
    @IBAction func hibernateButtonPressed() {
        print("Hibernate button pressed")
    }
    
   
}
