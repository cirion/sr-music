//
//  ViewController.swift
//  SuperShadowrun
//
//  Created by Chris King on 6/8/17.
//  Copyright © 2017 Cirion. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOpenSavePanelDelegate {
    
    //MARK: Properties
    
    @IBOutlet weak var selectButton: NSButtonCell!
    @IBOutlet weak var filePathTextField: NSTextField!
    @IBOutlet weak var convertButton: NSButtonCell!
    
    @IBAction func selectFile(_ sender: Any) {
        
        let dialog = NSOpenPanel();
        
        let initialPath = "~/Library/Application Support/Steam/steamapps/common/Shadowrun Hong Kong" as NSString
        let expandedPath = initialPath.expandingTildeInPath;
        dialog.directoryURL = NSURL.fileURL(withPath: expandedPath, isDirectory: true);
        
        dialog.title                   = "Select Shadowrun";
        dialog.showsResizeIndicator    = true;
        dialog.showsHiddenFiles        = true;
        dialog.canChooseDirectories    = true;
        dialog.canCreateDirectories    = false;
        dialog.allowsMultipleSelection = false;
//        dialog.allowedFileTypes        = ["txt"];
        dialog.delegate = self;
        
        if (dialog.runModal() == NSModalResponseOK) {
            let result = dialog.url // Pathname of the file
            
            if (result != nil) {
                let path = result?.path
                filePathTextField.stringValue = path!
            }
        } else {
            // User clicked on "Cancel"
            return
        }
        
        
    }
    
    func panel(_ sender: Any, shouldEnable url: URL) -> Bool {
        var isDir : ObjCBool = false
        if (FileManager.default.fileExists(atPath: url.path, isDirectory: &isDir)) {
            let fileName = (url.path as NSString).lastPathComponent;
            return (isDir.boolValue && !fileName.contains(".app")) || (url.path as NSString).lastPathComponent == "SRHK.app"
        }
        return false
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override var representedObject: Any? {
        didSet {
        // Update the view, if already loaded.
        }
    }
    
    func showAlert(message: String) -> Bool {
        let alert = NSAlert();
        alert.messageText = message;
        alert.alertStyle = NSAlertStyle.informational;
        alert.addButton(withTitle: "OK");
        return alert.runModal() == NSAlertFirstButtonReturn
    }
    
    func getFileSizeFor(path: String) -> NSNumber {
        let fm = FileManager.default;
        if (fm.fileExists(atPath: path)) {
            let attributes = try! fm.attributesOfItem(atPath: path);
            return (attributes[FileAttributeKey.size] as! NSNumber)
        }
        return 0
    }
    
    @IBAction func convert(_ sender: Any) {
        let appRoot = filePathTextField.stringValue;
        let currentMusicFile = appRoot + "/Contents/Data/resources.assets.resS";
        let backupMusicFile = appRoot + "/Contents/Data/resources.assets.resS.original";
        let assetsFile = appRoot + "/Contents/Data/resources.assets";
        let fm = FileManager.default
        var canSkipBackup = false;
        var currentMusicFileSize = 0;
        if (fm.fileExists(atPath: backupMusicFile)) {
            let attributes = try! fm.attributesOfItem(atPath: backupMusicFile);
            let size = (attributes[FileAttributeKey.size] as! NSNumber)
            if (size == 107277012) {
                canSkipBackup = true;
            }
        }
        if (!canSkipBackup) {
            do {
                try fm.copyItem(atPath: currentMusicFile, toPath: backupMusicFile);
            } catch {
                showAlert(message: "Ran into a problem");
            }
        }
        
    }
    
}

