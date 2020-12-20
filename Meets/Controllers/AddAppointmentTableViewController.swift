//
//  AddAppointmentTableViewController.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 11/12/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import UIKit
import EventKit

class AddAppointmentTableViewController: UITableViewController {
    
    var currentAppointmentID = ""
    var requestsController: RequestsTableViewController?
    var isRequest = false;
    var currentAppointment : Appointment?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var meetingTitle: UITextField!
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var companyName: UITextField!
    @IBOutlet weak var companyAddress: UITextField!
    @IBOutlet weak var companyDescription: UITextField!
    
    @IBOutlet weak var companyPhoneNumber: UITextField!
    @IBOutlet weak var companyWebsite: UITextField!
    
    @IBOutlet weak var timeDisplayed: UILabel!
    
    @IBOutlet weak var meetingDescription: UITextField!
    
    
    @IBOutlet weak var pickerView: UIDatePicker!
    
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
    updateTimeDisplayed(date: pickerView.date)
}
    
    let dateLabelIndexPath = IndexPath(row: 0, section: 5)
    let datePickerIndexPath = IndexPath(row: 1, section: 5)
    let notesTextViewIndexPath = IndexPath(row: 0, section: 6)
    
    let normalCellHeight: CGFloat = 44
    let largeCellHeight: CGFloat = 200
    
    override func tableView(_ tableView: UITableView, heightForRowAt
    indexPath: IndexPath) -> CGFloat {
        switch indexPath {
        case datePickerIndexPath:
            return isPickerHidden ? 0 :
            largeCellHeight
        case notesTextViewIndexPath:
            return largeCellHeight
        default:
            return normalCellHeight
        }
    }

 
    override func tableView(_ tableView: UITableView, didSelectRowAt
    indexPath: IndexPath) {
        if indexPath == dateLabelIndexPath {
            isPickerHidden = !isPickerHidden
            timeDisplayed.textColor = isPickerHidden ? .black :
            tableView.tintColor
            tableView.beginUpdates()
            tableView.endUpdates()
        }
    }
    //
    
    var isPickerHidden = true

    
    func updateTimeDisplayed(date: Date) {
        timeDisplayed.text = Appointment.dateFormatter.string(from: date)
    }

    func updateSaveButtonState() {
        let text = meetingTitle.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }
    
    
    
    @IBAction func textEditingChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    
    
    @IBAction func returnPressed(_ sender: UITextField) {
        meetingTitle.resignFirstResponder()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender:
    Any?) {
        super.prepare(for: segue, sender: sender)
        
        guard segue.identifier == "saveUnwind" else { return }
        
        let title = meetingTitle.text!
        let appLastName = lastName.text!
        let appFirstName = firstName.text!
        let nameCompany = companyName.text!
        let addressCompany = companyAddress.text!
        let descriptionCompany = companyDescription.text!
        let phone = companyPhoneNumber.text!
        let appWebsite = companyWebsite.text!
        let appDate = Appointment.dateFormatter.string(from: pickerView.date)
        let descriptionMeeting = meetingDescription.text!
        
        
        var hour = self.currentAppointment!.hour
        var day = self.currentAppointment!.day
        var month = self.currentAppointment!.month
        
        currentAppointment = Appointment(companyName: nameCompany, companyDescription: descriptionCompany, firstName: appFirstName, lastName: appLastName, address: addressCompany, date: appDate, phoneNumber: phone, website: appWebsite, type: AppointmentType.once, meetingDescription: descriptionMeeting, appointmentTitle: title, dateCode: pickerView.date)
        currentAppointment!.id = currentAppointmentID
        self.currentAppointment!.hour = hour
        self.currentAppointment!.day = day
        self.currentAppointment!.month = month
        self.currentAppointment!.year = 2020
        
        //adjust requests table
        if (isRequest) {
            requestsController?.updateList(id: currentAppointmentID)
        }
        
        //add event to calendar
        
        let eventStore: EKEventStore = EKEventStore()
        
        eventStore.requestAccess(to: .event) { (granted,error) in
            if (granted) && (error == nil) {
                print("granted access to event store")
                let event:EKEvent = EKEvent(eventStore: eventStore)
               
                
                //create dates

                /*
                let startingDateFormatter = DateFormatter()
                startingDateFormatter.locale = Locale(identifier: "en_US_POSIX")
                startingDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
                startingDateFormatter.timeZone = TimeZone(secondsFromGMT: 0)
                
                //hardcoded to fix
                let timeString1 = "2020-01-23-T13:00:00-08:00"
                let timeString2 = "2020-01-23-T13:01:00-08:00"
                
                let sampleString = "2020-12-19T16:39:57-08:00"
                
        
                //dates created
                let datetime = startingDateFormatter.date(from: timeString1)
                
                let datetime2 = startingDateFormatter.date(from: timeString2)
                */
                
                
                let formatter = DateFormatter()
                formatter.dateFormat = "dd-MM-yyyy HH:mm:ss Z"
                
                formatter.locale = Locale.current
                formatter.timeZone = TimeZone.current
                
                var hourString = ""
                var dayString = ""
                var monthString = ""
                
                if(hour < 10) {
                    hourString = "0" + String(hour)
                }
                else {
                    hourString = String(hour)
                }
                if(day < 10) {
                    dayString = "0" + String(day)
                }
                else {
                    dayString = String(hour)
                }
                if(month < 10) {
                    monthString = "0" + String(month)
                }
                else {
                    monthString = String(hour)
                }
                
                var dateString = "";
                dateString = dateString + dayString + "-";
                dateString = dateString + monthString + "-";
                dateString = dateString + String(self.currentAppointment!.year)
                dateString = dateString + " " + hourString + ":00:00 +0000"

                //let datetime = formatter.date(from: "03-01-2020 20:00:00 +0000")
                let datetime = formatter.date(from: dateString)
                let datetime2 = formatter.date(from: dateString)
                print(datetime!)
            
                
                event.title = self.currentAppointment!.appointmentTitle
                
               event.startDate = datetime
               event.endDate = datetime2
                
                event.notes = "notes here"
                
                event.calendar = eventStore.defaultCalendarForNewEvents
                do {
                    try eventStore.save(event, span: .thisEvent)
                }
                catch let error as NSError{
                    print("error: \(error)")
                }
                print("save event")
            }
            else {
                print("error: \(error)")
            }
            
        }

        
    }
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        if let currentAppointment = currentAppointment {
            navigationItem.title = "View Appointment"
            meetingTitle.text = currentAppointment.appointmentTitle
            lastName.text = currentAppointment.lastName
            firstName.text! = currentAppointment.firstName
            companyName.text = currentAppointment.companyName
            companyAddress.text = currentAppointment.address
            companyDescription.text = currentAppointment.companyDescription
            companyPhoneNumber.text = currentAppointment.phoneNumber
            companyWebsite.text = currentAppointment.website
            pickerView.date = currentAppointment.dateCode
            meetingDescription.text = currentAppointment.meetingDescription
            

        }
        else {
            pickerView.date = Date().addingTimeInterval(24*60*60)
        }
        
        
        updateTimeDisplayed(date: pickerView.date)
        updateSaveButtonState()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 6
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        switch section {
        case 0: return 1;
        case 1: return 2;
        case 2: return 3;
        case 3: return 2;
        case 4: return 2;
        default: return 1;
        }
    }

    @IBAction func cancelEditing(_ sender: Any) {
        dismiss(animated: true)
    }
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
