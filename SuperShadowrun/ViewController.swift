//
//  ViewController.swift
//  SuperShadowrun
//
//  Created by Chris King on 6/8/17.
//  Copyright © 2017 Cirion. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOpenSavePanelDelegate {
    
    let originalMusicFileSize = NSNumber.init(value: 107277012)
    let newMusicFileSize = NSNumber.init(value: 6648343)
    
    let currentMusicFilePath = "/Contents/Data/resources.assets.resS";
    let backupMusicFilePath = "/Contents/Data/resources.assets.resS.original";
    let assetsFilePath = "/Contents/Data/resources.assets";
//    let assetsFilePath = "/Contents/Data/test.txt";
    
    // Offsets into resources.assets indicating where each track's size and position data is located. 
    // Note that these should each be on a 4-byte boundary. The difference between each offset can vary
    // based on the length of the track name.
    let sizeOffsets: [UInt64] = [
    2002734348, // Hub-TeaHouse
    2002734404, // Hub-Exterior
    2002734464, // Combat-Generic-Int2
    2002734520, // Legwork-SLinterior
    2002734572, // TitleTheme-UI
    2002734628, // Combat-Matrix2
    2002734688, // Combat-Kowloon-Int2
    2002734744, // Combat-Gobbet-Int1
    2002734804, // Combat-Kowloon-WrapUp
    2002734860, // Hub-SafeHouse
    2002734920, // Combat-Is0bel-Int2
    2002734972, // Legwork-Generic
    2002735032, // Combat-Kowloon-Int1
    2002735092, // Combat-Gobbet-WrapUp
    2002735148, // Legwork-Is0bel
    2002735204, // Legwork-Erhu
    2002735260, // Legwork-Grendel
    2002735324, // Legwork-ExitStageLeft
    2002735368, // TESTSTINGER
    2002735428, // Hub-Club88-ThroughWalls
    2002735484, // Legwork-News
    2002735536, // Combat-Boss
    2002735584, // loudmusic
    2002735644, // Legwork-Whistleblower
    2002735704, // Combat-Is0bel-Int1
    2002735764, // Combat-Generic-WrapUp
    2002735824, // Combat-Generic-Int1
    2002735880, // Hub-Club88-InStreet
    2002735932, // Legwork-Kowloon
    2002735992, // Combat-stinger-end
    2002736060, // Combat-VictoriaHarbor-WrapUp
    2002736120, // Combat-Grendel-Int1
    2002736172, // Legwork-Museum
    2002736220, // Sewer
    2002736276, // Stealth-Matrix1
    2002736332, // Legwork-Gobbet
    2002736388, // Legwork-Hacking
    2002736452, // Combat-Grendel-WrapUp
    2002736512, // KnightKingsElevator
    2002736572, // Legwork-VictoriaHarbor
    2002736632, // Combat-Grendel-Int2
    2002736692, // Combat-Is0bel-WrapUp
    2002736760, // Combat-VictoriaHarbor-Int1
    2002736820, // Combat-stinger-start
    2002736880, // Combat-Gobbet-Int2
    2002736936, // Club88-MainRoom
    2002737000  // Combat-VictoriaHarbor-Int2
    ]
    
    // The length in bytes of each original music track.
    let originalSizeValues: [UInt32] = [
        3124118, // Hub-TeaHouse
        5637311, // Hub-Exterior
        2455468, // Combat-Generic-Int2
        2188997, // Legwork-SLinterior
        3114666, // TitleTheme-UI
        3634610, // Combat-Matrix2
        2041430, // Combat-Kowloon-Int2
        1584803, // Combat-Gobbet-Int1
        2041354, // Combat-Kowloon-WrapUp
        4940165, // Hub-SafeHouse
        1561545, // Combat-Is0bel-Int2
        3314926, // Legwork-Generic
        2041479, // Combat-Kowloon-Int1
        1587808, // Combat-Gobbet-WrapUp
        2769366, // Legwork-Is0bel
        2335314, // Legwork-Erhu
        4081442, // Legwork-Grendel
        2137171, // Legwork-ExitStageLeft
        23526,   // TESTSTINGER
        1945087, // Hub-Club88-ThroughWalls
        814330,  // Legwork-News
        2379429, // Combat-Boss
        1461465, // loudmusic
        2076460, // Legwork-Whistleblower
        1561924, // Combat-Is0bel-Int1
        2453965, // Combat-Generic-WrapUp
        2456846, // Combat-Generic-Int1
        1946422, // Hub-Club88-InStreet
        4769051, // Legwork-Kowloon
        174750,  // Combat-stinger-end
        1555841, // Combat-VictoriaHarbor-WrapUp
        2201208, // Combat-Grendel-Int1
        3824152, // Legwork-Museum
        1248239, // Sewer
        3632784, // Stealth-Matrix1
        3386400, // Legwork-Gobbet
        1558730, // Legwork-Hacking
        2204440, // Combat-Grendel-WrapUp
        1722733, // KnightKingsElevator
        2772684, // Legwork-VictoriaHarbor
        2203725, // Combat-Grendel-Int2
        1561357, // Combat-Is0bel-WrapUp
        1556476, // Combat-VictoriaHarbor-Int1
        98473,   // Combat-stinger-start
        1587346, // Combat-Gobbet-Int2
        1951436, // Club88-MainRoom
        1555760  // Combat-VictoriaHarbor-Int2
    ]
    // The index into the original  resources.assets.resS at which each track can be located. Note that this is equivalent
    // to a running total of the values in originalSizeValues because the tracks happen to be listed in order.
    let originalPositionValues: [UInt32] = [
        0,          // Hub-TeaHouse
        3124118,    // Hub-Exterior
        8761429,    // Combat-Generic-Int2
        11216897,   // Legwork-SLinterior
        13405894,   // TitleTheme-UI
        16520560,   // Combat-Matrix2
        20155170,   // Combat-Kowloon-Int2
        22196600,   // Combat-Gobbet-Int1
        23781403,   // Combat-Kowloon-WrapUp
        25822757,   // Hub-SafeHouse
        30762922,   // Combat-Is0bel-Int2
        32324467,   // Legwork-Generic
        35639393,   // Combat-Kowloon-Int1
        37680872,   // Combat-Gobbet-WrapUp
        39268680,   // Legwork-Is0bel
        42038046,   // Legwork-Erhu
        44373360,   // Legwork-Grendel
        48454802,   // Legwork-ExitStageLeft
        50591973,   // TESTSTINGER
        50615499,   // Hub-Club88-ThroughWalls
        52560586,   // Legwork-News
        53374916,   // Combat-Boss
        55754345,   // loudmusic
        57215810,   // Legwork-Whistleblower
        59292270,   // Combat-Is0bel-Int1
        60854194,   // Combat-Generic-WrapUp
        63308159,   // Combat-Generic-Int1
        65765005,   // Hub-Club88-InStreet
        67711427,   // Legwork-Kowloon
        72480478,   // Combat-stinger-end
        72655228,   // Combat-VictoriaHarbor-WrapUp
        74211069,   // Combat-Grendel-Int1
        76412277,   // Legwork-Museum
        80236429,   // Sewer
        81484668,   // Stealth-Matrix1
        85117452,   // Legwork-Gobbet
        88503852,   // Legwork-Hacking
        90062582,   // Combat-Grendel-WrapUp
        92267022,   // KnightKingsElevator
        93989755,   // Legwork-VictoriaHarbor
        96762439,   // Combat-Grendel-Int2
        98966164,   // Combat-Is0bel-WrapUp
        100527521,  // Combat-VictoriaHarbor-Int1
        102083997,  // Combat-stinger-start
        102182470,  // Combat-Gobbet-Int2
        103769816,  // Club88-MainRoom
        105721252   // Combat-VictoriaHarbor-Int2
    ]
    
    // The length in bytes of each new music track.
//    let newSizeValues: [UInt32] = [3124118, 5637311, 2455468]
    // The index into the new resources.assets.resS at which each track can be located. These do not necessarily need to be
    // in ascending order.
//    let newPositionValues: [UInt32] = [0, 3124118, 8761429]
    
    //MARK: Properties
    
    @IBOutlet weak var selectButton: NSButtonCell!
    @IBOutlet weak var filePathTextField: NSTextField!
    @IBOutlet weak var convertButton: NSButtonCell!
    @IBOutlet weak var restoreButton: NSButton!
    
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
                updateButtons()
            }
        } else {
            // User clicked on "Cancel"
            return
        }
    }
    
    func updateButtons() {
        let fm = FileManager.default;
        let appRoot = filePathTextField.stringValue
        let currentMusicFile = appRoot + currentMusicFilePath
        let backupMusicFile = appRoot + backupMusicFilePath
        convertButton.isEnabled = fm.fileExists(atPath: currentMusicFile) && getFileSizeFor(path: currentMusicFile) != newMusicFileSize
        restoreButton.isEnabled = fm.fileExists(atPath: backupMusicFile) && getFileSizeFor(path: currentMusicFile) != getFileSizeFor(path: backupMusicFile)
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
        
        convertButton.isEnabled = false
        restoreButton.isEnabled = false
        filePathTextField.isEditable = false
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
    
    @IBAction func restoreOriginalMusic(_ sender: Any) {
        let appRoot = filePathTextField.stringValue
        let currentMusicFile = appRoot + currentMusicFilePath
        let backupMusicFile = appRoot + backupMusicFilePath
        let fm = FileManager.default
        // Shouldn't be possible since we only enable if the file exists, but just being extra-safe.
        if (!fm.fileExists(atPath: backupMusicFile)) {
            showAlert(message: "Backup does not exist. Aborting.")
            return
        }
        if (getFileSizeFor(path: backupMusicFile) != originalMusicFileSize) {
            showAlert(message: "Found a backup, but it was the wrong size. Please restore by verifying the integrity of Shadowrun Hong Kong within Steam.")
            return
        }
        
        do {
            try fm.removeItem(atPath: currentMusicFile)
        } catch {
            showAlert(message: "Could not remove updated music. Aborting.")
            return
        }
        
        do {
            try fm.copyItem(atPath: backupMusicFile, toPath: currentMusicFile)
        } catch {
            showAlert(message: "Could not restore backup. Please restore by verifying the integrity of Shadowrun Hong Kong within Steam.")
            return
        }
        showAlert(message: "Restore successful! The original Hong Kong music will now play for all campaigns.")
        updateButtons()
    }
    
    @IBAction func convert(_ sender: Any) {
        let appRoot = filePathTextField.stringValue
        let currentMusicFile = appRoot + currentMusicFilePath
        let backupMusicFile = appRoot + backupMusicFilePath
//        let assetsFile = appRoot + "/Contents/Data/resources.assets";
        let assetsFile = appRoot + assetsFilePath
        let fm = FileManager.default
        var canSkipBackup = false;
        if (fm.fileExists(atPath: backupMusicFile)) {
            let backupFileSize = getFileSizeFor(path: backupMusicFile)
            if (backupFileSize == originalMusicFileSize) {
                canSkipBackup = true;
            }
        }
        if (!canSkipBackup) {
            let currentMusicFileSize = getFileSizeFor(path: currentMusicFile)
            if (currentMusicFileSize != originalMusicFileSize) {
                showAlert(message: "WARNING: The current music file size appears incorrect. Please correct by verifying the integrity of Shadowrun Hong Kong within Steam. Aborting.")
                return;
            }
            do {
                try fm.copyItem(atPath: currentMusicFile, toPath: backupMusicFile);
            } catch {
                showAlert(message: "Could not back up original music. Aborting.")
                return
            }
        }
        
        do {
            try fm.removeItem(atPath: currentMusicFile)
        } catch {
            showAlert(message: "Could not remove original music. Aborting.")
            return
        }
        
        let bundle = Bundle.main
        let resourcePath = bundle.path(forResource: "mercury", ofType: "bin")
        do {
            try fm.copyItem(atPath: resourcePath!, toPath: currentMusicFile)
        } catch {
            showAlert(message: "Could not copy new music. Aborting.")
            return;
        }
        
        // Edit the file.
        if let fileHandle = FileHandle(forUpdatingAtPath: assetsFile) {
            
            for (index, sizeOffset) in sizeOffsets.enumerated() {
//                let trackSize = 5123456
//                var fileOffset = sizeOffset
                // TODO: Should write new, not original, here.
                var originalSizeValue = originalSizeValues[index]
                let originalSizeData = Data(bytes: &originalSizeValue, count: 4)
                fileHandle.seek(toFileOffset: sizeOffset)
                fileHandle.write(originalSizeData)
                var originalPositionValue = originalPositionValues[index]
                let originalPositionData = Data(bytes: &originalPositionValue, count: 4)
                fileHandle.seek(toFileOffset: sizeOffset + 4)
                fileHandle.write(originalPositionData)
            }
            
            // If writing multiple, only close after they're all done.
            fileHandle.closeFile()
        } else {
            showAlert(message: "Could not open resources.assets for editing. Please restore the original music and try again. Aborting.")
            return
        }
        showAlert(message: "Conversion successful! The new music will now play for all campaigns, including the original.")
        updateButtons()
    }
    
}

