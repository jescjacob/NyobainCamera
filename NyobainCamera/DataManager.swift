//
//  DataManager.swift
//  NyobainCamera
//
//  Created by Jessica Jacob on 30/12/19.
//  Copyright © 2019 Jessica Jacob. All rights reserved.
//

import Foundation
import UIKit
import CloudKit

class DataManager{
    
    static let shared = DataManager()
    private init (){}
    
    func getDirectoryPath()  -> String {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("NyobainCamera")
        return path
}

    func  savePhoto(image:  UIImage, date:  String)  {
        let imageName = "Sampah Pict_\(date)"
        print("saving imageName: \(imageName)")
       saveImageToDisk(image: image, imageName: imageName)
    }
    
    func saveImageToDisk(image:UIImage, imageName: String) {
        let fileManager = FileManager.default
        let path = getDirectoryPath()
        //make sure teh directory exist
      //  if !FileManager.fileExists(atPath: path) {
        //    try! FileManager.createDirectory(atPath: path, withInterma)
        }
    }

