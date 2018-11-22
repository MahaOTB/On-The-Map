//
//  StudentLocationsTableViewController.swift
//  On the Map
//
//  Created by Maha on 16/11/2018.
//  Copyright © 2018 Maha_AlOtaibi. All rights reserved.
//

import UIKit

class StudentLocationsTableViewController: UITableViewController {
    
    // MARK: Outlet
    
    @IBOutlet weak var tvStudentLocations: UITableView!
    @IBOutlet weak var barbiPinIcon: UIBarButtonItem!
    @IBOutlet weak var barbiLogout: UIBarButtonItem!
    
    
    // MARK: Properties
    
    let cellID = "StudentLocationCell"
    private let noNameProvided: String = "No Name Provided"
    let showAddPinVCSegue = "showAddPinViewController"
    
    // MARK: LifeCycle
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        
        navigationController?.setNavigationBarHidden(false, animated: true)
        tableView.reloadData()
    }
    
    // MARK: Functions
    
    func OpenUrlThroughAlert(title: String, urlString: String) {
        
        let alert = Alerts.formulateAlert(title: title, message: urlString)
        
        alert.addAction(UIAlertAction(title: Alerts.AlertOpenAction, style: .default, handler: { _  in
            let error = ParseApi.openUrl(urlString: urlString)
            guard error == nil else {
                self.present(Alerts.formulateAlert(message: error!), animated: true)
                return
            }
        } ))
        
        present(alert, animated: true)
    }
    
    func OverwriteLocationAlert(title: String, message: String) {
        
        let alert = Alerts.formulateAlert(title: title, message: message)
        
        alert.addAction(UIAlertAction(title: Alerts.AlertOverwriteAction, style: .default, handler: { _  in
            self.performSegue(withIdentifier: self.showAddPinVCSegue, sender: self)
        } ))
        
        present(alert, animated: true)
    }
    
    func setUI(enabled: Bool) {
        barbiLogout.isEnabled = enabled
        barbiPinIcon.isEnabled = enabled
    }
    
    // MARK: Actions
    
    @IBAction func pinIconTapped(_ sender: Any) {
        
        // Check if this user had registered his location before
        
        setUI(enabled: false)
        
        guard AppDelegateValues.getAppDelegateObjectId() == nil else {
            OverwriteLocationAlert(title: Alerts.Warning, message: Alerts.OverwriteLocation)
            setUI(enabled: true)
            return
        }
        
        ParseApi.getAStudentLocation { (isPinned, errorDescription) in
            
            guard errorDescription == nil else {
                DispatchQueue.main.async {
                    self.present(Alerts.formulateAlert(title: Alerts.ErrorHandelingRequestTitle, message: errorDescription!), animated: true)
                }
                return
            }
            
            // If the user location not registered allow him to pin his location
            guard let isPinned = isPinned, isPinned  else  {
                DispatchQueue.main.async {
                    self.performSegue(withIdentifier: self.showAddPinVCSegue, sender: self)
                }
                return
            }
            
            // else show alert ask him to overwrite his previouse location
            DispatchQueue.main.async {
                self.OverwriteLocationAlert(title: Alerts.Warning, message: Alerts.OverwriteLocation)
            }
            self.setUI(enabled: true)
        }
    }
    
    @IBAction func logOut(_ sender: Any) {
        
        GenericMethod.deleteMethod { (errorDescription) in
            
            guard errorDescription == nil else {
                DispatchQueue.main.async {
                    self.present(Alerts.formulateAlert(title: Alerts.ErrorHandelingRequestTitle, message: errorDescription!), animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    @IBAction func logout(_ sender: Any) {
        
        GenericMethod.deleteMethod { (errorDescription) in
            
            guard errorDescription == nil else {
                DispatchQueue.main.async {
                    self.present(Alerts.formulateAlert(title: Alerts.ErrorHandelingRequestTitle, message: errorDescription!), animated: true)
                }
                return
            }
            
            DispatchQueue.main.async {
                self.dismiss(animated: true)
            }
        }
    }
    
    
    // MARK: UITableViewDataSource
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return StudentLocationsArray.sharedInstance.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID)!
        
        let studentLocations = StudentLocationsArray.sharedInstance
        
        if let firstName = studentLocations[indexPath.row].firstName, let lastName = studentLocations[indexPath.row].lastName, (!firstName.isEmpty || !lastName.isEmpty) {
            cell.textLabel?.text = "\(firstName) \(lastName)"
        }else {
            cell.textLabel?.text = noNameProvided
        }
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        let studentLocations = StudentLocationsArray.sharedInstance
        
        guard let mediaUrlString = studentLocations[indexPath.row].mediaURL else {
            present(Alerts.formulateAlert(message: Alerts.NoURLProvided), animated: true)
            return
        }
        
        OpenUrlThroughAlert(title: Alerts.OpenUrlTitle, urlString: mediaUrlString)
    }
    
}
