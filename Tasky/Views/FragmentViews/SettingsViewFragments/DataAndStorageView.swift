//
//  DataAndStorageView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 22.08.2024.
//

import SwiftUI

struct DataAndStorageView: View {
    @ObservedObject var todoVM = TodoViewModel()
    var body: some View {
        Form{
            Section{
                NavigationLink{
                    
                } label: {
                    HStack{
                        Image(systemName: "trash")
                            .resizable()
                            .scaledToFit()
                            .frame(maxWidth: 25, maxHeight: 25)
                            .foregroundStyle(.red)
                        VStack(alignment: .leading){
                            Text("Removed Todos")
                                .font(.system(.headline, design: .rounded, weight: .semibold))
                                .foregroundStyle(.red)
                            Text("All todos that have been removed")
                                .font(.system(.caption, design: .rounded, weight: .light))
                                .foregroundStyle(.secondary)
                        }
                    }
                }
            }
        }
        .navigationTitle("Data and Storage")
        .toolbarTitleDisplayMode(.inline)
    }
}

#Preview {
    NavigationStack{
        DataAndStorageView()
    }
}
