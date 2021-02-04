//
//  main.swift
//  GoogleHashCode
//
//  Created by doc on 03/02/2021.
//

import Foundation
import Cocoa

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
   
    if let filepath = Bundle.main.path(forResource: "b_read_on", ofType: "txt") {
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

loadData()

// sort the libraries array
let libs = libraries.sorted { $0.signupLength < $1.signupLength }
var bookSet = Set<Int>()
var libBlackList = Set<Int>()
var arrTotal = Array<[(Library, Int, [Int])]>(repeating: [], count: libs.count)
for i in 0..<libs.count {
    var offset = libraries[i].signupLength
    libBlackList.removeAll()
    let firstLibTuple = spotCalc(lib: libraries[i])
    arrTotal[i].append(firstLibTuple)
    libBlackList.insert(libraries[i].id)
    while offset < globalData!.totalDays {
        let maxLib = findMaxAverageOutput(libs: libs, exclusions: libBlackList, offset: offset)
        offset += maxLib.0.signupLength
        libBlackList.insert(maxLib.0.id)
        arrTotal[i].append(maxLib)
    }
}

// Calculate the best sequence
let sortedArr = arrTotal.sorted { elem1, elem2 in
    var tot1 = 0
    var tot2 = 0
    elem1.forEach {
        tot1 += $0.1
    }
    elem2.forEach {
        tot2 += $0.1
    }
    return tot1 > tot2
}
//
//let arr1 = arrTotal[0]
//let arr2 = arrTotal[1]
//
//var tot1 = 0
//arr1.forEach {
//    tot1 += $0.1
//}
//var tot2 = 0
//arr2.forEach {
//    tot2 += $0.1
//}
//
//
//print("tot1: ", tot1)
//print("tot2: ", tot2)

let result = sortedArr[0]
result.forEach {
    print($0.0.id, " ", $0.2.count)
    let arr = $0.2
    arr.forEach {
        print($0, terminator: " ")
    }
    print("")
}
//
//arrTotal.forEach {
//    print($0)
//}

func calculateOutput(library: Library, offset: Int) -> (Double, Int, [Int]) {
    let activeDays = globalData!.totalDays - offset - library.signupLength
    let processingPower = activeDays * library.maxBookProcess
    let count = max(min(processingPower, library.books.count), 0)
    var result = 0
    var bookSequence = [Int]()
    for i in 0..<count {
        if !bookSet.contains(library.books[i].id) {
            result += library.books[i].value
            bookSet.insert(library.books[i].id)
            bookSequence.append(library.books[i].id)
        }
    }
    return (Double(result)/Double(activeDays), result, bookSequence)
}

func findMaxAverageOutput(libs: [Library], exclusions: Set<Int>, offset: Int) -> (Library, Int, [Int]) {
    var maxOutput: (Double, Int, Library, [Int]) = (0, 0, libs[0], [])
    for i in 0..<libs.count {
        if !exclusions.contains(libs[i].id) {
            let output = calculateOutput(library: libs[i], offset: offset)
            if output.0 >= maxOutput.0 {
                maxOutput.0 = output.0
                maxOutput.2 = libs[i] // Library
                maxOutput.1 = output.1 // Tot value of books
                maxOutput.3 = output.2 // Array of books id
                
            }
        }
    }
    
    return (maxOutput.2, maxOutput.1, maxOutput.3)
}

func spotCalc(lib: Library) -> (Library, Int, [Int]) {
    var result = 0
    var arr = [Int]()
    for i in 0..<lib.books.count {
        result += lib.books[i].value
        arr.append(lib.books[i].id)
    }
    return (lib, result, arr)
}
