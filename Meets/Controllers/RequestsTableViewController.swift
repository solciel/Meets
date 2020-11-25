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
        return 0
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
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
                self.getFirstMessageIdFromMessages(response: response as! GTLRGmail_ListMessagesResponse)
            } else {
                print("Error: ")
                print(error)
            }
        }
    }
    
    func getFirstMessageIdFromMessages(response: GTLRGmail_ListMessagesResponse) {
        let messagesResponse = response as GTLRGmail_ListMessagesResponse
        print("Latest Message: ")
        print(messagesResponse.messages![0].identifier)
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
