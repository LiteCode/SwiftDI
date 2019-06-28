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
    
    @BindObjectInjectable var viewModel: HomeViewModel
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text(viewModel.hasData ? "Has data" : "No data").padding(.bottom, 8)
                viewModel.image.flatMap { Image(uiImage: $0).padding(.bottom, 8) }
                Button(action: self.getData, label: { Text("Refresh") })
                Button(action: self.clearData, label: { Text("ClearData") })
                Spacer()
            }.navigationBarTitle(Text("SwiftDI Test"), displayMode: .inline)
                .padding()
        }.onAppear { self.getData() }
    }
    
    func getData() {
        viewModel.getData()
    }
    
    func clearData() {
        viewModel.clearData()
    }
}

#if DEBUG
struct HomeView_Previews : PreviewProvider {
    static var previews: some View {
        HomeView()
    }
}
#endif
