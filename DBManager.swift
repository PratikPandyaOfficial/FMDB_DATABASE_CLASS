//
//  DBManager.swift
//  DBDemo
//
//  Created by Patrick.
//  Copyright © 2019 Patrick. All rights reserved.
//

import Foundation

var database: FMDatabase!

// MARK: - CHECK AND COPY DATABASE

func copyDatabaseIfNeeded() {
    // Move database file from bundle to documents folder

    let fileManager = FileManager.default
    guard let documentsUrl = fileManager.urls(for: .documentDirectory, in: .userDomainMask).first else { return }
    let finalDatabaseURL = documentsUrl.appendingPathComponent("Clipboard_DB.db")
    
    
    do {
        if !fileManager.fileExists(atPath: finalDatabaseURL.path) {
            print("DB does not exist in documents folder")

            if let dbFilePath = Bundle.main.path(forResource: "Clipboard_DB", ofType: "db") {
                try fileManager.copyItem(atPath: dbFilePath, toPath: finalDatabaseURL.path)
            } else {
                print("Uh oh - foo.db is not in the app bundle")
            }
        } else {
            print("Database file found at path: \(finalDatabaseURL.path)")
        }
        database = FMDatabase(path: finalDatabaseURL.path)
    } catch {
        print("Unable to copy foo.db: \(error)")
    }
}

// MARK: - GET ALL URL FROM DATABASE

func getLocalURL(url: String) {
    
    if !database.isOpen {
        database.open()
    }
    
    let selectquery = "SELECT * FROM clipboardUrl WHERE Url = ?"
    
    do {
        let result = try database.executeQuery(selectquery, values: [url])
        while result.next() {
            print("SELECT RESULT: \(String(describing: result.resultDictionary))")
        }
    } catch let error {
        print("ERROR SELECT: \(error.localizedDescription)")
    }
    database.close()
}


// MARK: - INSERT NEW URL IN DATABASE

func addnew(url: String) {
    if !database.isOpen {
        database.open()
    }
    let insertquery = "INSERT INTO clipboardUrl (Url) VALUES (?)"
    let result = database.executeUpdate(insertquery, withArgumentsIn: [url])
    if result {
        print("INSERT SUCCESS.")
    } else {
        print("INSERT FAILED.")
    }
    database.close()
}

// MARK: - DELETE URL FROM DATABASE

func deletefromdatabase(url: String) {
    if !database.isOpen {
        database.open()
    }
    let deletequery = "DELETE FROM clipboardUrl WHERE Url = ?"
    let result = database.executeUpdate(deletequery, withArgumentsIn: [url])
    if result {
        print("DELETE SUCCESS.")
    } else {
        print("DELETE FAILED.")
    }
    database.close()
}
