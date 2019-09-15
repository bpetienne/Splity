//
//  Configuration.swift
//  CostTracker
//
//  Created by Benoit ETIENNE on 15/07/2017.
//  Copyright © 2017 Benoit ETIENNE. All rights reserved.
//

import UIKit

struct StoryboardSegue {
    
    static let PushToAddDestinationSegue = "AddDestination"
    static let PushToAddCurrencySegue = "AddCurrency"
    static let PushToTravellerSelectionSegue = "SelectTraveller"
    static let PushToDateSelectorSegue = "PushToDateSelectorSegue"
}

struct Configuration {
    
    //MARK: Fonts

    static let fonts = [    "Verdana",
                            "PingFangTC-Regular",
                            "Optima-Regular",
                            "MarkerFelt-Thin",
                            "Menlo-Regular",
                            "KohinoorDevanagari-Regular",
                            "HelveticaNeue",
                            "Georgia",
                            "Courier",
                            "BradleyHandITCTT-Bold",
                            "ChalkboardSE-Regular",
                            "Baskerville",
                            "Avenir-Medium",
                            "AppleSDGothicNeo-Regular",
    ]
    
    static let font: UIFont = UIFont(descriptor: UIFontDescriptor(name: "Marker Felt", size: CGFloat(30)), size: CGFloat(30))
    
    //MARK: Colors

    static let purpleColor: UIColor = #colorLiteral(red: 0.5750229955, green: 0.2339317203, blue: 0.5609765053, alpha: 1)
    static let yellowColor: UIColor = #colorLiteral(red: 0.9907597899, green: 0.9846798778, blue: 0.01871236973, alpha: 1)
    static let textFiledBorderColor: UIColor = #colorLiteral(red: 0.8374180198, green: 0.8374378085, blue: 0.8374271393, alpha: 1)
    static let sectionTextColor: UIColor = #colorLiteral(red: 0.3179988265, green: 0.3179988265, blue: 0.3179988265, alpha: 1) //25%
    static let sectionTextColor35: UIColor = #colorLiteral(red: 0.349999994, green: 0.349999994, blue: 0.349999994, alpha: 1) //35%
    static let sectionColor: UIColor = #colorLiteral(red: 0.9300000072, green: 0.9300000072, blue: 0.9300000072, alpha: 1) //93%
    //static let sectionColor: UIColor = #colorLiteral(red: 0.9300000072, green: 0.9300000072, blue: 0.9300000072, alpha: 1) //93%
   static let grayColor50: UIColor = UIColor(red: 0.5, green: 0.5, blue: 0.5, alpha: 1)
    static let grayColor75: UIColor = UIColor(red: 0.75, green: 0.75, blue: 0.75, alpha: 1)
    static let grayColor65: UIColor = UIColor(red: 0.65, green: 0.65, blue: 0.65, alpha: 1)
    static let grayColor85: UIColor = UIColor(red: 0.85, green: 0.85, blue: 0.85, alpha: 1)
    static let grayColor80: UIColor = UIColor(red: 0.8, green: 0.8, blue: 0.8, alpha: 1)
    static let alphaDigitColor = CGFloat(0.3)
    static let foodColor: UIColor = UIColor.blue.withAlphaComponent(alphaDigitColor)
    static let logementColor: UIColor = UIColor.red.withAlphaComponent(alphaDigitColor)
    static let transportColor: UIColor = UIColor.green.withAlphaComponent(alphaDigitColor)
    static let shoppingColor: UIColor = UIColor.yellow.withAlphaComponent(alphaDigitColor)
    static let activityColor: UIColor = UIColor.purple.withAlphaComponent(alphaDigitColor)
    static let costTextColor: UIColor = UIColor.darkGray
    static let costDigitButtonTextColor: UIColor = UIColor.white
    static let costDigitButtonBackgroundColor: UIColor = Configuration.purpleColor
    static let grayLevel = CGFloat(230)
    static let grayLevelColor: UIColor = UIColor(red: grayLevel/255, green: grayLevel/255, blue: grayLevel/255, alpha: 1)
    static let veryLightGray: UIColor = UIColor(red: 247/255, green: 247/255, blue: 247/255, alpha: 1)

    //MARK: Images

    static let transportImage = UIImage(named: "transport")!
    static let shoppingImage = UIImage(named: "shopping")!
    static let foodImage = UIImage(named: "food")!
    static let logementImage = UIImage(named: "logement")!
    static let activityImage = UIImage(named: "activity")!
    static let defaultPhoto = UIImage(named: "defaultPhoto")!
    
    static let ConcernedPeopleImages: [ConcernedPeople:UIImage] =
        [.Single:UIImage(named: "single")!,
         .Group:UIImage(named: "group")!]
    
    static let PaymentImages: [Payment:UIImage] =
        [.Card:UIImage(named: "card")!,
         .Cash:UIImage(named: "cash")!]
    
    //MARK: String

    static let transportLabel = "transport"
    static let shoppingLabel = "shopping"
    static let foodLabel = "food"
    static let logementLabel =  "logement"
    static let activityLabel =  "activity"
    static let updateTripNotificationKey = "updateTripNotificationKey"
    static let DocumentsDirectory = FileManager().urls(for: .documentDirectory, in: .userDomainMask).first!

    //MARK: Dictionaries

    static let informationForCategory: [Category:CategoryInformation] =
        [.Food:CategoryInformation(foodLabel,foodImage,foodColor),
         .Logement:CategoryInformation(logementLabel,logementImage,logementColor),
         .Transport:CategoryInformation(transportLabel,transportImage,transportColor),
         .Shopping:CategoryInformation(shoppingLabel,shoppingImage,shoppingColor),
         .Activity:CategoryInformation(activityLabel,activityImage,activityColor) ]

    //MARK: Currencies

    static let Currencies: [String:Double] =
        ["EUR":1,
         "USD":0.85,
         "JPY":0.00755,
         "HKD":0.109,
         "AED":0.232,
         "GBP":1.143,
         "MMK":0.0006256,
         "BOB":0.123,
         "PEN":0.261,
         "CAD":0.69,
         "NOK":0.103,
         "SEK":0.097,
         "BRL":0.227,
         "DKK":0.134,
         ]
}

struct CategoryInformation {
    var label: String
    var image:UIImage
    var color: UIColor
    
    init(_ label:String,_ image:UIImage,_ color:UIColor) {
        self.label = label
        self.image = image
        self.color = color
    }
}
