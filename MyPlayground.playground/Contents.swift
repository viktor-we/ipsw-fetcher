import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

var pwd = FileManager.default.homeDirectoryForCurrentUser

print(FileManager.default.contentsOfDirectory(at: pwd, includingPropertiesForKeys: []))
