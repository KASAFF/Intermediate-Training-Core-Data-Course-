//
//  CreateCompanyController.swift
//  IntermediateTraining
//
//  Created by Aleksey Kosov on 09.01.2023.
//

import UIKit
import CoreData

//Custom Delegation

protocol CreateCompanyControllerDelegate: AnyObject {
    func didAddCompany(company: Company)
}


class CreateCompanyController: UIViewController {

   weak var delegate: CreateCompanyControllerDelegate?

    let nameLabel: UILabel = {
        let label = UILabel()
        label.text = "Name"
        //enable autolayout
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    let nameTextField: UITextField = {
        let textField = UITextField()
        textField.placeholder = "Enter name"
        textField.translatesAutoresizingMaskIntoConstraints = false
        return textField
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()

        navigationItem.title = "Create Company"

        navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Cancel", style: .plain, target: self, action: #selector(handleCancel))

        navigationItem.rightBarButtonItem = UIBarButtonItem(title: "Save", style: .plain, target: self, action: #selector(handleSave))

        view.backgroundColor = .darkBlue
    }

    @objc private func handleSave() {
        print("trying to save ocmpany")

        // initialization of our Core Data Stack

//        let persistentContainer = NSPersistentContainer(name: "IntermediateTrainingModels")
//        persistentContainer.loadPersistentStores { storeDescription, err in
//            if let err = err {
//                fatalError("Loading of store failed: \(err)")
//            }
//        }
//
//        let context = persistentContainer.viewContext

        let context = CoreDataManager.shared.persistentContainer.viewContext

        let company = NSEntityDescription.insertNewObject(forEntityName: "Company", into: context)

        company.setValue(nameTextField.text, forKey: "name")

        // perform the save

        do {
            try context.save()

            // success
            dismiss(animated: true) {
                self.delegate?.didAddCompany(company: company as! Company)
            }

        } catch let saveErr {
            print("Failed to save company: ", saveErr)
        }
    }

    private func setupUI() {

        let lightBlueBackgroundView = UIView()
        view.addSubview(lightBlueBackgroundView)
        lightBlueBackgroundView.backgroundColor = .lightBlue
        lightBlueBackgroundView.translatesAutoresizingMaskIntoConstraints = false
        lightBlueBackgroundView.leadingAnchor.constraint(equalTo: view.leadingAnchor).isActive = true
        lightBlueBackgroundView.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        lightBlueBackgroundView.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        lightBlueBackgroundView.heightAnchor.constraint(equalToConstant: 400).isActive = true


        view.addSubview(nameLabel)
        nameLabel.topAnchor.constraint(equalTo: view.topAnchor).isActive = true
        nameLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 60).isActive = true
        nameLabel.widthAnchor.constraint(equalToConstant: 100).isActive = true
        //nameLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nameLabel.heightAnchor.constraint(equalToConstant: 50).isActive = true

        view.addSubview(nameTextField)

        nameTextField.leadingAnchor.constraint(equalTo: nameLabel.trailingAnchor).isActive = true
        nameTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor).isActive = true
        nameTextField.bottomAnchor.constraint(equalTo: nameLabel.bottomAnchor).isActive = true
        nameTextField.topAnchor.constraint(equalTo: nameLabel.topAnchor).isActive = true


    }

   @objc private func handleCancel() {
        dismiss(animated: true)
    }



}
