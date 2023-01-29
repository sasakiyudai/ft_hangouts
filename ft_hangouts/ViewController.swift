//
//  ViewController.swift
//  ft_hangouts
//
//  Created by Yudai Sasaki on 2023/01/28.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet weak var tableView: UITableView!
    
    var contacts: [Contact] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.dataSource = self
        tableView.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData() 
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return contacts.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        let contact = contacts[indexPath.row]
        
        if contact.isImportant {
            cell.textLabel?.text = "【重要】 " + contact.name!
        } else {
            cell.textLabel?.text = contact.name!
        }
        return cell
    }
    
    func getData() {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        
        do {
            contacts = try context.fetch(Contact.fetchRequest())
        } catch {
            print("failed to fetch contacts")
        }
    }
    
    // delete
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
        if editingStyle == .delete {
            let contact = contacts[indexPath.row]
            context.delete(contact)
            (UIApplication.shared.delegate as! AppDelegate).saveContext()
            do {
                contacts = try context.fetch(Contact.fetchRequest())
            } catch {
                print("failed to fetch contacts")
            }
        }
        tableView.reloadData()
    }
}

