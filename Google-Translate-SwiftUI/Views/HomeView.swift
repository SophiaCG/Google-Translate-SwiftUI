//
//  ContentView.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/8/21.
//

import SwiftUI
import CoreData

struct ViewedLanguages: Hashable, Equatable {
    var firstName: String = "English"
    var firstCode: String = "en"
    var secondName: String = "French"
    var secondCode: String = "fr"
}

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var viewContext
    
    @FetchRequest(
        sortDescriptors: [NSSortDescriptor(keyPath: \History.self, ascending: true)],
        animation: .default)
    private var items: FetchedResults<History>
    
    @ObservedObject var viewModel: ViewModel
    
    @State var viewedLanguages = ViewedLanguages()
    @State var isPresented: Bool = false
    @State var choice: Int = 1
    @State var starTapped: Bool = false
    
    var mockData: [String: String] = ["Hello":"Bonjour", "I don't understand":"Je ne comprends pas", "No":"Non"]
    let screen = UIScreen.main.bounds
    
    var body: some View {
        
        VStack {
            
//MARK: - Header
            ZStack {
                Rectangle()
                    .frame(width: screen.width, height: screen.height * 0.075, alignment: .top)
                    .foregroundColor(.blue)
                Text("Google Translate Clone")
                    .foregroundColor(.white)
                    .bold()
            }
            
//MARK: - Buttons
            HStack {
                Button(action: {
                    print(viewedLanguages.firstName)
                    print(viewedLanguages.firstCode)
                    choice = 1
                    isPresented.toggle()
                    
                }, label: {
                    Text(viewedLanguages.firstName)
                        .bold()
                        .frame(width: 150, height: 40, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.blue)
                })
                
                Button(action: {
                    print("Switch language")
                    let temp = viewedLanguages.firstName
                    viewedLanguages.firstName = viewedLanguages.secondName
                    viewedLanguages.secondName = temp
                    
                    let temp2 = viewedLanguages.firstCode
                    viewedLanguages.firstCode = viewedLanguages.secondCode
                    viewedLanguages.secondCode = temp2
                    
                    let temp3 = viewModel.input
                    viewModel.input = viewModel.translation
                    viewModel.translation = temp3

                }, label: {
                    Image(systemName: "arrow.right.arrow.left")
                        .frame(width: 75, height: 40, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(Color(UIColor.darkGray))
                })
                
                Button(action: {
                    print(viewedLanguages.secondName)
                    print(viewedLanguages.secondCode)
                    choice = 2
                    isPresented.toggle()
                }, label: {
                    Text(viewedLanguages.secondName)
                        .bold()
                        .frame(width: 150, height: 40, alignment: .center)
                        .background(Color.white)
                        .foregroundColor(.blue)
                })
            }
            
//MARK: - Text Fields
            VStack (spacing: -10) {
                ZStack {
                    TextField("Enter text", text: $viewModel.input)
                        .frame(width: screen.width * 0.925, height: screen.height * 0.1, alignment: .top)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .border(Color(UIColor.systemGray2), width: 1)
                    HStack {
                        Spacer()
                        Button(action: {
                            viewModel.input = ""
                        }, label: {
                            Image(systemName: "multiply")
                                .frame(width: 25, height: 25, alignment: .center)
                                .font(.system(size: 24))
                                .foregroundColor(.black)
                        }).padding(.trailing, 15)
                    }
                }
                
                ZStack {
                    TextField("", text: $viewModel.translation)
                        .frame(width: screen.width * 0.925, height: screen.height * 0.1, alignment: .top)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 10)
                        .background(Color.white)
                        .border(Color(UIColor.systemGray2), width: 1)
                        .disabled(true)
                    HStack {
                        Spacer()
                        Button(action: {
                            print("Translating \(viewModel.input)")
                            ViewModel().translate(for: viewModel.input, for: viewedLanguages.firstCode, for: viewedLanguages.secondCode) { (results) in
                                viewModel.translation = results.data.translation
                            }
                        }, label: {
                            Image(systemName: "arrow.right")
                                .frame(width: 25, height: 25, alignment: .center)
                                .font(.system(size: 15, weight: .bold))
                                .foregroundColor(.white)
                                .background(Color.blue)
                                .clipShape(Circle())
                            
                        }).padding(.trailing, 15)
                    }
                }
            }
            
//MARK: - List of Translations
            let keys = mockData.map{$0.key}
            let values = mockData.map{$0.value}

            ScrollView {
                ForEach(keys.indices, id: \.self) { index in
                    HStack {
                        VStack {
                            Text(keys[index])
                                .bold()
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                                .padding(.leading, 23)
                            Text(values[index])
                                .bold()
                                .foregroundColor(Color(UIColor.systemGray))
                                .font(.system(size: 13))
                                .padding(.leading, 25)
                        }
                        
                        Spacer()

                        Button(action: {
                            print("Translation Starred")
                            starTapped.toggle()
                        }, label: {
                            Image(systemName: starTapped ? "star.fill" : "star")
                                .font(.system(size: 17))
                                .foregroundColor(starTapped ? .yellow : .black)
                                .padding(.trailing, 15)
                        })
                    }
                    .frame(width: screen.width * 0.98, height: screen.height * 0.08, alignment: .center)
                    .border(Color.gray, width: 0.23)
                    .background(Color.white)

                }
            }.background(Color(UIColor.systemGray6).opacity(20))


//            List {
//                ForEach(items) { item in
//                    Text("Item at \(String(describing: item.translated))")
//                }
//                .onDelete(perform: deleteItems)
//            }
//            .toolbar {
//                #if os(iOS)
//                EditButton()
//                #endif
//
//                Button(action: addItem) {
//                    Label("Add Item", systemImage: "plus")
//                }
//            }
        }
        .sheet(isPresented: $isPresented) {
            LanguagesList(isPresented: $isPresented, choice: $choice, viewedLanguages: $viewedLanguages)
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

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
