//
//  RequestsTableViewController.swift
//  Meets
//
//  Created by Rafael Alfonzo Marcelino on 11/25/20.
//  Copyright © 2020 Rafael Alfonzo. All rights reserved.
//

import UIKit
import GoogleAPIClientForREST
import GoogleSignIn
import GTMSessionFetcher

class RequestsTableViewController: UITableViewController {
    
    var currentMessageID = ""
    var appointments = [Appointment]()

    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return appointments.count
    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "RequestIdentifier", for: indexPath)

        let appointment = appointments[indexPath.row]
        cell.textLabel?.text = appointment.appointmentTitle
        cell.textLabel?.numberOfLines = 0
        cell.textLabel?.lineBreakMode = NSLineBreakMode.byWordWrapping
        

        return cell
    }
    
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    
    
    @IBAction func updateRequests(_ sender: Any) {
        getInboxMessages()
        
    }
    
    func getInboxMessages() {
        let gmailService = GTLRGmailService.init()
            
        let listQuery = GTLRGmailQuery_UsersMessagesList.query(withUserId: "me")
        listQuery.labelIds = ["INBOX"]
        
        let authorizer = GIDSignIn.sharedInstance()?.currentUser?.authentication?.fetcherAuthorizer()
        gmailService.authorizer = authorizer
     
        gmailService.executeQuery(listQuery) { (ticket, response, error) in
            if response != nil {
                print("Response: ")
                print(response)
                self.processMessages(response: response as! GTLRGmail_ListMessagesResponse, service: gmailService)
            } else {
                print("Error: ")
                print(error)
            }
        }
    }
    
    func processMessages(response: GTLRGmail_ListMessagesResponse, service: GTLRGmailService) {
        let messagesResponse = response as GTLRGmail_ListMessagesResponse
        
        for message in messagesResponse.messages! {
            let query = GTLRGmailQuery_UsersMessagesGet.query(withUserId: "me", identifier: message.identifier!)
            service.executeQuery(query) { (ticket, response, error) in
                var emails = response as! GTLRGmail_Message
                
                self.currentMessageID = emails.identifier!
                
                let parts = emails.payload?.parts?.filter({ (part) -> Bool in
                    if part.mimeType == "text/plain"{
                        return true
                    }
                    return false
                })
                for part in parts! {
                    print("email data:");
                    let encodedBody = part.body!.data!
                    print(encodedBody + "\n\n")
                    
                    let formattedEncodedBody = encodedBody.replacingOccurrences(of: "-", with: "+").replacingOccurrences(of: "_", with: "/")
                    
                    if let decodedBody = Data(base64Encoded: formattedEncodedBody, options: .ignoreUnknownCharacters){
                        let mesgBody = String(data: decodedBody, encoding: .utf8);
                        print(mesgBody);
                        print("\n")
                        let hour = parseHour(mesgBody!)
                        let day = parseDay(mesgBody!)
                        let month = parseMonth(mesgBody!)
                        let totalDate = month + " " + day + " at " + hour
                        print(totalDate)
                        
                        //add to appointents array
                        var currentAppointment = Appointment(companyName: "", companyDescription: "", firstName: "Rafael", lastName: "Alfonzo", address: "", date: totalDate, phoneNumber: "", website: "", type: AppointmentType.once, meetingDescription: "", appointmentTitle: "Rafael on " + totalDate, dateCode: Date())
                        currentAppointment.id = self.currentMessageID
                        
                        let newIndexPath = IndexPath(row: self.appointments.count, section: 0)
                        
                        var found = false;
                        for appointment in self.appointments {
                            if(appointment.id == currentAppointment.id) {
                                found = true;
                            }
                        }
                        if(!found) {
                            self.appointments.append(currentAppointment)
                            
                            self.tableView.insertRows(at: [newIndexPath], with: .automatic)
                            self.tableView.reloadData()
                        }
                        
                    }
                    
                }
            }
            
            
        }
        
        func parseHour(_ emailBody: String) -> String {
            
            let emailArray = emailBody.components(separatedBy: " ")
            
            for index in 0...(emailArray.count - 1) {
                if(emailArray[index].lowercased() == "p.m." || emailArray[index].lowercased() == "a.m.") {
                    return (emailArray[index - 1] + emailArray[index])
                }
            }
            return ""
        }
        
        func parseDay(_ emailBody: String) -> String {
            
            let emailArray = emailBody.components(separatedBy: " ")
            
            for index in 0...(emailArray.count - 1) {
                if(Int(emailArray[index]) != nil) {
                    return emailArray[index]
                }
            }
            return ""
        }
        
        func parseMonth(_ emailBody: String) -> String {
            
            let emailArray = emailBody.components(separatedBy: " ")
            for word in emailArray {
                if (word == "January" || word == "February") {
                    return word
                }
            }
            return ""
            
        }
        
    }
    
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            appointments.remove(at: indexPath.row)
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
            
            
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "editRequest",
            let navController = segue.destination as?
            UINavigationController,
            let AddAppointmentTableViewController =
            navController.topViewController as?
            AddAppointmentTableViewController {
            let indexPath = tableView.indexPathForSelectedRow!
            let selectedApp = appointments[indexPath.row]
            AddAppointmentTableViewController.currentAppointment = selectedApp
            AddAppointmentTableViewController.isRequest = true
            AddAppointmentTableViewController.requestsController = self
            AddAppointmentTableViewController.currentAppointmentID = selectedApp.id
        }
    }
    
    func updateList(id: String) {
        
        for index in 0...(appointments.count - 1) {
            if(appointments[index].id == id) {
                appointments.remove(at: index)
                break
            }
        }
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.tableView.reloadData()
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
