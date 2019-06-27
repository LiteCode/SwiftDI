//
//  ContentView.swift
//  SwiftDIDemo
//
//  Created by v.a.prusakov on 27/06/2019.
//  Copyright © 2019 Vladislav Prusakov. All rights reserved.
//

import SwiftUI
import SwiftDI

struct ContentView : View {
    
    @BindObjectInjectable var networkService: NetworkService
    @EnvironmentObject var networkService: NetworkService
    
    var body: some View {
        NavigationView {
            VStack(spacing: 8) {
                Text(self.networkService.hasData ? "Has data" : "Hasn't data")
                Button(action: self.getData, label: { Text("Refresh") })
                Button(action: self.clearData, label: { Text("ClearData") })
                Spacer()
            }.navigationBarTitle(Text("SwiftDI Test"))
        }.onAppear { self.getData() }
    }
    
    func getData() {
        self.networkService.getData()
    }
    
    func clearData() {
        self.networkService.clearData()
    }
}

#if DEBUG
struct ContentView_Previews : PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
#endif

@propertyDelegate
struct BindObjectInjectable<BindableObjectType>: DynamicViewProperty where BindableObjectType : BindableObject {
    
    var _value: BindableObjectType
    var binding: ObjectBinding<BindableObjectType>
    
    init() {
        _value = container.resolve()
        self.binding = ObjectBinding<BindableObjectType>(initialValue: _value)
    }
    
    var value: BindableObjectType {
        get { return _value }
    }
}
