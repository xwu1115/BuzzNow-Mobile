//
//  RegisterViewController.swift
//  BuzzNowApp
//
//  Created by Shawn Wu on 10/1/16.
//  Copyright © 2016 Shawn Wu. All rights reserved.
//

import UIKit

class RegisterViewController: OnboardingBaseViewController, UITextFieldDelegate {
    @IBOutlet weak var loginBtn: OnboardingLoginButton!

    @IBOutlet weak var profilePic: UIImageView!
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var phoneField: UITextField!
    @IBOutlet weak var addrField: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: UITextField!
    @IBOutlet weak var zipField: UITextField!

    private let networkManager = (UIApplication.sharedApplication().delegate as! AppDelegate).networkManager
    private let context = (UIApplication.sharedApplication().delegate as! AppDelegate).managedObjectContext

    private var shouldAllowContinue: Bool {
        return nameField.text?.characters.count > 0 &&
              phoneField.text?.characters.count > 0 &&
               addrField.text?.characters.count > 0 &&
               cityField.text?.characters.count > 0 &&
              stateField.text?.characters.count > 0 &&
                zipField.text?.characters.count > 0
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        commitInit()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        loginBtn.setTitle("NEXT", forState: .Normal)
    }

    private func commitInit() {
        nameField.delegate = self
        phoneField.delegate = self
        addrField.delegate = self
        cityField.delegate = self
        stateField.delegate = self
        zipField.delegate = self
    }

    @IBAction func backButtonPressed() {
        flowController?.pop()
    }

    @IBAction func nextButtonPressed() {
        let user = context.createOrFetchUser()
        user.name = nameField.text
        user.email = phoneField.text
        user.address = "\(addrField.text!), \(cityField.text!), \(stateField.text!), \(zipField.text!)"
        networkManager.registerUser(user, image: nil) { [weak self] complete in
            if (complete) {
                dispatch_async(dispatch_get_main_queue(), { [weak self] in
                    self?.flowController?.pushNext()
                })
            }
        }
    }

    func textFieldDidEndEditing(textField: UITextField) {
        textField.resignFirstResponder()
    }

    func textFieldShouldReturn(textField: UITextField) -> Bool {
        return true
    }
}
