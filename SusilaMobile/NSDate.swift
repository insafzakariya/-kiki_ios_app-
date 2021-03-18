//
//  NSDate.swift
//  SusilaMobile
//
//  Created by Sajith Konara on 10/11/20.
//

import Foundation

extension NSDate
{
    /**
     This adds a new method dateAt to NSDate.
     
     It returns a new date at the specified hours and minutes of the receiver
     
     :param: hours: The hours value
     :param: minutes: The new minutes
     
     :returns: a new NSDate with the same year/month/day as the receiver, but with the specified hours/minutes values
     */
    func dateAt(hours: Int, minutes: Int) -> NSDate
    {
        let calendar = NSCalendar(calendarIdentifier: NSCalendar.Identifier.gregorian)!
        
        //get the month/day/year componentsfor today's date.
        
        print("Now = \(self)")
        
        var date_components = calendar.components([NSCalendar.Unit.year,NSCalendar.Unit.month,NSCalendar.Unit.day],from: self as Date)
        
        //Create an NSDate for 8:00 AM today.
        date_components.hour = hours
        date_components.minute = minutes
        date_components.second = 0
        
        let newDate = calendar.date(from: date_components)!
        return newDate as NSDate
    }
}
