//
//  CodeReader.swift
//  SwiftDemo
//
//  Created by Chivalrous on 2019/1/21.
//  Copyright © 2019 ML. All rights reserved.
//

import UIKit

protocol CodeReader {
    
    var videoPreview: CALayer {get}
    func startReading(completion: @escaping (CodeReadResult) -> Void)
    func stopReading()
}

enum CodeReadResult {
    typealias Elemento = String
    case success(Elemento)
    case failure(Error)
    
    enum Error: Swift.Error {
        case noCameraAvailable
    }
}
