//
//  DictioModel.swift
//  knomee2
//
//  Created by Fiona Kate Morgan on 27/01/2023.
//

import Foundation
import Swift


let word = "hello"

var dictionary: [Word] = []


func getWords() -> [String] {
    var allWords: [String] = []
    
    if let wordsURL = Bundle.main.url(forResource: "words", withExtension: "json") {
        if let data = try? Data(contentsOf: wordsURL) {
            // we're OK to parse!
            if let json = parse(json: data) {
                for item in json {
                    allWords.append(item.0.lowercased())
                }
            }
        }
    }
    return allWords
}

func parse(json: Data) -> JSON? {
    if let parsed = try? JSON(data: json) {
        return parsed
    }
    return nil
}

func endGame() {
    print("game ended")
}

struct Word : Codable {
    var word: String
    var definition: String
}

struct Words : Codable {
    var words: [Word]
}

