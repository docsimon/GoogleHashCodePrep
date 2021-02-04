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
    let signupLength: Int
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
                let newLib = Library(id: ids, signupLength: libData[1], books: bookListValue, maxBookProcess: libData[2])
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

//func computeCombo(arr: [Library], tmp: [Library]) {
//
//    // Add here logic to calculate the max output of libraries
//    var days = 0
//    var bookSet = [Book]() // I want to avoid duplicates
//    for i in 0..<tmp.count {
//        let lib = tmp[i]
//        days += lib.signupLength
//        if days <= globalData!.totalDays {
//            for b in lib.books {
//                if !bookSet.contains(b) {
//
//                }
//            }
//
//        } else {
//            break
//        }
//    }
//
//    for i in 0..<arr.count {
//        computeCombo(arr: Array(arr[(i+1)...]), tmp: tmp + [arr[i]])
//    }
//
//}

//computeCombo(arr: arr, tmp: [])
loadData()

// sort the libraries array
let libs = libraries.sorted { $0.signupLength > $1.signupLength }
var bookSet = Set<Int>()
for i in 0..<libs.count {
    //let powerOutput =
    for j in 0..<libs.count {
        if i == j { continue }
        
        
    }
}

func calculateOutput(library: Library) -> Int {
    let activeDays = globalData!.totalDays - library.signupLength
    let processingPower = activeDays * library.maxBookProcess
//    if processingPower > library.books.count {
//        return library.books.reduce(0, { (result, book) in
//            var res = 0
//            if !bookSet.contains(book.id) {
//                let res = result + book.value
//                bookSet.insert(book.id)
//                return res
//            }
//            return result
//        })
//    } else {
//        var result = 0
//        library.books.
//    }
    let count = min(processingPower, library.books.count)
    var result = 0
    for i in 0..<count {
        if !bookSet.contains(library.books[i].id) {
            result += library.books[i].value
            bookSet.insert(library.books[i].id)
        }
    }
    return result  
}
