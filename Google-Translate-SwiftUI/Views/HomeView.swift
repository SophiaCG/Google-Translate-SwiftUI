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

struct Translation {
    var input: String = ""
    var translation: String = ""
    var star: Bool = false
}

struct HomeView: View {
    
    @Environment(\.managedObjectContext) private var context
    
    @FetchRequest(entity: SavedTranslations.entity(), sortDescriptors: [NSSortDescriptor(keyPath: \SavedTranslations.time, ascending: true)])
    var savedTranslations: FetchedResults<SavedTranslations>
    
    @ObservedObject var viewModel: ViewModel
    
    @State var viewedLanguages = ViewedLanguages()
    @State var translation = Translation()
    
    @State var isPresented: Bool = false
    @State var choice: Int = 1
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
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
                                print("About to save translation")
                                if !viewModel.translation.isEmpty {
                                    translation.input = viewModel.input
                                    translation.translation = viewModel.translation
                                    save(translation: translation)
                                }
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
            ScrollView {
                ForEach(savedTranslations, id: \.self) { savedItem in
                    HStack {
                        VStack {
                            Text("\(savedItem.input!)")
                                .bold()
                                .foregroundColor(.black)
                                .font(.system(size: 17))
                                .padding(.leading, 23)
                            Text("\(savedItem.translation!)")
                                .bold()
                                .foregroundColor(Color(UIColor.systemGray))
                                .font(.system(size: 13))
                                .padding(.leading, 25)
                        }
                        
                        Spacer()

                        Button(action: {
                            print("Translation Starred")
//                            starTapped.toggle()
                        }, label: {
                            Image(systemName: savedItem.star ? "star.fill" : "star")
                                .font(.system(size: 17))
                                .foregroundColor(savedItem.star ? .yellow : .black)
                                .padding(.trailing, 15)
                        })
                    }
                    .frame(width: screen.width * 0.98, height: screen.height * 0.08, alignment: .center)
                    .border(Color.gray, width: 0.23)
                    .background(Color.white)
                    .onLongPressGesture {
                        delete(savedItem: savedItem)
                    }

                }
            }.background(Color(UIColor.systemGray6).opacity(20))
        }
        .sheet(isPresented: $isPresented) {
            LanguagesList(isPresented: $isPresented, choice: $choice, viewedLanguages: $viewedLanguages)
        }
    }
    
    private func save(translation: Translation) {
        withAnimation {
            print("Saving \(translation.input)")

            let newItem = SavedTranslations(context: context)
            newItem.input = translation.input
            newItem.translation = translation.translation
            newItem.star = translation.star
            newItem.time = Date()
                        
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
    
    private func delete(savedItem: SavedTranslations) {
        withAnimation {
            print("Deleting \(savedItem.input!)")
            context.delete(savedItem)
            do {
                try context.save()
            } catch {
                print(error.localizedDescription)
            }
        }
    }
}

//struct ContentView_Previews: PreviewProvider {
//    static var previews: some View {
//        HomeView().environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
//    }
//}
