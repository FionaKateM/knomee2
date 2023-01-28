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
    @State var colourIndices = (0, 26, 500)
    @State var scrollLocation = 0
    
    var body: some View {
        ScrollViewReader { proxy in
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
                    
                    List(visualisedWords, id: \.self) { word in
                        if let index = visualisedWords.firstIndex(of: word) {
                            if word == correctWord {
                                Text(word)
                                    .id(index)
                                    .foregroundColor(.green)
                                    .bold()
                            } else {
                                Text(word)
                                    .id(index)
                                    .foregroundColor((index < colourIndices.0 || index > colourIndices.1) ? .gray : .black)
                            }
                            
                            
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
                    colourIndices.2 = wordLocation.firstIndex(of: correctWord.lowercased()) ?? 500
                }
                
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.75) {
                    self.wordInFocus = true
                }
            }
            .onChange(of: scrollLocation) { newValue in
                proxy.scrollTo(newValue, anchor: .center)
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
            visualisedWords.append(enteredWord.lowercased())
            visualisedWords.sort()
            wordLocation.append(enteredWord.lowercased())
            wordLocation.sort()
            
            endGame()
        } else if visualisedWords.contains(enteredWord.lowercased()) {
            // word has already been guessed
            print("word already guessed")
            wordInFocus = true
        } else {
            // correct word and not guessed yet
            print("valid guess")
            removeElipses()
            visualisedWords.append(enteredWord.lowercased())
            visualisedWords.sort()
            wordLocation.append(enteredWord.lowercased())
            wordLocation.sort()
            updateVisuals()
            enteredWord = ""
            wordInFocus = true
        }
    }
    
    func removeElipses() {
        // remove "..." and adjust colourIndices appropriateley
        if let holdingRowLocation = visualisedWords.firstIndex(of: "...") {
            if holdingRowLocation < colourIndices.0 {
                // adjust both min and max values
                colourIndices.0 -= 1
                colourIndices.1 -= 1
                visualisedWords.remove(at: holdingRowLocation)
            } else if holdingRowLocation > colourIndices.1 {
                // adjust no values
                visualisedWords.remove(at: holdingRowLocation)
            } else {
                // adjust just max value
                colourIndices.1 -= 1
                visualisedWords.remove(at: holdingRowLocation)
            }
        }
    }
    
    func updateVisuals() {
        
        if let correctIndex = visualisedWords.firstIndex(of: correctWord) {
            colourIndices.0 = correctIndex + 1
            colourIndices.1 = correctIndex - 1
        } else {
            if wordLocation.firstIndex(of: enteredWord.lowercased()) ?? 1 < wordLocation.firstIndex(of: correctWord.lowercased()) ?? 0 {
                // Word is earlier than the corect word
                
                if let index = visualisedWords.firstIndex(of: enteredWord.lowercased()) {
                    
                    // move the screen to view the entered word now in the list
                    //                scrollLocation = index
                    
                    if index > colourIndices.0 {
                        // Set min to index of entered word as it is a higher min than what is currently set
                        colourIndices.0 = index
                    } else {
                        // entered word is earlier than the previous minimum so the minimum needs + 1 to account for the additional value
                        colourIndices.0 += 1
                    }
                    
                    // add 1 to the upper boundary as there is now an additional element earlier in the array
                    colourIndices.1 += 1
                }
                
            } else if wordLocation.firstIndex(of: enteredWord.lowercased()) ?? 0 > wordLocation.firstIndex(of: correctWord.lowercased()) ?? 1 {
                // set max to index of entered word
                if let index = visualisedWords.firstIndex(of: enteredWord.lowercased()) {
                    
                    // move the screen to view the entered word now in the list
                    //                scrollLocation = index
                    
                    if index < colourIndices.1 {
                        colourIndices.1 = index
                    }
                }
            }
            
            // sets viewing position
            var position = 0
            if wordLocation.count < 3 {
                if let guessedWordLocation = visualisedWords.firstIndex(of: enteredWord.lowercased()) {
                    print("location of first word: \(guessedWordLocation)")
                    scrollLocation = guessedWordLocation
                }
            } else {
                position = ((colourIndices.1 - colourIndices.0)/2) + colourIndices.0
                scrollLocation = position
            }
            

            if colourIndices.1 - colourIndices.0 == 1 {
                // Add extra row if min and max values are next to each other to help with visualising where the word is expected
                visualisedWords.insert("...", at: colourIndices.0 + 1)
                
                // add one to max value to account for additional array entry
                colourIndices.1 += 1
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
