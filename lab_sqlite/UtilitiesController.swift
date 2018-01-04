//
//  UtilitiesController.swift
//  lab_sqlite
//
//  Created by r on 04/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import UIKit

class UtilitiesController: UIViewController {

    @IBOutlet weak var recordsNumberInput: UITextField!
    @IBOutlet weak var resultTextView: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func onGenerateRecordsButtonClicked(_ sender: UIButton) {
        print("generate records button clicked")
        self.resultTextView.text = ""
    }
    
    @IBAction func onDeleteAllRecordsButtonClicked(_ sender: Any) {
        print("delete all records button clicked")
        self.resultTextView.text = ""
    }
    
    @IBAction func onFindLargestAndSmallestTimestampButtonClicked(_ sender: UIButton) {
        print("find largest and smallest timestamp clicked")
        self.resultTextView.text = ""
    }
    
    @IBAction func onCalculateAverageReadingValuesButtonClicked(_ sender: UIButton) {
        print("calculate average values")
        self.resultTextView.text = ""
    }
    
    @IBAction func onCalculateNumberOfReadingAndAverageButtonClicked(_ sender: UIButton) {
        print("calculate number and average")
        self.resultTextView.text = ""
    }
    
    
}
