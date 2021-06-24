//
//  Calculate.swift
//  DatingDuell2
//
//  Created by tk on 11.06.21.
//

//Class with static function to calculate e.g. age, distance

import Foundation

class Calculate {
    
    static let basisDateFormat = "dd.MM.yyyy"
    static let basisDateFormatWithTime = "dd.MM.yyyy hh:mm:ss"
    
    static let dateFormatter: DateFormatter = {
        let dateform = DateFormatter()
        dateform.dateFormat = Calculate.basisDateFormat
        return dateform
    }()
    
    //calculate age from given birthdate
    static func calculateAge(dateString: String) -> Int{
         
        let birthdayDate = self.dateFormatter.date(from: dateString)
            let calendar: NSCalendar! = NSCalendar(calendarIdentifier: .gregorian)
            let now = Date()
            let calcAge = calendar.components(.year, from: birthdayDate!, to: now, options: [])
            let age = calcAge.year
            return age!

    }
    
    //calculate current date and time from given timestamp
    static func getActualDateAndTime(timeStamp: Double) -> String {
        let dateform = DateFormatter()
        dateform.dateFormat = Calculate.basisDateFormatWithTime
        let date = Date(timeIntervalSince1970: timeStamp)
        
        return dateform.string(from: date)
 
    }
    
    
    private static func degreesToRadians(degrees: Double) -> Double {
        return degrees * .pi / 180
    }

    //Calculate the distance between two eath coordinates
    static func distanceInKmBetweenEarthCoordinates(lat1: Double, lon1: Double, lat2: Double, lon2: Double) -> String {
        let earthRadiusKm: Double = 6371.0;

        let dLat = degreesToRadians(degrees: lat2 - lat1)
        let dLon = degreesToRadians(degrees: lon2 - lon1)

        let rad1 = degreesToRadians(degrees: lat1)
        let rad2 = degreesToRadians(degrees: lat2)
        

        let a = sin(dLat/2) * sin(dLat/2) +  sin(dLon/2) * sin(dLon/2) * cos(rad1) * cos(rad2)
        let c = 2 *  atan2( sqrt(a),  sqrt(1-a))
      return String(format: "%.0f", (earthRadiusKm * c) )
    }
    
    //calculate the procentual likes 
    static func procentualLikes(likes: Int, dislikes: Int) -> String {
        if (likes + dislikes) > 0 {
            let liked = Double(likes) / ( Double(likes) + Double(dislikes) ) * 100.0
//            print(liked)
            return String(format: "%.0f",  liked) + " % " + NSLocalizedString( "Calculate.prozentualLikes", comment:"procentualLikes")
        } else {
            
            return ""
        }
        
    }
}
