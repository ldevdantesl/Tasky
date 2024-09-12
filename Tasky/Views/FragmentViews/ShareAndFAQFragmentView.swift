//
//  ShareAndFAQFragmentView.swift
//  Tasky
//
//  Created by Buzurg Rakhimzoda on 9.09.2024.
//

import SwiftUI

struct ShareAndFAQFragmentView: View {
    let appStoreLink = URL(string: "https://apps.apple.com/app/idYOUR_APP_ID")!
    @State private var showFAQView: Bool = false
    var body: some View {
        HStack{
            ShareLink(item: appStoreLink, subject: Text("Hey Checkout this App"), message: Text("Check this App...")){
                Capsule().fill(Color.gray)
                    .frame(width: Constants.screenWidth / 2, height: 55)
                    .overlay{
                        HStack(spacing: 10){
                            Image(systemName: "paperplane")
                                .resizable()
                                .scaledToFit()
                                .frame(width: 20, height: 20)
                                .foregroundStyle(.white)
                            Text("Share")
                                .font(.system(.title2, design: .rounded, weight: .bold))
                                .foregroundStyle(.white)
                        }
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            Button(action: openAppStore){
                Circle().fill(Color.gray)
                    .frame(width: 55, height: 55)
                    .overlay {
                        Image(systemName: "star.fill")
                            .resizable()
                            .scaledToFit()
                            .frame(width: 30, height: 30)
                            .foregroundStyle(.yellow)
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            Button(action: {showFAQView.toggle()}){
                Circle().fill(Color.gray)
                    .frame(width: 55, height: 55)
                    .overlay {
                        Text("FAQ")
                            .foregroundStyle(.white)
                            .font(.system(.headline, design: .rounded, weight: .bold))
                    }
                    .shadow(color: .black.opacity(0.2), radius: 10, x: 0, y: 5)
            }
            Spacer()
        }
        .padding(.top, 10)
        .padding(.horizontal, 20)
        .sheet(isPresented: $showFAQView){
            FAQView()
                .presentationDetents([.fraction(1/3.5)])
        }
    }
    
    func openAppStore() {
        let appID = "IDK_YET"
        if let url = URL(string: "https://apps.apple.com/app/id\(appID)?action=write-review") {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
            } else {
                print("Cant open app store with provided url")
            }
        }
    }
}

#Preview {
    ShareAndFAQFragmentView()
}
