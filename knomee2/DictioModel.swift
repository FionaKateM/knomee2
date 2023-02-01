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


func getWordsOf(length: Int) -> [String] {
    var allWords: [String] = []
    
    if let wordsURL = Bundle.main.url(forResource: "\(length)-letter-words", withExtension: "json") {
        if let data = try? Data(contentsOf: wordsURL) {
            // we're OK to parse!
            if let json = parse(json: data) {
                for item in json {
                    if let word = item.1.dictionaryValue.first?.value.rawValue {
                        allWords = allWords + ["\(word)"]
                    }
                }
            }
        }
    }
    return allWords
}

func getAllWords() -> [String] {
    var allWords: [String] = []
    
    for i in 4...15 {
        allWords.append(contentsOf: getWordsOf(length: i))
    }
    
    return allWords.sorted()
}

func getWord() -> String {
    let word = getCorrectWords().randomElement() ?? ""
    
    return word
}

func getCorrectWords() -> [String] {
    var correctWords: [String] = []
    if let wordsURL = Bundle.main.url(forResource: "correct-words", withExtension: "json") {
        if let data = try? Data(contentsOf: wordsURL) {
            // we're OK to parse!
            if let json = parse(json: data) {
                print("json: \(json)")
                if let keys = json.dictionary?.keys {
                    correctWords.append(contentsOf: keys)
                    print("keys: \(keys)")
                }
            }
        }
    }
    
    return correctWords
    
}

func parse(json: Data) -> JSON? {
    if let parsed = try? JSON(data: json) {
        return parsed
    } else {
        print(json)
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

