import Foundation
import PlaygroundSupport
PlaygroundPage.current.needsIndefiniteExecution = true

let fm = FileManager.default

let resourcePath = Bundle.main.resourcePath!
let libraryPath = fm.urls(for: .libraryDirectory, in: .userDomainMask).first!
let local_files_iphone_path = libraryPath.appendingPathComponent("iTunes/iPhone Software Updates/")

do {
    try print(fm.contentsOfDirectory(atPath: local_files_iphone_path.path))
} catch {
    
}


let url = URL(string: "http://appldnld.apple.com.edgesuite.net/content.info.apple.com/iPhone/061-7481.20100202.4orot/iPhone1,1_3.1.3_7E18_Restore.ipsw")!

let task = URLSession.shared.downloadTask(with: url) { local_url, url_resonse, error in
    if let local_url = local_url {
        do {
            try fm.copyItem(at: local_url, to: local_files_iphone_path)
        } catch {
            print("could not copy")
        }
        
    }
}

let observation = task.progress.observe(\.fractionCompleted) { progress, _ in
    print(progress.fractionCompleted)
}

task.resume()
