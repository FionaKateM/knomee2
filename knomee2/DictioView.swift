//
//  DictioView.swift
//  knomee2
//
//  Created by Fiona Kate Morgan on 27/01/2023.
//

import SwiftUI

struct DictioView: View {
    
    var correctWord = "hello"
    @State private var enteredWord = ""
    @State var words: [String] = []
    @State var wordColour = Color.black
    @State var visualisedWords: [String] = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
//    @State var guessedWords: [String: Color] = ["a": .black, "b": .black, "c": .black, "d": .black, "e": .black, "f": .black, "g": .black, "h": .black, "i": .black, "j": .black, "k": .black, "l": .black, "m": .black, "n": .black, "o": .black, "p": .black, "q": .black, "r": .black, "s": .black, "t": .black, "u": .black, "v": .black, "w": .black, "x": .black, "y": .black, "z": .black]
//    @ObservedObject var visualisedWords = WordModel()
    @State var wordLocation: [String] = []
    @FocusState private var wordInFocus: Bool
    
    @State var colourIndices = (0, 26)
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                TextField("Enter word", text: $enteredWord)
                    .textFieldStyle(.roundedBorder)
                    .textCase(.lowercase)
                    .padding(.horizontal)
                    .foregroundColor(wordColour)
                    .focused($wordInFocus)
                    .onChange(of: enteredWord) {newValue in
                        if words.contains(newValue.lowercased()) {
                            wordColour = .black
                        } else {
                            wordColour = .red
                        }
                    }
                    .onSubmit {
                        checkWord()
                    }
                Spacer()
            }
            HStack {
//                List(visualisedWords.count, id: \.self) { (index, word) in
//                    Text(word.lowercased())
////                        .foregroundColor(visualisedWords.dict[word])
//                        .foregroundColor(visualisedWords.firstIndex(of: word) ? .red : .blue)
//                List {
//                    ForEach(0..<visualisedWords.count) { i in
//                        Text(visualisedWords[1])
//                            .foregroundColor((i < colourIndices.0 || i > colourIndices.1) ? .gray : .black)
//                    }
//                }
                List(visualisedWords, id: \.self) { word in
                    if let index = visualisedWords.firstIndex(of: word) {
                        Text(word)
                            .foregroundColor((index < colourIndices.0 || index > colourIndices.1) ? .gray : .black)
                    }
                }
                Spacer()
                Spacer()
            }
        }
        .onAppear {
            if words.count == 0 {
                words.append(contentsOf: getWords())
                words = words.sorted()
            }
            
            if !wordLocation.contains(correctWord.lowercased()) {
                wordLocation.append(correctWord.lowercased())
            }
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                self.wordInFocus = true
              }
        }
    }
    
    func checkWord() {
        if !words.contains(enteredWord.lowercased()) {
            // not a valid word
            print("not a valid word")
            enteredWord = ""
            wordInFocus = true
            
        } else if correctWord.lowercased() == enteredWord.lowercased() {
            print("correct answer")
            endGame()
        } else if visualisedWords.contains(enteredWord.lowercased()) {
            // word has already been guessed
            print("word already guessed")
            wordInFocus = true
        } else {
            // correct word and not guessed yet
            print("valid guess")
            visualisedWords.append(enteredWord.lowercased())
            visualisedWords.sort()
            wordLocation.append(enteredWord.lowercased())
            wordLocation.sort()
//            updateColoursWith(word: enteredWord.lowercased())
            updateColours()
            enteredWord = ""
            wordInFocus = true
        }
    }
    
//    func updateColoursWith(word: String) {
//        print("update colours")
//        let words = wordLocation.sorted()
//        let answerIndex = words.firstIndex(of: correctWord.lowercased()) ?? 5
//        print("answer index: \(answerIndex)")
//        let enteredWordIndex = words.firstIndex(of: word) ?? 5
//        print("entered word index: \(enteredWordIndex)")
//        let visualisedLocationIndex = visualisedWords.firstIndex(of: enteredWord) ?? 0
//        let totalVisualsed = visualisedWords.count
//
//        if enteredWordIndex < answerIndex {
//            print("word is later")
//            // colour everything below it grey
//            for i in 0..<visualisedLocationIndex {
//                let word = visualisedWords.dict.keys.sorted()[i]
//                visualisedWords.dict[word] = .gray
//                print("\(word) is gray")
//            }
//
//        } else if enteredWordIndex > answerIndex {
//            print("word is earlier")
//            // colour everything above it grey
//
//            for i in (visualisedLocationIndex+1)..<totalVisualsed {
//                let word = visualisedWords.dict.keys.sorted()[i]
//                visualisedWords.dict[word] = .gray
//                print("\(word) is gray")
//            }
//        }
//    }
    
    func updateColours() {
        
        if wordLocation.firstIndex(of: enteredWord.lowercased()) ?? 1 < wordLocation.firstIndex(of: correctWord.lowercased()) ?? 0 {
            // Set min to index of entered word
            if let index = visualisedWords.firstIndex(of: enteredWord.lowercased()) {
                if index > colourIndices.0 {
                    colourIndices.0 = index
                } else {
                    colourIndices.0 += 1
                }
                
                // add 1 to the upper boundary as there is now an additional element earlier in the array
                colourIndices.1 += 1
            }
            
        } else if wordLocation.firstIndex(of: enteredWord.lowercased()) ?? 0 > wordLocation.firstIndex(of: correctWord.lowercased()) ?? 1 {
            // set max to index of entered word
            if let index = visualisedWords.firstIndex(of: enteredWord.lowercased()) {
                if index < colourIndices.1 {
                    colourIndices.1 = index
                }
            }
        }
    }
}

struct DictioView_Previews: PreviewProvider {
    static var previews: some View {
        DictioView()
    }
}

//class WordModel: ObservableObject {
//    @Published var dict: [String: Color] = ["a": .black, "b": .black, "c": .black, "d": .black, "e": .black, "f": .black, "g": .black, "h": .black, "i": .black, "j": .black, "k": .black, "l": .black, "m": .black, "n": .black, "o": .black, "p": .black, "q": .black, "r": .black, "s": .black, "t": .black, "u": .black, "v": .black, "w": .black, "x": .black, "y": .black, "z": .black]
//}
