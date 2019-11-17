//
//  HomeView.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftUI
import SwiftDI

struct HomeView : View {
    
    @EnvironmentObservedInject var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text(viewModel.hasData ? "Has data" : "No data").padding(.bottom, 8)
                
                imageData
                    .padding(.bottom, 8)
                
                HStack {
                    Spacer()
                    Button(action: self.getData, label: { makeButtonContent("Refresh") })
                    Spacer()
                    Button(action: self.clearData, label: { makeButtonContent("Clear Data") })
                    Spacer()
                }
                Spacer()
            }
            .navigationBarTitle("SwiftDI Test", displayMode: .inline)
            .padding()
        }.onAppear { self.getData() }
    }
    
    func getData() {
        viewModel.getData()
    }
    
    func clearData() {
        viewModel.clearData()
    }
    
    private var imageData: some View {
        HStack {
            if viewModel.hasData {
                Image(uiImage: viewModel.image!)
                    .resizable()
                    .scaledToFill()
                    .frame(width: 150, height: 150)
                    .clipShape(RoundedRectangle(cornerRadius: 12))
            } else {
                Rectangle()
                    .clipShape(RoundedRectangle(cornerRadius: 12))
                    .foregroundColor(.clear)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1)
                )
                    .frame(width: 150, height: 150)
            }
        }
    }
    
    private func makeButtonContent(_ text: String) -> some View {
        HStack {
            Spacer()
            Text(text)
            Spacer()
        }
        .frame(height: 32)
        .background(Color(.systemBlue))
        .foregroundColor(.white)
        .clipShape(RoundedRectangle(cornerRadius: 10))
    }
}

#if DEBUG
struct HomeView_Previews : PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
