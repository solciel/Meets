/*

//
//  ViewRequestsTableViewController.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 11/30/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import UIKit

class ViewRequestsTableViewController: UITableViewController {
    var currentAppointment : Appointment?
    
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    @IBOutlet weak var meetingTitle: UITextField!
    
    @IBOutlet weak var firstName: UITextField!
    
    @IBOutlet weak var lastName: UITextField!
    
    
    @IBOutlet weak var companyName: UITextField!
 
    
    @IBOutlet weak var companyAddress: UITextField!
    
    @IBOutlet weak var companyDescription: UITextField!
    
    
    @IBOutlet weak var companyPhoneNumber: UITextField!
    

    
    
    @IBOutlet weak var timeDisplayed: UILabel!
    
    @IBOutlet weak var pickerView: UIDatePicker!
    
    @IBOutlet weak var meetingDescription: UITextField!
    
    @IBOutlet weak var companyWebsite: UITextField!
    
    @IBAction func datePickerSelected(_ sender: UIDatePicker) {
        updateTimeDisplayed(date: pickerView.date)
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
    
    func updateSaveButtonState() {
        let text = meetingTitle.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

    @IBAction func titleChanged(_ sender: UITextField) {
        updateSaveButtonState()
    }
    func updateTimeDisplayed(date: Date) {
        timeDisplayed.text = Appointment.dateFormatter.string(from: date)
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
        
        currentAppointment = Appointment(companyName: nameCompany, companyDescription: descriptionCompany, firstName: appFirstName, lastName: appLastName, address: addressCompany, date: appDate, phoneNumber: phone, website: appWebsite, type: AppointmentType.once, meetingDescription: descriptionMeeting, appointmentTitle: title, dateCode: pickerView.date)

        
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
*/
