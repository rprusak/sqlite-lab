//
//  RecordingsController.swift
//  lab_sqlite
//
//  Created by r on 07/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import UIKit

class RecordingsController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    @IBOutlet var tableView: UITableView!
    

    var readings: [Recording] = []
    
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
        return readings.count
    }
    
    func tableView(_ tableView: UITableView,
                   cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ReadingCell", for: indexPath)
        
        let tmp = readings[indexPath.row]
        cell.textLabel?.text = "Time: \(tmp.timestamp), value: \(tmp.value)"
        cell.detailTextLabel?.text = "From sensor: \(tmp.sensorId)"
        return cell
    }
    
    func getData() {
        readings = DataBaseAPI.getAllRecording();
    }
    
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        tableView.reloadData()
    }
}
