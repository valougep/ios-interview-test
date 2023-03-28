//
//  Bundle+Module.swift
//  FriendList
//
//  Created by Phivos Valougeorgis on 25/03/2023.
//

import class Foundation.Bundle

#if !SWIFT_PACKAGE
extension Foundation.Bundle {
  static let module: Bundle = {
    guard let url = Bundle.main.url(forResource: "Settings", withExtension: "bundle") else {
      preconditionFailure()
    }

    guard let bundle = Bundle(url: url) else {
      preconditionFailure()
    }

    return bundle
  }()
}
#endif
