//
//  File.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 11/11/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import Foundation

struct Appointment {
    
    var companyName: String = ""
    var companyDescription: String = ""
    var firstName: String = ""
    var lastName: String = ""
    var address: String = ""
    var dateCode: Date = Date() //used for sorting
    var date : String = ""
    var phoneNumber: String = ""
    var website: String = ""
    var hours: [String] = []
    var type: AppointmentType = .once
    var meetingDescription: String = ""
    var appointmentTitle: String = ""
    var id : String = "";
    var status: AppointmentStatus = .pending
    
    init(companyName: String, companyDescription: String, firstName: String, lastName: String, address: String, date: String, phoneNumber: String, website: String, type: AppointmentType, meetingDescription: String, appointmentTitle: String, dateCode: Date) {
        
        self.companyName = companyName
        self.companyDescription = companyDescription
        self.firstName = firstName
        self.lastName = lastName
        self.address = address
        self.date = date
        self.phoneNumber = phoneNumber
        self.website = website
        self.type = type
        self.meetingDescription = meetingDescription
        self.appointmentTitle = appointmentTitle
        
    }
    
    static func loadAppointments() -> [Appointment]? {
        return nil
        //TODO: load from disk
    }
    
    static func loadSampleAppointments() -> [Appointment] {
        return [Appointment]()
    }
    
    static let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateStyle = .short
        formatter.timeStyle = .short
        return formatter
    }()
    
    
}

enum AppointmentType {
    case once, daily, weekly, biweekly, monthly, yearly
}

enum AppointmentStatus {
    case attended, missed, rescheduled, pending
}
