//
//  Logger.swift
//
//  Created by Klajd Deda on 7/1/20.
//  Copyright © 2020 id-design. All rights reserved.
//

import SwiftUI

// TODO: kdeda
// Integrate with os_log
// https://developer.apple.com/videos/play/wwdc2020/10168/
//
public extension Thread {
    static var threadNumbers = [String: String]()
    private static let queue = DispatchQueue(label: "Thread", attributes: .concurrent)
    
    // return short int from pointer to Thread
    private static func threadNumber(thread: Thread) -> String {
        let threadID = String(format: "%p", thread)
        var threadNumber: String?
        
        Thread.queue.sync {
            threadNumber = Thread.threadNumbers[threadID]
        }
        
        if threadNumber == nil {
            threadNumber = String(format: "%04d", Thread.threadNumbers.count + 1)
            
            Thread.queue.async(flags: .barrier) {
                Thread.threadNumbers[threadID] = threadNumber
            }
        }
        return threadNumber!
    }
    
    var threadName: String {
        if isMainThread {
            return "main"
        } else {
            return Thread.threadNumber(thread: self)
        }
    }
    
    static var dateFormatter: DateFormatter = {
        var rv = DateFormatter()
        
        rv.locale = Locale.init(identifier: "en_US_POSIX")
        // rv.dateFormat = "yyyy-MM-dd HH:mm:ss.SSS"
        // just give us the short time stamp to the millisecond
        rv.dateFormat = "HH:mm:ss.SSS"
        return rv
    }()
    
    static var logHeader: String {
        return "\(dateFormatter.string(from: Date())) [TH: \(Thread.current.threadName)]"
    }
    
    static func logHeader(file: String = "", function: String = "", line: Int = -1) -> String {
        guard !file.isEmpty, line > 0 else { return logHeader }
        let app = "TidesAndCurrentsClient"
        
        let fileName: String = {
            // "~/Development/git.id-design.com/tides/Tides/Shared/Features/TidesClient/APIRequest.swift"
            // should become
            // "../AppDelegate.swift"
            let url = URL(fileURLWithPath: file)
            let pathComponents = url.pathComponents
            if let index = pathComponents.lastIndex(of: app) {
                return pathComponents[index.advanced(by: 1)...].joined(separator: "/")
            }
            
            if let index = file.range(of: app)?.upperBound {
                return String(file[index..<file.endIndex])
            }
            return file
        }()
        let functionName = function == app
        ? "anonymousFunc"
        : function
        
        let tokens = [
            fileName,
            ":",
            "\(line)".paddingEnd(4, with: " "),
            " .",
            functionName,
            functionName.hasSuffix(")") ? "" : "()"
        ]
        
        var adjusted = tokens.joined(separator: "")
        let maxLength = 84
        let suffix = adjusted.count - maxLength
        if suffix > 0 {
            adjusted = " ..." + String(adjusted.suffix(adjusted.count - suffix - 4))
        } else {
            adjusted = ("../" + adjusted).paddingStart(maxLength, with: " ")
        }
        
        return "\(logHeader) \(adjusted)  "
    }
}

struct Logger {
    // Logger.log("passed: \(String(data: data, encoding: .utf8) ?? "")")
    public static func log(
        _ items: Any...,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) {
        let output = items.map { "\($0)" }.joined(separator: "")
        print(Thread.logHeader(file: file, function: function, line: line), "\(output)")
    }
}

//struct LoggerView: View {
//    private let output: String
//    private let file: String
//    private let function: String
//    private let line: Int
//
//    // https://stackoverflow.com/questions/56517813/how-to-print-to-xcode-console-in-swiftui
//    init(
//        _ items: Any...,
//        file: String = #file,
//        function: String = #function,
//        line: Int = #line
//    ) {
//        self.output = items.map { "\($0)" }.joined(separator: "")
//        self.file = file
//        self.function = function
//        self.line = line
//    }
//
//    var body: some View {
//        print(Thread.logHeader(file: file, function: function, line: line), "\(output)")
//        return EmptyView()
//    }
//}

public extension View {
    /// https://stackoverflow.com/questions/56517813/how-to-print-to-xcode-console-in-swiftui
    /// ```
    /// // inject a log in any part of the swift DSL
    /// EmptyView().log("render ")
    /// ```
    func log(
        _ items: Any...,
        file: String = #file,
        function: String = #function,
        line: Int = #line
    ) -> some View {
        Logger.log(items, file: file, function: function, line: line)
        return self
    }
}
