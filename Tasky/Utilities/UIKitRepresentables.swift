//
//  UIKitRepresentables.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 8.09.2024.
//

import Foundation
import UIKit
import SwiftUI

struct CustomNavigationBarModifier: ViewModifier {
    
    func body(content: Content) -> some View {
        content
            .background(NavigationBarCustomizer()) // Customize appearance
    }
}

// UIViewControllerRepresentable to modify the UINavigationController's appearance
struct NavigationBarCustomizer: UIViewControllerRepresentable {
    
    func makeUIViewController(context: Context) -> UIViewController {
        let viewController = UIViewController()
        DispatchQueue.main.async {
            if let navigationController = viewController.navigationController {
                
                // Customize the large title appearance
                let appearance = UINavigationBarAppearance()
                appearance.configureWithOpaqueBackground()
                appearance.backgroundColor = .background // Set background color
                
                // Large title customizations
                appearance.largeTitleTextAttributes = [
                    .foregroundColor: UIColor.black,   // Custom large title color
                    .font: UIFont.boldSystemFont(ofSize: 44) // Custom large title font
                ]
                
                // Inline title customizations
                appearance.titleTextAttributes = [
                    .foregroundColor: UIColor.black, // Custom inline title color
                    .font: UIFont.systemFont(ofSize: 20) // Custom inline title font
                ]
                
                // Apply the appearance to both standard and scroll edge
                navigationController.navigationBar.standardAppearance = appearance
                navigationController.navigationBar.scrollEdgeAppearance = appearance
                
                // Enable large titles
                navigationController.navigationBar.prefersLargeTitles = true
            }
        }
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        // Update if necessary (e.g., for dynamic changes)
    }
}


// Custom modifier to set the back button text using UINavigationController
struct CustomBackButtonModifier: ViewModifier {
    let title: String
    
    func body(content: Content) -> some View {
        content
            .background(BackButtonTextSetter(title: title))
    }
}

// UIViewControllerRepresentable to modify the UINavigationController's back button text
struct BackButtonTextSetter: UIViewControllerRepresentable {
    let title: String

    func makeUIViewController(context: Context) -> UIViewController {
        let controller = UIViewController()
        DispatchQueue.main.async {
            if let navController = controller.navigationController {
                let backItem = UIBarButtonItem()
                backItem.title = title
                navController.navigationBar.topItem?.backBarButtonItem = backItem
            }
        }
        return controller
    }

    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        DispatchQueue.main.async {
            if let navController = uiViewController.navigationController {
                let backItem = UIBarButtonItem()
                backItem.title = title
                navController.navigationBar.topItem?.backBarButtonItem = backItem
            }
        }
    }
}
