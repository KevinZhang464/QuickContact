//
//  ContactHelper.swift
//  QuickContact
//
//  Created by Kevin on 18/04/2017.
//  Copyright © 2017 Mother App. All rights reserved.
//

import Foundation
import Contacts

class ContactHelper: NSObject {

    var contactStore = CNContactStore()

    func requestForAccess(completionHandler: @escaping (_ accessGranted: Bool) -> Void, showAlertHandler: @escaping () -> Void) {
        let authorizationStatus = CNContactStore.authorizationStatus(for: CNEntityType.contacts)

        switch authorizationStatus {
        case .authorized:
            completionHandler(true)

        case .denied, .notDetermined:
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, _) -> Void in
                if access {
                    completionHandler(access)
                } else {
                    if authorizationStatus == CNAuthorizationStatus.denied {
                        showAlertHandler()
                    }
                }
            })

        default:
            completionHandler(false)
        }
    }

    func saveContactWithoutDuplicate (employees: [EmployeeMO]) {
        var newPhoneNumbers = [String]()
        for employee in employees {
            let phoneNumber: String! = employee.phoneNumber
            newPhoneNumbers.append(phoneNumber)
        }
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
        ]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        var contacts: [CNContact]! = [CNContact]()
        do {
            try self.contactStore.enumerateContacts(with: request) { contact, _ in
                contacts.append(contact)
            }

            for contact in contacts {
                print("contact:\(contact)")

                let firstName=String(format:"%@", contact.givenName)
                print("first:\(firstName)")

                let lastName=String(format:"%@", contact.familyName)
                print("last:\(lastName)")

                //get all phone numbers
                for contctNumVar: CNLabeledValue in contact.phoneNumbers {
                    let mobNumVar = (contctNumVar.value ).value(forKey: "digits") as! String
                    print("ph no:\(mobNumVar)")
                    if let index = newPhoneNumbers.index(of: mobNumVar) {
                        newPhoneNumbers.remove(at: index)
                    }
                }
            }
            DispatchQueue.main.async(execute: {
            })
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        for employee in employees {
            if newPhoneNumbers.index(of: employee.phoneNumber!) != nil {
                let givenName = employee.givenName
                let familyName = employee.familyName
                let phoneNumber = employee.phoneNumber
                self.saveContact(givenName: givenName,
                                 familyName: familyName,
                                 phoneNumber: phoneNumber)
            }
        }
    }

    func saveContact (givenName: String!, familyName: String!, phoneNumber: String!) {
        let contact = CNMutableContact()
        contact.givenName = givenName
        contact.familyName = familyName
        contact.phoneNumbers = [CNLabeledValue(
            label:CNLabelPhoneNumberiPhone,
            value:CNPhoneNumber(stringValue:phoneNumber))]

        let store = CNContactStore()
        let saveRequest = CNSaveRequest()
        saveRequest.add(contact, toContainerWithIdentifier:nil)
        do {
            try store.execute(saveRequest)
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
    }
}
