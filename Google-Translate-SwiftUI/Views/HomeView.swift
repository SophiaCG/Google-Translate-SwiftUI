//
//  ContentView.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import SwiftUI
import CoreData

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \History.self, ascending: true)],
        animation: .default)
    private var items: FetchedResults<History>
    
    @State var input: String = ""
    @State var results = [Language]()
    
    var body: some View {
        
        VStack {
            
//MARK: - Header
            ZStack {
                Rectangle()
                    .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height * 0.075, alignment: .top)
                    .foregroundColor(.blue)
                Text("Google Translate")
                    .foregroundColor(.white)
                    .bold()
            }
            
//MARK: - Buttons
            HStack {
                Button(action: { print("First language") }, label: {
                    Text("English")
                        .bold()
                        .frame(width: 150, height: 40, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.blue)
                })
                
                Button(action: { print("Switch language") }, label: {
                    Image(systemName: "arrow.right.arrow.left")
                        .frame(width: 75, height: 40, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(Color(UIColor.darkGray))
                })
                
                Button(action: { print("Second language") }, label: {
                    Text("French")
                        .bold()
                        .frame(width: 150, height: 40, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.blue)
                })
            }
            
//MARK: - Text Fields
            VStack (spacing: -10) {
                TextField("Enter text", text: $input)
                    .frame(width: UIScreen.main.bounds.width * 0.925, height: UIScreen.main.bounds.height * 0.1, alignment: .top)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .border(Color(UIColor.systemGray2), width: 1)
                
                TextField("Enter text", text: $input)
                    .frame(width: UIScreen.main.bounds.width * 0.925, height: UIScreen.main.bounds.height * 0.1, alignment: .top)
                    .padding(.horizontal, 20)
                    .padding(.vertical, 10)
                    .background(Color.white)
                    .border(Color(UIColor.systemGray2), width: 1)
                
            }.onAppear() {
                apiCall().getResults { (results) in
                    self.results = results.data.languages
                }
            }
            
//MARK: - List of Translations
            List {
                ForEach(items) { item in
                    Text("Item at \(String(describing: item.translated))")
                }
                .onDelete(perform: deleteItems)
            }
            .toolbar {
                #if os(iOS)
                EditButton()
                #endif
                
                Button(action: addItem) {
                    Label("Add Item", systemImage: "plus")
                }
            }
        }
    }
    
    private func addItem() {
        withAnimation {
            //            let newItem = History(context: viewContext)
            //            newItem.timestamp = Date()
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
    
    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            offsets.map { items[$0] }.forEach(viewContext.delete)
            
            do {
                try viewContext.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nsError = error as NSError
                fatalError("Unresolved error \(nsError), \(nsError.userInfo)")
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
    }
}
