//
//  View.swift
//  
//
//  Created by ben on 4/5/20.
//

#if canImport(SwiftUI)

import SwiftUI

@available(OSX 10.15, iOS 13.0, tvOS 13, watchOS 6, *)
public extension View {
    func frame(size: CGSize) -> some View {
        frame(width: size.width, height: size.height)
    }
}
#endif
