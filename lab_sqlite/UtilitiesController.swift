//
//  UtilitiesController.swift
//  lab_sqlite
//
//  Created by r on 04/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import UIKit

class UtilitiesController: UIViewController, UITextFieldDelegate {

    @IBOutlet weak var recordsNumberInput: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.recordsNumberInput.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // allow only numbers in text fiels
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        return Int(string) != nil
    }
    
    @IBAction func onGenerateRecordsButtonClicked(_ sender: UIButton) {
        print("generate records button clicked")
        self.resultTextView.text = ""
        if (recordsNumberInput.text?.isEmpty)! {
            self.resultTextView.text = "Enter number of records!";
            return
        }
        
        let recordsToGenerate : Int = Int(recordsNumberInput.text!)!
        
        if (recordsToGenerate <= 0) {
            self.resultTextView.text = "Invalid number of records!";
            return
        }
        
        let startTime = NSDate()
        DataBaseAPI.addRecordingsToDatabase(recordsCount: recordsToGenerate)
        let finishTime = NSDate()
                
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        self.resultTextView.text = "Generating \(recordsToGenerate) records took \(measuredTime)";
    }
    
    @IBAction func onDeleteAllRecordsButtonClicked(_ sender: Any) {
        print("delete all records button clicked")
        let startTime = NSDate()
        DataBaseAPI.deleteAllRecords()
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        self.resultTextView.text = "Deleting records took \(measuredTime)";
    }
    
    @IBAction func onFindLargestAndSmallestTimestampButtonClicked(_ sender: UIButton) {
        print("find largest and smallest timestamp clicked")
        let startTime = NSDate()
        let result = DataBaseAPI.getSmallestAndLargestTimestamp()
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        self.resultTextView.text = "Smallest timestamp: \(result.min), largest timestamp: \(result.max), time: \(measuredTime)"
    }
    
    @IBAction func onCalculateAverageReadingValuesButtonClicked(_ sender: UIButton) {
        print("calculate average values")
        let startTime = NSDate()
        let result = DataBaseAPI.getAverageRecordValue()
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        self.resultTextView.text = "Average value: \(result),  time: \(measuredTime)"
        
    }
    
    @IBAction func onCalculateNumberOfReadingAndAverageButtonClicked(_ sender: UIButton) {
        print("calculate number and average")
        self.resultTextView.text = ""
        let startTime = NSDate()
        let result = DataBaseAPI.getAverageValueAndRecordsNumberPerSensor()
        let finishTime = NSDate()
        let measuredTime = finishTime.timeIntervalSince(startTime as Date)
        
        for r in result {
            self.resultTextView.text = self.resultTextView.text + "Sensord: \(r.sensor) \nValues: \(r.values) \nAverage: \(r.average) \n"
        }
        
        self.resultTextView.text = self.resultTextView.text + "\n\(measuredTime)"
    }
    
}
