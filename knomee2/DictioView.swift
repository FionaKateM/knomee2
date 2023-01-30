//
//  DictioView.swift
//  knomee2
//
//  Created by Fiona Kate Morgan on 27/01/2023.
//

import SwiftUI

struct DictioView: View {
    
    var correctWord = "hello"
    var alphabet = ["a", "b", "c", "d", "e", "f", "g", "h", "i", "j", "k", "l", "m", "n", "o", "p", "q", "r", "s", "t", "u", "v", "w", "x", "y", "z"]
    @State private var enteredWord = ""
    @State var words: [String] = []
    @State var wordColour = Color.black
    @State var visualisedWords: [String] = []
    @State var wordLocation: [String] = []
    @FocusState private var wordInFocus: Bool
    // min, max, location of correct word
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
                
                if visualisedWords.count == 0 {
                    visualisedWords.append(contentsOf: alphabet)
                    visualisedWords.sort()
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
        
        // check word exists
        if !words.contains(enteredWord.lowercased()) {
            // not a valid word
            print("not a valid word")
            // add shake annimation
            wordInFocus = true
            
        // check if answer is correct
        } else if correctWord.lowercased() == enteredWord.lowercased() {
            print("correct answer")
            visualisedWords.append(enteredWord.lowercased())
            visualisedWords.sort()
            wordLocation.append(enteredWord.lowercased())
            wordLocation.sort()
            updateVisuals()
            endGame()
            
        // check if word has already been guessed
        } else if visualisedWords.contains(enteredWord.lowercased()) {
            // word has already been guessed
            print("word already guessed")
            wordInFocus = true
            
        // correct word and not yet guessed
        } else {
            print("valid guess")
            visualisedWords.append(enteredWord.lowercased())
            visualisedWords.sort()
            wordLocation.append(enteredWord.lowercased())
            wordLocation.sort()
            updateVisuals()
            enteredWord = ""
            wordInFocus = true
        }
    }
    
    func updateVisuals() {
        
        // at this point the checking of the word is complete, and we are tidying up the 'visualised words' array
        
        // get the indices needed
        guard let correctWordIndex = wordLocation.firstIndex(of: correctWord.lowercased()) else {
            print("cannot find winning word in wordLocation array")
            return
        }
        
        // remove elipses
        if let elipsesIndex = visualisedWords.firstIndex(of: "...") {
            print("removing elipses")
            visualisedWords.remove(at: elipsesIndex)
        }
        
        
        // Only contain letters that don't have words guessed yet
        var temporaryArray = alphabet
        
        // remove alphabet from visualised words list
        visualisedWords = Array(Set(visualisedWords).subtracting(Set(alphabet)))
        
        // for each word in the guessed list, remove the first letter from the temporary array
        for word in visualisedWords {
            if let index = temporaryArray.firstIndex(of:String(word.prefix(1))) {
                temporaryArray.remove(at: index)
            }
        }
        
        // combine any left over letters with the visualised words array
        if temporaryArray.count > 0 {
            visualisedWords.append(contentsOf: temporaryArray)
        }
        visualisedWords.sort()
        
        // check if new elipses are needed
        var minWord = ""
        var maxWord = ""
        
        // look for location of correct word
        if correctWordIndex > 0 {
            minWord = wordLocation[correctWordIndex-1]
        }
        if correctWordIndex < wordLocation.count-1 {
            maxWord = wordLocation[correctWordIndex+1]
        }
        
        
        if let minWordLocation = visualisedWords.firstIndex(of: minWord) {
            colourIndices.0 = minWordLocation
            print("min word location: \(colourIndices.0)")
            print("word location array:\(wordLocation)")
        }
        
        if let maxWordLocation = visualisedWords.firstIndex(of: maxWord) {
            colourIndices.1 = maxWordLocation
            print("max word location: \(colourIndices.1)")
            print("word location array:\(wordLocation)")
        }
        
        if let index = visualisedWords.firstIndex(of: correctWord.lowercased()) {
                colourIndices.0 = index
                colourIndices.1 = index
        }
        
        
         if colourIndices.1 - colourIndices.0 == 1 {
            visualisedWords.insert("...", at: colourIndices.0 + 1)
            colourIndices.1 += 1
        }
    
    }
    
}

struct DictioView_Previews: PreviewProvider {
    static var previews: some View {
        DictioView()
    }
}

// word exists
    // check if it is in 'words' array
// word already been said
    // check if it is in 'visualised words' array
// add word to visualised words
    // append to visualised words array
    // append to word location array
// remove elipses
    // remove elipses from 'visualised words' array
// remove un-needed alphabet letters
    // for each word with length more than 1 in visualised words array, find out first letter then remove that from the array if it exists
// discover new location of min and max
    // look at the word either side of the winning word in the 'word location' array and find their positions in 'visualised words' array.
    // if max - min == 1 then add elipses and update max += 1
