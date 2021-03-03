//
//  TestHelpers.swift
//  LastFM-AppTests
//
//  Created by Erich Flock on 27.02.21.
//

import Foundation
import UIKit
@testable import LastFM_App

func executeRunLoop() {
    RunLoop.current.run(until: Date())
}
    
func createSomeAlbum() -> Album {
    return .init(name: "some name", imageURLString: "some image url", artistName: "some artist name")
}

extension UIBarButtonItem {
    func tap() {
        _ = target?.perform(action, with: nil)
    }
}

extension UIAlertController {
    typealias AlertHandler = @convention(block) (UIAlertAction) -> Void

    func tapButton(atIndex index: Int) {
        guard let block = actions[index].value(forKey: "handler") else { return }
        let handler = unsafeBitCast(block as AnyObject, to: AlertHandler.self)
        handler(actions[index])
    }
}
