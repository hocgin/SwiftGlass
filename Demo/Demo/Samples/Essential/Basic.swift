//
//  Basic.swift
//  Demo
//
//  Created by Ming on 20/4/2025.
//

import SwiftUI
import SwiftGlass

struct Basic: View {
    
    @State var open: Bool = false
    
    var body: some View {
        ScrollView(.vertical) {
            VStack {
                Text("sdjksjsload_eligibility_plist: Failed to open /Users/hocgin/Library/Developer/CoreSimulator/Devices/80D82288-6555-48AC-8279-54BDDA81EF6C/data/Containers/Data/Application/75225E43-0A35-4121-97C7-120BBCC67544/private/var/db/eligibilityd/eligibility.plist: No such file or directory(2)load_eligibility_plist: Failed to open /Users/hocgin/Library/Developer/CoreSimulator/Devices/80D82288-6555-48AC-8279-54BDDA81EF6C/data/Containers/Data/Application/75225E43-0A35-4121-97C7-120BBCC67544/private/var/db/eligibilityd/eligibility.plist: No such file or directory(2)load_eligibility_plist: Failed to open /Users/hocgin/Library/Developer/CoreSimulator/Devices/80D82288-6555-48AC-8279-54BDDA81EF6C/data/Containers/Data/Application/75225E43-0A35-4121-97C7-120BBCC67544/private/var/db/eligibilityd/eligibility.plist: No such file or directory(2)load_eligibility_plist: Failed to open /Users/hocgin/Library/Developer/CoreSimulator/Devices/80D82288-6555-48AC-8279-54BDDA81EF6C/data/Containers/Data/Application/75225E43-0A35-4121-97C7-120BBCC67544/private/var/db/eligibilityd/eligibility.plist: No such file or directory(2)")
                ZStack {

            container
#if !os(watchOS)
                .padding(25)
#else
                .padding(15)
#endif
                .glass()
            
#if os(tvOS)
                        .frame(maxWidth: 500)
#elseif !os(watchOS)
                        .frame(maxWidth: 300)
#else
                        .frame(maxWidth: 175)
#endif
                }
            }
            .frame(height: 2000)
            .frame(maxWidth: .infinity)
            .background {
                LinearGradient(stops: [
                    .init(color: Color.red, location: 0),
                    .init(color: Color.red, location: 0.1),
                    .init(color: Color.blue, location: 0.2),
                    .init(color: Color.blue, location: 0.3),
                    .init(color: Color.white, location: 0.4),
                    .init(color: Color.white, location: 0.5),
                    .init(color: Color.black, location: 0.6),
                    .init(color: Color.black, location: 0.7),
                    .init(color: Color.black, location: 1)
                ], startPoint: .top, endPoint: .bottom)
            }
        }
        .overlay(alignment: .center, content: {
            VStack(alignment: .center) {
                Text("Hello World!").onTapGesture {
                    open.toggle()
                }
            }
            .frame(maxWidth: .infinity)
            .padding(15)
            .glass(style: open ? .regular : .clear)
            .frame(maxWidth: 175)
        })
    }
    
    // Sample Card Content
    var container: some View {
        VStack {
            HStack {
                VStack(alignment: .leading) {
                    Text("Welcome Back")
                        .font(.headline)
                        .foregroundStyle(.secondary)
                    Text("HOME")
                        .font(.largeTitle)
                        .fontWeight(.heavy)
                        .foregroundStyle(.white)
                }
                
#if !os(watchOS)
                Spacer()
                
                Image(systemName: "homekit")
                    .font(.largeTitle)
                    .symbolRenderingMode(.multicolor)
#endif
            }
            
            Button(action: {
                print("Welcome to Swift Glass Demo!")
            }) {
                HStack {
                    Spacer()
#if !os(watchOS)
                    Label(
                        "Open Garage",
                        systemImage:"door.garage.closed.trianglebadge.exclamationmark"
                    )
                    .font(.body.bold())
                    .symbolRenderingMode(.multicolor)
                    .font(.caption)
#else
                    Label("Open", systemImage:"door.garage.closed")
                        .bold()
                        .symbolRenderingMode(.multicolor)
                        .font(.caption)
#endif
                    Spacer()
                }
#if os(macOS)
                .padding(.vertical, 10)
#endif
            }
            .buttonStyle(.borderedProminent)
#if !os(tvhOS)
            .buttonBorderShape(.capsule)
#endif
            .tint(.orange)
            .glass(color: .yellow, style: .clear)
        }
    }
    
    // Add a background for better looking
    var background: some View {
        Group {
            Color.black
                .ignoresSafeArea()
            
            AsyncImage(
                url: URL(string: "https://shareby.vercel.app/3vj7gk")
            ) { image in
                image
                    .resizable()
                    .scaledToFill()
            } placeholder: {
                ProgressView()
            }.opacity(0.3)
                .ignoresSafeArea()
        }
    }
}

#Preview("Light") {
    Basic()
}

#Preview("Dark") {
    Basic()
        .preferredColorScheme(.dark)
}
