//
//  ContentView.swift
//  knomee2
//
//  Created by Fiona Kate Morgan on 27/01/2023.
//

import SwiftUI
import CoreData

struct ContentView: View {
    var body: some View {
        
            DictioView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
