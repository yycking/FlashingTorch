//
//  MorseTorch.swift
//  MorseTorch
//
//  Created by YehYungCheng on 2016/1/12.
//  Copyright © 2016年 YehYungCheng. All rights reserved.
//

import AVFoundation

class FlashingTorch: NSObject {
    let MorseCodes = [
        "a": ".-",
        "b": "-...",
        "c": "-.-.",
        "d": "-..",
        "e": ".",
        "f": "..-.",
        "g": "--.",
        "h": "....",
        "i": "..",
        "j": ".---",
        "k": "-.-",
        "l": ".-..",
        "m": "--",
        "n": "-.",
        "o": "---",
        "p": ".--.",
        "q": "--.-",
        "r": ".-.",
        "s": "...",
        "t": "-",
        "u": "..-",
        "v": "...-",
        "w": ".--",
        "x": "-..-",
        "y": "-.--",
        "z": "--..",
        "1": ".----",
        "2": "..---",
        "3": "...--",
        "4": "....-",
        "5": ".....",
        "6": "-....",
        "7": "--...",
        "8": "---..",
        "9": "----.",
        "0": "-----",
        " ": " ",
    ]
    var morseCode = ""
    var stopMorseTorch = true
    var index: String.Index
    let device = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
    let dotTime = 0.2
    
    init(text: String) {
        // convert text to morse code
        let stringToConvert = text.lowercaseString
        let space = "_"
        for char in stringToConvert.characters {
            let returnChar = MorseCodes[String(char)]
            if returnChar != nil {
                morseCode += returnChar! + space
            }
        }
        let range = morseCode.endIndex.advancedBy(-space.characters.count)..<morseCode.endIndex
        morseCode.removeRange(range)
        morseCode += "#"
        
        index = morseCode.startIndex
    }
    
    
    func start() {
        stopMorseTorch = false
        index = morseCode.startIndex
        if device.hasTorch {
            torchOff()
            NSTimer.scheduledTimerWithTimeInterval(dotTime, target: self, selector: "next", userInfo: nil, repeats: false)
        }
    }
    
    func stop() {
        stopMorseTorch = true
        torchOff()
    }
    
    func next() {
        if stopMorseTorch {
            return
        }
        var onMS = 0.0
        var offMS = 0.0
        let morse = morseCode[index]
        switch morse {
        case ".":
            onMS = dotTime
            offMS = dotTime
        case "-":
            onMS = dotTime*3
            offMS = dotTime
        case "_":
            offMS = dotTime*2
        case " ":
            offMS = dotTime*6
        default: // "#"
            stop()
            return
        }
        index++
        
        if onMS>0 {
            torchOn()
            NSTimer.scheduledTimerWithTimeInterval(onMS, target: self, selector: "torchOff", userInfo: nil, repeats: false)
        }
        
        if offMS>0 {
            NSTimer.scheduledTimerWithTimeInterval(onMS + offMS, target: self, selector: "next", userInfo: nil, repeats: false)
        }
    }
    
    func torchOn() {
        do {
            try device.lockForConfiguration()
            try device.setTorchModeOnWithLevel(1.0)
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
    
    func torchOff() {
        do {
            try device.lockForConfiguration()
            device.torchMode = AVCaptureTorchMode.Off
            device.unlockForConfiguration()
        } catch {
            print(error)
        }
    }
}

