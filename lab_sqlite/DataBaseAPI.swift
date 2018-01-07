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
    
    static func createRecordingsTable() {
        if (db == nil) {
            print("no connection to database!")
            return
        }
        
        let query = """
            CREATE TABLE IF NOT EXISTS recording (
                id INTEGER PRIMARY KEY AUTOINCREMENT,
                value REAL,
                timestamp INTEGER,
                sensorId INTEGER,
                FOREIGN KEY(sensorId) REFERENCES sensor(id));
            """
        if sqlite3_exec(db, query, nil, nil,nil) == SQLITE_OK {
            print("readings table created")
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
    
    static func addRecordingsToDatabase(recordsCount: Int) {
        if (db == nil) {
            print("no connection to database!")
            return
        }
        let sensors = DataBaseAPI.getAllSensors()
        
        if sensors.count == 0 {
            print("there is no sensor")
            return
        }
        
        let query = """
            INSERT INTO recording(value, timestamp, sensorId) VALUES(?, ?, ?);
            """
        
        if sqlite3_exec(db, "BEGIN TRANSACTION", nil, nil, nil) != SQLITE_OK {
            print("begin transaction failed");
        }
        
        var insertStatement: OpaquePointer? = nil
        
        if sqlite3_prepare_v2(db, query, -1, &insertStatement, nil) == SQLITE_OK {
            
            for _ in 1...recordsCount {
                let randomValue = Float(arc4random()) / Float(UINT32_MAX) * 100
                let randomTimestamp = Int(NSDate().timeIntervalSince1970) - Int(arc4random_uniform(31536000))
                let randomSensorId = Int(arc4random_uniform(UInt32(sensors.count)))
                
                sqlite3_bind_double(insertStatement, 1, Double(randomValue))
                sqlite3_bind_int(insertStatement, 2, Int32(randomTimestamp))
                sqlite3_bind_int(insertStatement, 3, Int32(randomSensorId))
                
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
        
        if sqlite3_exec(db, "COMMIT TRANSACTION", nil, nil, nil) != SQLITE_OK {
            print("commit transaction failed");
        }
        
    }
    
    static func getAllRecording() -> [Recording] {
        var result: [Recording] = []
        
        if (db == nil) {
            print("no connection to database!")
            return result
        }
        
        let query = """
            SELECT * FROM recording;
            """
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let id = sqlite3_column_int(queryStatement, 0)
                let value = sqlite3_column_double(queryStatement, 1)
                let timestamp = sqlite3_column_int(queryStatement, 2)
                let sensorId = sqlite3_column_int(queryStatement, 3)
                
                let r: Recording = Recording(id: Int(id), value: value, timestamp: Int(timestamp), sensorId: Int(sensorId))
                result.append(r)
            }
            
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return result
    }
    
    static func deleteAllRecords() {
        if (db == nil) {
            print("no connection to database!")
            return
        }
        
        let query = """
            DELETE FROM recording;
            """
        
        if sqlite3_exec(db, query, nil, nil,nil) == SQLITE_OK {
            print("all records deleted")
        } else {
            print("error while deleting records")
        }
        
    }
    
    static func getSmallestAndLargestTimestamp() -> (min: Int, max: Int) {
        if (db == nil) {
            print("no connection to database!")
            return (0, 0)
        }
        
        var smallestTimestamp: Int = 0
        var largestTimestamp: Int = 0
        
        let query = """
            SELECT min(timestamp), max(timestamp) FROM recording;
            """
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                smallestTimestamp = Int(sqlite3_column_int(queryStatement, 0))
                largestTimestamp = Int(sqlite3_column_int(queryStatement, 1))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return (smallestTimestamp, largestTimestamp)
    }
    
    static func getAverageRecordValue() -> Double {
        var result: Double = 0.0
        if (db == nil) {
            print("no connection to database!")
            return result
        }
        
        let query = """
            SELECT avg(value) FROM recording;
            """
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                result = sqlite3_column_double(queryStatement, 0)
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return result
    }
    
    static func getAverageValueAndRecordsNumberPerSensor() -> [(sensor: Int, values: Int, average: Double)] {
        var result: [(sensor: Int, values: Int, average: Double)] = []
        
        if (db == nil) {
            print("no connection to database!")
            return []
        }
        
        let query = """
            select sensorId, count(*), avg(value) from recording group by sensorId;
            """
        var queryStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, query, -1, &queryStatement, nil) == SQLITE_OK {
            while (sqlite3_step(queryStatement) == SQLITE_ROW) {
                let sensorId = sqlite3_column_int(queryStatement, 0)
                let values = sqlite3_column_int(queryStatement, 1)
                let avg = sqlite3_column_double(queryStatement, 2)
                result.append((sensor: Int(sensorId), values: Int(values), average: avg))
            }
        } else {
            print("SELECT statement could not be prepared")
        }
        
        sqlite3_finalize(queryStatement)
        
        return result
    }
    
}
