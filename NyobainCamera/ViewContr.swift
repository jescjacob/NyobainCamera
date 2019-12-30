//
//  ContentView.swift
//  NyobainCamera
//
//  Created by Jessica Jacob on 27/12/19.
//  Copyright © 2019 Jessica Jacob. All rights reserved.
//

import SwiftUI
import UIKit
import CloudKit

class ViewController:UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    var imageURL : URL?
    
    override func viewDidLoad()
    {
        super.viewDidLoad()
    }
    
    @IBAction func choosePict(_ sender: Any)
    {
        let alert = UIAlertController(title: "Waste  Picture", message: nil, preferredStyle: .actionSheet)
        alert.addAction(UIAlertAction(title:"Take a Photo", style: .default, handler: {(_) in
            print("Open Camera")
          self.camera ()
        }))
        alert.addAction(UIAlertAction(title: "Choose from Photos", style: .default, handler: { (_) in
            print("Choose Image")
            self.photoLibrary()
        }))
        alert.addAction(UIAlertAction(title: "cancel",style: .cancel, handler: { (_) in
            print("Cancel Touch")
        }))
        
        self.present(alert, animated: true, completion: nil)
    }
    
    func camera()
    {
        if UIImagePickerController.isSourceTypeAvailable(.camera){
            let myPickerController = UIImagePickerController()
            myPickerController.delegate = self as! UIImagePickerControllerDelegate & UINavigationControllerDelegate
            myPickerController.sourceType = .camera
            self.present(myPickerController, animated: true, completion: nil)
        } else {
            
        }
    }
    
    func photoLibrary()
    {
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary){ let myPickerController = UIImagePickerController()
            myPickerController.delegate = self
            myPickerController.sourceType = .camera
            present(myPickerController, animated: true, completion: nil)
        }
    }
    func refreshPhoto(image: UIImage){
        imageView.image = image
    }
     let indicator = UIActivityIndicatorView()
    
    @IBAction func uploadButton(_ sender: Any) {
        
        print("Image URL = ", imageURL)
        var newUrl = URL(fileURLWithPath: imageURL!.absoluteString)
    
        indicator.style = .whiteLarge
        indicator.startAnimating()
        uploadToCloudKit (url: newUrl)
        
        view.addSubview(indicator)
    }
    func uploadToCloudKit (url: URL){
        print("Kepencet")
        let database = CKContainer.default().privateCloudDatabase
        
        let sheetName = CKRecord(recordType: "data")
        sheetName ["Sampah"] = CKAsset(fileURL: url)
        
        database.save(sheetName) { (record, error) in
            guard  record != nil else{
                print("Error Occured!")
                DispatchQueue.main.async {
                    self.indicator.stopAnimating()
                }
                return
                
            }
            DispatchQueue.main.async {
                self.indicator.stopAnimating()
            }
            print("sucess add CloudKit")
        }
    }
}

extension ViewController{
    func getDirectoryPath() -> String {
        let path = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent("NyobainCamera")
        //print("path: \(path)")
        return path
    }
    
    func saveImageToDisk(image: UIImage, imageName: String)  {
        let fileManager = FileManager.default
        let path = getDirectoryPath()
        // Make sure the directory exists
        if !fileManager.fileExists(atPath: path) {
            try! fileManager.createDirectory(atPath: path, withIntermediateDirectories: true, attributes: nil)
        }
        let pathUrl = URL(string: path)
        let imagePath = pathUrl!.appendingPathComponent(imageName)
        let urlString: String = imagePath.absoluteString
        print(urlString)
        let imageData = image.jpegData(compressionQuality: 0.5)
        let success = fileManager.createFile(atPath: urlString as String, contents: imageData, attributes: nil)
        print(success)
        
        imageURL = imagePath
    }
}
//MARK: -  UIImagePickerControllerDelegate
extension ViewController : UIImagePickerControllerDelegate, UINavigationControllerDelegate {

// MARK: - UIImagePickerControllerDelegate
     func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
         print(#function)
         if let image = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
             print("We have an image!")
             refreshPhoto(image: image)
             
             let date = Date()
             let calendar = Calendar.current
             let hour = calendar.component(.hour, from: date)
             let minutes = calendar.component(.minute, from: date)
             
             saveImageToDisk(image: image, imageName: "TakeFoto_at_\(minutes)")

         }else{
             print("Something went wrong...")
         }
         
 //        guard let imageURL = info[UIImagePickerController.InfoKey.originalImage] as? NSURL else{return}
 //
 //        self.imageURL = imageURL
         
         self.dismiss(animated: true, completion: nil)
     }
     
     func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
         print(#function)
         self.dismiss(animated: true, completion: nil)
     }
}
