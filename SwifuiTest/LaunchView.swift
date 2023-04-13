//
//  LaunchView.swift
//  SwifuiTest
//
//  Created by maahika gupta on 4/4/23.
//

import Foundation
import SwiftUI

struct LaunchView: View {
    var body: some View {
        VStack {
            Image("vv.jpg")
                .resizable()
                .scaledToFit()
                .padding()
        }
        .background(Color.white)
        .edgesIgnoringSafeArea(.all)
    }
}
