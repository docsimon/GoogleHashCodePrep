//
//  main.swift
//  GoogleHashCode
//
//  Created by doc on 03/02/2021.
//

import Foundation
import Cocoa

let arr = [1,2,3]

struct GlobalData {
    let totalDays: Int
    let libraries: Int
    let books: Int
    let bookValue: [Int]
}

struct Book {
    let id: Int
    let value: Int
}

struct Library {
    let id: Int
    let subscriptionLength: Int
    let books: [Book]
    let maxBookProcess: Int
    func calculateOutput() {
        
    }
}

var globalData: GlobalData?
var libraries = [Library]()
var valueDict = [Int: Int]()

func loadData() {
   
    if let filepath = Bundle.main.path(forResource: "data", ofType: "txt") {
        do {
            let contents = try String(contentsOfFile: filepath)
            let datas = contents.split(separator: "\n")
            let firstLine = datas[0].split(separator: " ").map {Int($0)!}
            let booksValue = datas[1].split(separator: " ").map {Int($0)!}
            globalData = GlobalData(totalDays: firstLine[2], libraries: firstLine[1], books: firstLine[0], bookValue: booksValue)
            // Updating the book value dictionary
            for j in 0..<booksValue.count {
                valueDict[j] = booksValue[j]
            }
            // Creating libraries
            var i = 2
            var ids = 0
            while i < datas.count {
                var bookIdValue = [Book]()
                let libData = datas[i].split(separator: " ").map {Int($0)!}
                let books = datas[i+1].split(separator: " ").map {Int($0)!}
                for j in 0..<books.count {
                    bookIdValue.append(Book(id: books[j], value: valueDict[books[j]]!))
                }
                let bookListValue = bookIdValue.sorted { $0.value > $1.value }
                let newLib = Library(id: ids, subscriptionLength: libData[1], books: bookListValue, maxBookProcess: libData[2])
                libraries.append(newLib)
                i += 2
                ids += 1
            }
            
        } catch {
            print("Content couldn't be loaded")
        }
    } else {
        print("File not found!")
    }
   
}



func computeCombo(arr: [Int], tmp: [Int]) {
    
        print(tmp)
    for i in 0..<arr.count {
        computeCombo(arr: Array(arr[(i+1)...]), tmp: tmp + [arr[i]])
    }
    
}

//computeCombo(arr: arr, tmp: [])
loadData()

// sort the libraries array
let libs = libraries.sorted { $0.subscriptionLength > $1.subscriptionLength }

libs.forEach {
    print($0)
}



