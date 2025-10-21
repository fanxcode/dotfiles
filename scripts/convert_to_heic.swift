import Foundation

// 转换单个图片文件为 HEIC 格式
func convertToHEIC(inputPath: String, outputPath: String) throws {
    let inputPathQuoted = inputPath.quotedForShell()
    let outputPathQuoted = outputPath.quotedForShell()
    
    let cmd = "/usr/bin/sips -s format heic \(inputPathQuoted) --out \(outputPathQuoted)"
    
    let process = Process()
    process.executableURL = URL(fileURLWithPath: "/bin/bash")
    process.arguments = ["-c", cmd]
    
    try process.run()
    process.waitUntilExit()
    
    if process.terminationStatus != 0 {
        throw NSError(domain: "HEICConversionError", code: Int(process.terminationStatus), userInfo: [NSLocalizedDescriptionKey: "Conversion failed for \(inputPath)"])
    }
}

// 处理单个文件，转换为 HEIC 格式并删除原文件
func processFile(filePath: String) {
    let fileManager = FileManager.default
    let ext = (filePath as NSString).pathExtension.lowercased()
    
    if ["jpg", "jpeg", "png", "tiff", "bmp", "webp"].contains(ext) {
        let outputPath = (filePath as NSString).deletingPathExtension + ".heic"
        
        do {
            try convertToHEIC(inputPath: filePath, outputPath: outputPath)
            try fileManager.removeItem(atPath: filePath)
            print("转换完成并删除原文件: \(filePath)")
        } catch {
            print("处理文件 \(filePath) 时发生错误: \(error)")
        }
    }
}

// 处理文件或目录
func processFiles(inputPath: String) {
    let fileManager = FileManager.default
    var filesToProcess: [String] = []
    
    if fileManager.fileExists(atPath: inputPath) {
        do {
            let attributes = try fileManager.attributesOfItem(atPath: inputPath)
            
            if let fileType = attributes[.type] as? FileAttributeType {
                if fileType == .typeDirectory {
                    // 遍历目录中的所有文件
                    let enumerator = fileManager.enumerator(atPath: inputPath)
                    for case let filePath as String in enumerator! {
                        filesToProcess.append((inputPath as NSString).appendingPathComponent(filePath))
                    }
                } else {
                    // 如果是文件，直接添加到待处理文件列表
                    filesToProcess.append(inputPath)
                }
            }
        } catch {
            print("无法获取路径属性: \(error)")
            return
        }
    } else {
        print("输入路径无效！")
        return
    }

    // 使用并行处理文件
    let queue = DispatchQueue(label: "fileProcessingQueue", attributes: .concurrent)
    let group = DispatchGroup()

    for file in filesToProcess {
        group.enter()
        queue.async {
            processFile(filePath: file)
            group.leave()
        }
    }
    
    group.wait()
}

// 扩展 String 类，以支持对 shell 参数进行引用
extension String {
    func quotedForShell() -> String {
        return "\"\(self.replacingOccurrences(of: "\"", with: "\\\""))\""
    }
}

// 主函数
let arguments = CommandLine.arguments
if arguments.count != 2 {
    print("请提供要转换的文件或目录路径！")
    exit(1)
}

let inputPath = arguments[1]
processFiles(inputPath: inputPath)
