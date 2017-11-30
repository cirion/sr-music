//
//  ViewController.swift
//  SuperShadowrun
//
//  Copyright © 2017 Cirion. All rights reserved.
//

import Cocoa

class ViewController: NSViewController, NSOpenSavePanelDelegate {
    
    let originalMusicFileSize = NSNumber.init(value: 107277012)
    let newMusicFileSize = NSNumber.init(value: 133545950)
    
    let currentMusicFilePath = "/Contents/Data/resources.assets.resS";
    let backupMusicFilePath = "/Contents/Data/resources.assets.resS.original";
    let assetsFilePath = "/Contents/Data/resources.assets";
    
    // Offsets into resources.assets indicating where each track's size data is located.
    // Note that these should each be on a 4-byte boundary. The difference between each offset can vary
    // based on the length of the track name. The position data is always located 4 bytes after the size data.
    let sizeOffsets: [UInt64] = [
    2002734348, // Hub-TeaHouse
    2002734404, // Hub-Exterior
    2002734464, // Combat-Generic-Int2
    2002734520, // Legwork-SLinterior
    2002734572, // TitleTheme-UI  // INDEX 4: This is hard-coded to play over the main title screen.
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
    
    // The index into the original resources.assets.resS at which each track can be located. Note that this is equivalent
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
    
    // Current mapping.
    /*
     Hub-TeaHouse              -> ../music/vlc_converted/track0.ogg
     Hub-Exterior              -> ../music/vlc_converted/track1.ogg
     Combat-Generic-Int2       -> ../music/vlc_converted/track3.ogg
     Legwork-SLinterior        -> ../music/vlc_converted/track5.ogg
     TitleTheme-UI             -> invocationarray_acff/04siren.ogg
     Combat-Matrix2            -> ../music/combat_matrix2.ogg
     Combat-Kowloon-Int2       -> invocationarray_op/06catalyst.ogg
     Combat-Gobbet-Int1        -> ../music/vlc_converted/track6.ogg
     Combat-Kowloon-WrapUp     -> ../music/vlc_converted/track7.ogg
     Hub-SafeHouse             -> ../music/vlc_converted/track9.ogg
     Combat-Is0bel-Int2        -> ../music/vlc_converted/track12.ogg
     Legwork-Generic           -> ../music/vlc_converted/track14.ogg
     Combat-Kowloon-Int1       -> ../music/vlc_converted/track16.ogg
     Combat-Gobbet-WrapUp      -> ../music/vlc_converted/track17.ogg
     Legwork-Is0bel            -> ../music/vlc_converted/track18.ogg
     Legwork-Erhu              -> ../music/vlc_converted/track22.ogg
     Legwork-Grendel           -> ../music/vlc_converted/track24.ogg
     Legwork-ExitStageLeft     -> ../music/vlc_converted/track26.ogg
     TESTSTINGER               -> ../music/vlc_converted/track27.ogg
     Hub-Club88-ThroughWalls   -> ../music/vlc_converted/track30.ogg
     Legwork-News              -> ../music/vlc_converted/track32.ogg
     Combat-Boss               -> ../music/vlc_converted/track33.ogg
     loudmusic                 -> ../music/vlc_converted/track34.ogg
     Legwork-Whistleblower     -> ../music/vlc_converted/track35.ogg
     Combat-Is0bel-Int1        -> ../music/vlc_converted/track36.ogg
     Combat-Generic-WrapUp     -> ../music/vlc_converted/track37.ogg
     Combat-Generic-Int1       -> ../music/vlc_converted/track38.ogg
     Hub-Club88-InStreet       -> ../music/vlc_converted/track39.ogg
     Legwork-Kowloon           -> ../music/vlc_converted/track41.ogg
     Combat-stinger-end        -> ../music/vlc_converted/track43.ogg
     Combat-VictoriaHarbor-WrapUp -> ../music/vlc_converted/track49.ogg
     Combat-Grendel-Int1       -> ../music/vlc_converted/track46.ogg
     Legwork-Museum            -> ../music/vlc_converted/track47.ogg
     Sewer                     -> ../music/vlc_converted/track48.ogg
     Stealth-Matrix1           -> ../music/stealth_matrix1.ogg
     Legwork-Gobbet            -> ../music/vlc_converted/track50.ogg
     Legwork-Hacking           -> ../music/legwork_hacking.ogg
     Combat-Grendel-WrapUp     -> ../music/vlc_converted/track53.ogg
     KnightKingsElevator       -> ../music/vlc_converted/track51.ogg
     Legwork-VictoriaHarbor    -> ../music/vlc_converted/track54.ogg
     Combat-Grendel-Int2       -> ../music/vlc_converted/track55.ogg
     Combat-Is0bel-WrapUp      -> ../music/vlc_converted/track57.ogg
     Combat-VictoriaHarbor-Int1 -> ../music/vlc_converted/track58.ogg
     Combat-stinger-start      -> ../music/vlc_converted/track59.ogg
     Combat-Gobbet-Int2        -> ../music/vlc_converted/track60.ogg
     Club88-MainRoom           -> invocationarray_acff/08withme.ogg
     Combat-VictoriaHarbor-Int2 -> invocationarray_op/16catalyst.ogg
     */
    
    
    // The index into the new resources.assets.resS at which each track can be located. If using concat.py,
    // these values can be taken from indices.txt. Pad out the array to 47 elements, you can safely reuse the
    // same track multiple times. These do not necessarily need to be in ascending order.
    let newPositionValues: [UInt32] = [
        0,
        1393879,
        3014944,
        4520349,
        6075686,
        13224667,
        16859277,
        23705366,
        27333628,
        30392989,
        31785729,
        36227626,
        37558729,
        39215240,
        42753645,
        48193852,
        50059652,
        52826294,
        58756297,
        60484053,
        61866854,
        64926321,
        67814125,
        69554962,
        70868771,
        74036566,
        77274731,
        78780769,
        80649419,
        82085067,
        83502179,
        85835133,
        89345991,
        90902926,
        92457982,
        96090766,
        99115787,
        100674517,
        102037008,
        104243280,
        107256232,
        111057445,
        113768371,
        115841178,
        117621935,
        118888656,
        126481541
    ]
    
    // The length in bytes of each new music track. Must match the order of tracks in newPositionValues. If using
    // concat.py, these values can be taken from lengths.txt.
    let newSizeValues: [UInt32] = [
        1393879,
        1621065,
        1505405,
        1555337,
        7148981,
        3634610,
        6846089,
        3628262,
        3059361,
        1392740,
        4441897,
        1331103,
        1656511,
        3538405,
        5440207,
        1865800,
        2766642,
        5930003,
        1727756,
        1382801,
        3059467,
        2887804,
        1740837,
        1313809,
        3167795,
        3238165,
        1506038,
        1868650,
        1435648,
        1417112,
        2332954,
        3510858,
        1556935,
        1555056,
        3632784,
        3025021,
        1558730,
        1362491,
        2206272,
        3012952,
        3801213,
        2710926,
        2072807,
        1780757,
        1266721,
        7592885,
        7064409
    ]

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
    
    func showAlert(message: String) {
        let alert = NSAlert();
        alert.messageText = message;
        alert.alertStyle = NSAlertStyle.informational;
        alert.addButton(withTitle: "OK");
        alert.runModal()
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
        let assetsFile = appRoot + assetsFilePath
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
        if (writeArrays(filePath: assetsFile, sizes: originalSizeValues, positions: originalPositionValues)) {
            showAlert(message: "Restore successful! The original Hong Kong music will now play for all campaigns.")
            updateButtons()
        }
    }
    
    func writeArrays(filePath: String, sizes: [UInt32], positions: [UInt32]) -> Bool {
        // Edit the file.
        if let fileHandle = FileHandle(forUpdatingAtPath: filePath) {
            
            for (index, sizeOffset) in sizeOffsets.enumerated() {
                var originalSizeValue = sizes[index]
                let originalSizeData = Data(bytes: &originalSizeValue, count: 4)
                fileHandle.seek(toFileOffset: sizeOffset)
                fileHandle.write(originalSizeData)
                var originalPositionValue = positions[index]
                let originalPositionData = Data(bytes: &originalPositionValue, count: 4)
                fileHandle.seek(toFileOffset: sizeOffset + 4)
                fileHandle.write(originalPositionData)
            }
            
            // If writing multiple, only close after they're all done.
            fileHandle.closeFile()
            return true
        } else {
            showAlert(message: "Could not open resources.assets for editing. Aborting.")
            return false
        }
        
    }
    
    @IBAction func convert(_ sender: Any) {
        let appRoot = filePathTextField.stringValue
        let currentMusicFile = appRoot + currentMusicFilePath
        let backupMusicFile = appRoot + backupMusicFilePath
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
        let resourcePath = bundle.path(forResource: "resources.assets", ofType: "resS")
        do {
            try fm.copyItem(atPath: resourcePath!, toPath: currentMusicFile)
        } catch {
            showAlert(message: "Could not copy new music. Aborting.")
            return;
        }
        
        if (writeArrays(filePath: assetsFile, sizes: newSizeValues, positions: newPositionValues)) {
            showAlert(message: "Conversion successful! The new music will now play for all campaigns, including the official one.")
            updateButtons()
        }
    }
    
}

