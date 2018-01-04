//
//  DataBaseAPI.swift
//  lab_sqlite
//
//  Created by r on 04/01/2018.
//  Copyright © 2018 r. All rights reserved.
//

import Foundation

class DataBaseAPI {
    static var db:OpaquePointer? = nil
    
    static func connectToDataBase() {
        let docDir = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let dbFilePath = NSURL(fileURLWithPath: docDir).appendingPathComponent("demo.db")?.path
        
        print(dbFilePath ?? "unknown")
        
        if sqlite3_open(dbFilePath, &db) == SQLITE_OK {
            print("connection ok")
        } else {
            print("connection fail")
        }
    }
    
    static func createSensorsTable() {
        if (db == nil) {
            print("no connection to database!")
            return
        }
        
        let query = """
            CREATE TABLE IF NOT EXISTS sensor (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                name TEXT,
                description TEXT);
            """
        if sqlite3_exec(db, query, nil, nil,nil) == SQLITE_OK {
            print("sensors table created")
        } else {
            print("error while creating sensors table")
        }
    }
    
    static func getSensorsCount() -> Int {
        var result: Int = -1;
        
        if (db == nil) {
            print("no connection to database!")
            return result
        }
        
        let query = """
            SELECT COUNT(*) FROM sensor;
            """
        var queryStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            if sqlite3_step(queryStatement) == SQLITE_ROW {
                let count = sqlite3_column_int(queryStatement, 0)
                print("number of sensors: \(count)")
                result = Int(count);
            } else {
                print("Query returned no results")
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        return result;
    }
    
    static func addSensorsToDataBase() {
        if (db == nil) {
            print("no connection to database!")
            return
        }
        
        let query = """
            INSERT INTO sensor(name, description) VALUES(?, ?);
            """
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK {
            
            for i in 1...20 {
                let name = "Sensor \(i)"
                let description = "Description of sensor \(i)"
                sqlite3_bind_text(insertStatement, 1, name, -1, nil)
                sqlite3_bind_text(insertStatement, 2, description, -1, nil)
                
                if sqlite3_step(insertStatement) == SQLITE_DONE {
                    print("Successfully inserted row.")
                } else {
                    print("Could not insert row.")
                }
             
                sqlite3_reset(insertStatement)
            }
            
            sqlite3_finalize(insertStatement)
        } else {
            print("INSERT statement could not be prepared.")
        }
    }
    
    static func getAllSensors() -> [Sensor] {
        var result: [Sensor] = []
        
        if (db == nil) {
            print("no connection to database!")
            return result
        }
        
        let query = """
            SELECT * FROM sensor;
            """
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(cString: sqlite3_column_text(queryStatement, 1)!)
                let description = String(cString: sqlite3_column_text(queryStatement, 2)!)
                let s: Sensor = Sensor(id: Int(id), name: name, description: description)
                result.append(s)
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return result
    }
}
