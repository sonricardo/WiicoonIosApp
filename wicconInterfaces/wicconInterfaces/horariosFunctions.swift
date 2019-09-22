//
//  horariosFunctions.swift
//  wicconInterfaces
//
//  Created by Luis Fernando Perez on 26/03/18.
//  Copyright © 2018 Ricardo Coronado. All rights reserved.
//

import Foundation

precedencegroup PowerPrecedence { higherThan: MultiplicationPrecedence }
infix operator ^^ : PowerPrecedence
func ^^ (radix: Int, power: Int) -> Int {
    return Int(pow(Double(radix), Double(power)))
}
// dom = bit2  lun = bit3  mar = bit 4 .......sab = bit8
func getStringDaysWithCodeWeekDays(codeWeek:Int64)->String {
    var daysString = ""
    for i in 0...7{
        if (2^^i & Int(codeWeek)) > 0 {
            switch(i){
            case 1: daysString = daysString+" DOM"
            case 2: daysString = daysString+" LUN"
            case 3: daysString = daysString+" MAR"
            case 4: daysString = daysString+" MIE"
            case 5: daysString = daysString+" JUE"
            case 6: daysString = daysString+" VIE"
            case 7: daysString = daysString+" SAB"
                
            default: break
                
            }
        }
    }
    return daysString
}

func getDayWeekByCodeWeek(codeWeek:Int) ->Int {
    for i in 1...7{
        if codeWeek & 2^^i > 0 {
            return i 
        }
    }
    return -1
}
func getExplotionDate(dayHorario:Int, hourHorario:Int, minuteHorario:Int) -> Date{
    
    let currentDate = Date()
    let currentCalendar = Calendar.current
    let currentHour =  currentCalendar.component(.hour, from: currentDate)
    let currentMinute =  currentCalendar.component(.minute, from: currentDate)
    let currentSecond =  currentCalendar.component(.second, from: currentDate)
    let currentDayWeek =  currentCalendar.component(.weekday, from: currentDate)

    var daysToBreak = 0;
    let hoursToBreak = hourHorario - currentHour;
    let minutesToBreak = minuteHorario - currentMinute;
    let secondToBreak = -currentSecond
    
    if(dayHorario < currentDayWeek){
        daysToBreak = 7 - currentDayWeek + dayHorario;
    }
    else if(dayHorario > currentDayWeek){
        daysToBreak = dayHorario - currentDayWeek;
    }
    else if(dayHorario == currentDayWeek){
        if( currentHour > hourHorario){
            daysToBreak = 7;
        }
        else if (currentHour < hourHorario){
            daysToBreak = 0;
        }
        else if (currentHour == hourHorario ) {
            if( currentMinute >= minuteHorario ){
                daysToBreak = 7;
            }
            else {
                daysToBreak = 0;
            }
        }
    }
    var dateExplotion = currentCalendar.date(byAdding: .day, value: daysToBreak, to: currentDate)
    dateExplotion = currentCalendar.date(byAdding: .hour, value: hoursToBreak, to: dateExplotion!)
    dateExplotion = currentCalendar.date(byAdding: .minute, value: minutesToBreak, to: dateExplotion!)
    dateExplotion = currentCalendar.date(byAdding: .second, value: secondToBreak, to: dateExplotion!)
    
    return dateExplotion!
    
   
}
func getIpForRequest(focoList:FocoListM)->String{
    var ip = ""
    switch focoList.statusConnect {
    case StatusConnection.ACCESS_POINT: ip = "192.168.4.1"
    case StatusConnection.LAN: ip = (focoList.ip)!
    case StatusConnection.INT_REMOTE: ip = IP_SERVIDOR
    case StatusConnection.DISABLE: break//a la verga
        
    }
    return ip
}


