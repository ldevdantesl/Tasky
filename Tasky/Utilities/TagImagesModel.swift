//
//  TagImagesModel.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 5.09.2024.
//

import Foundation

extension Bundle{
    func decode<T: Codable>(_ file: String) -> T {
        // 1. Locate the JSON file
        guard let url = self.url(forResource: file, withExtension: nil) else{
            fatalError("Failed to locate \(file) in bundle")
        }
        // 2. Create a property for the data
        guard let data = try? Data(contentsOf: url) else{
            fatalError("Failed to load \(file) from bundle")
        }
        // 3. Create a decoder
        let decoder = JSONDecoder()
        // 4. Create a property for the decoded data
        guard let decodedData = try? decoder.decode(T.self, from: data) else{
            fatalError("Failed to decode \(file) from bundle")
        }
        // 5. Return to ready-to-use data
        return decodedData
    }
}

struct TagImagesCategory: Codable, Hashable{
    let name: String
    let titleImage: String
    let symbols: [String]
}

extension TagImagesCategory{
    static let allCategories: [TagImagesCategory] = Bundle.main.decode("TagImages.json")
}
