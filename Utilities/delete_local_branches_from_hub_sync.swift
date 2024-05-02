#!/usr/bin/swift

import Foundation

@discardableResult
func shell(_ args: String...) -> Int32 {
    let task = Process()
    task.launchPath = "/usr/bin/env"
    task.arguments = args
    task.launch()
    task.waitUntilExit()
    return task.terminationStatus
}

let pattern = #"warning: '(.*)' was deleted on origin, but appears not merged into '[^']+'"#
let regex = try! NSRegularExpression(pattern: pattern, options: .anchorsMatchLines)
let hubSyncOutput = CommandLine.arguments[1]
let stringRange = NSRange(location: 0, length: hubSyncOutput.utf16.count)
let substitutionString = #"$1"#

// These are the branches that were deleted on origin but not locally, because "they appear to not be merged into master"
let branches = regex.stringByReplacingMatches(in: hubSyncOutput, range: stringRange, withTemplate: substitutionString)
branches.enumerateLines { branch, _  in
    // Here we delete all of them locally
    shell("git", "--no-optional-locks", "branch", "-D", branch)
}
