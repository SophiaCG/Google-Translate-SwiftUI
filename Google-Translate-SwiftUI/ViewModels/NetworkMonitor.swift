//
//  NetworkMonitor.swift
//  Google-Translate-SwiftUI
//
//  Created by SCG on 8/10/21.
//

import Network

/*
 Code from Ray Wenderlich: https://www.raywenderlich.com/21020457-ios-unit-testing-and-ui-testing-tutorial
 Checks for network connection
*/

class NetworkMonitor {
  static let shared = NetworkMonitor()
  var isReachable: Bool { status == .satisfied }

  private let monitor = NWPathMonitor()
  private var status = NWPath.Status.requiresConnection

  private init() {
    startMonitoring()
  }

  func startMonitoring() {
    monitor.pathUpdateHandler = { [weak self] path in
      self?.status = path.status
    }
    let queue = DispatchQueue(label: "NetworkMonitor")
    monitor.start(queue: queue)
  }

  func stopMonitoring() {
    monitor.cancel()
  }
}
