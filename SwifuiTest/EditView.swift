//
//  EditView.swift
//  SwifuiTest
//
//  Created by maahika gupta on 12/31/22.
//

import SwiftUI
//import ActiveLookSDK


struct EditView: View {
    @Environment(\.dismiss) var dismiss
    var location: Location
    var onSave: (Location)->Void
    @State private var name: String
    @State private var discription: String
    
    var body: some View {
        NavigationView{
            Form{
                Section{
                    TextField("Place Name",text: $name)
                    TextField("Discription",text: $discription)
                }
            }
            .navigationTitle("Place details")
            .toolbar{
                Button("Save"){
                    var newLocation = location
                    newLocation.id = UUID()
                    newLocation.name = name
                    newLocation.discription = discription
                    
                    onSave(newLocation)
                    dismiss()
                }
            }
        }
    }
    init(location: Location, onSave: @escaping (Location) -> Void){
        self.location=location
        self.onSave = onSave
        
        _name = State(initialValue: location.name)
        _discription = State(initialValue: location.discription)
    }
}

struct EditView_Previews: PreviewProvider {
    static var previews: some View {
        EditView(location: Location.example){_ in}
    }
}
