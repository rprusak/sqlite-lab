//
//  SensorsController.swift
//  lab_sqlite
//
//  Created by r on 04/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import UIKit

class SensorsController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    var sensors: [Sensor] = []
    
    @IBOutlet var tableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        getData()
        tableView.reloadData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return sensors.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "SensorCell", for: indexPath)
        
        let tmp = sensors[indexPath.row]
        cell.textLabel?.text = tmp.name
        cell.detailTextLabel?.text = tmp.description
        
        return cell
    }
    
    func getData() {
        sensors = DataBaseAPI.getAllSensors()
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}
