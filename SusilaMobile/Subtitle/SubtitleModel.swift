//
//  SubtitleModel.swift
//  SusilaMobile
//
//  Created by Meuru Muthuthanthri on 7/7/18.
//  Copyright © 2018 Isuru Jayathissa. All rights reserved.
//

import Foundation
import SWXMLHash

class SubtitleModel: NSObject {
    
    var subtitleXml: XMLIndexer?
    var languages: [String?] = []
    var currentLanguage: String?
    var selectedSubtitles: [SubtitleLine]?
    var currentSubtileIndex: Int = 0
    
    @objc
    func setSubtitleXml(xml: String) -> Array<String> {
        subtitleXml = SWXMLHash.parse(xml)
        
        languages = subtitleXml!["tt"]["body"]["div"].all.map { elem in
            elem.element?.attribute(by: "xml:lang")?.text
        }
        
        return languages as! Array<String>
    }
    
    @objc
    func setLanguage(language: String) {
        if (languages.contains(language)) {
            currentLanguage = language
            do {
                let subtitles = try subtitleXml!["tt"]["body"]["div"].withAttribute("xml:lang", currentLanguage!)
                selectedSubtitles = []
                for elem in subtitles["div"].all {
                    let subtitleElement = elem["p"].element
                    let beginTime = convertStringToTime((subtitleElement?.attribute(by: "begin")?.text)!)
                    let endTime = convertStringToTime((subtitleElement?.attribute(by: "end")?.text)!)
                    selectedSubtitles?.append(SubtitleLine(beginTime: beginTime, endTime: endTime, text: subtitleElement?.text))
                }
                let startTime = selectedSubtitles?.last?.endTime
                let endTime = startTime! + 60
                selectedSubtitles?.append(SubtitleLine(beginTime: startTime!, endTime: endTime + 60, text: ""))
            } catch let error {
                print(error)
            }
            
        } else {
            print("Error selected language \(language)")
        }
    }
    
    func convertStringToTime(_ string: String) -> Float {
        let timeSplit = string.split(separator: ":")
        return Float(timeSplit[2])! + Float(timeSplit[1])! * 60 + Float(timeSplit[0])! * 3600
    }
    
    @objc
    func getSubtitle(time: Float) -> String {
        if (currentLanguage?.isEmpty)! { return "" }
        if (selectedSubtitles![currentSubtileIndex].beginTime < time && selectedSubtitles![currentSubtileIndex].endTime > time) {
            return selectedSubtitles![currentSubtileIndex].text!
        } else if ( selectedSubtitles![currentSubtileIndex].endTime < time && selectedSubtitles![currentSubtileIndex + 1].beginTime > time) {
            return ""
        } else if (currentSubtileIndex < ((selectedSubtitles?.count)! - 1) && selectedSubtitles![currentSubtileIndex + 1].beginTime < time && selectedSubtitles![currentSubtileIndex + 1].endTime > time) {
            currentSubtileIndex += 1
            return selectedSubtitles![currentSubtileIndex].text!
        } else {
            for x in 0..<((selectedSubtitles?.count)! - 1) {
                if (selectedSubtitles![x].beginTime < time && selectedSubtitles![x].endTime > time) {
                    currentSubtileIndex = x
                    return selectedSubtitles![currentSubtileIndex].text!
                } else if (selectedSubtitles![x].endTime < time && selectedSubtitles![x+1].beginTime > time) {
                    currentSubtileIndex = x
                    return ""
                }
            }
        }
        return ""
    }
}

class SubtitleLine: NSObject {
    var beginTime: Float
    var endTime: Float
    var text: String?
    
    init(beginTime: Float, endTime: Float, text: String?){
        self.beginTime = beginTime
        self.endTime = endTime
        self.text = text
    }
}

