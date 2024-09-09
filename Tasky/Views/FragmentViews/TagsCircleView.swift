//
//  TagsCircleView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 9.09.2024.
//

import SwiftUI

struct TagsCircleView: View {
    let tags: [Tag]
    var body: some View {
        ScrollView(.horizontal){
            LazyHStack{
                ForEach(tags, id: \.self){ tag in
                    Circle()
                        .fill(Color.fromData(tag.color ?? Data()) ?? .blue)
                        .frame(height: 40)
                        .overlay{
                            Image(systemName: tag.systemImage ?? "")
                                .resizable()
                                .scaledToFit()
                                .foregroundStyle(.white)
                                .frame(width: 25, height: 25)
                        }
                }
            }
        }
    }
}

#Preview {
    TagsCircleView(tags: TagViewModel.mockTags())
}
