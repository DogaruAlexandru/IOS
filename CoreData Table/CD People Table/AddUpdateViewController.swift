//
//  AddUpdateViewController.swift
//  CD People Table
//
//  Created by student on 23.04.2024.
//

import UIKit
import CoreData

class AddUpdateViewController: UIViewController, UIImagePickerControllerDelegate, UINavigationControllerDelegate {

    //MARK : - Outlets and Action
    @IBOutlet weak var nameTF: UITextField!
    @IBOutlet weak var phoneTF: UITextField!
    @IBOutlet weak var addressTF: UITextField!
    
    @IBOutlet weak var pickedImageView: UIImageView!
    
    @IBAction func addUpdateAction(_ sender: Any) {
        if peopleManagedObject == nil {
            newCDPerson()
        } else {
            updateCDPerson()
        }
        
        navigationController?.popViewController(animated: true)
    }
    
    @IBAction func pickedAction(_ sender: Any) {
        // setup the picker
        picker.sourceType = .photoLibrary
        picker.allowsEditing = false
        picker.delegate = self
        
        // present it
        present(picker, animated: true)
    }
    
    
    //MARK CD methods and actions
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    var peopleManagedObject : CDPeople!
    var peopleEntity : NSEntityDescription!
    
    func newCDPerson() {
        // new CDPeople obj
        peopleEntity = NSEntityDescription.entity(forEntityName: "CDPeople", in: context)
        peopleManagedObject = CDPeople(entity: peopleEntity, insertInto: context)
        
        // populate it with the fields values
        peopleManagedObject.name = nameTF.text
        peopleManagedObject.phone = phoneTF.text
        peopleManagedObject.address = addressTF.text
        
        // contex saves it
        do {
            try context.save()
        } catch {
            print("CD cannot save")
        }
        
        // save image to document
        if peopleManagedObject.address != nil {
            saveImage(name: peopleManagedObject.address!)
        }
    }
    
    func updateCDPerson() {
        // populate it with the fields values
        peopleManagedObject.name = nameTF.text
        peopleManagedObject.phone = phoneTF.text
        peopleManagedObject.address = addressTF.text
        
        // contex saves it
        do {
            try context.save()
        } catch {
            print("CD cannot save")
        }
        
        // save image to document
        if peopleManagedObject.address != nil {
            saveImage(name: peopleManagedObject.address!)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // populate fields with peaopleManagedObect data
        if peopleManagedObject != nil {
            nameTF.text = peopleManagedObject.name
            phoneTF.text = peopleManagedObject.phone
            addressTF.text = peopleManagedObject.address
            
            if addressTF.text != nil {
                getImageToView(name: addressTF.text!)
            }
        }
    }
    
    //MARK: - Image work
    let picker = UIImagePickerController()
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        let pickedImage = info[UIImagePickerController.InfoKey.originalImage] as! UIImage
        
        pickedImageView.image = pickedImage
        
        dismiss(animated: true)
    }
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        return
    }
    
    func saveImage(name: String) {
        // get the path to documents
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = path.appendingPathComponent(name)
        
        // get the image from pickedImageView
        let image = pickedImageView.image
        
        // generate ong data
        let imageData = image?.pngData()
        
        // get a fm to create the data
        let fn = FileManager.default
        fn.createFile(atPath: imagePath, contents: imageData)
    }
    
    func getImageToView(name: String) {
        // get the path to documents
        let path = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString
        let imagePath = path.appendingPathComponent(name)
        
        // load the image
        let image = UIImage(contentsOfFile: imagePath)
        
        pickedImageView.image = image
    }
}
