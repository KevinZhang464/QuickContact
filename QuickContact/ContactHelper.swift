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
            self.contactStore.requestAccess(for: CNEntityType.contacts, completionHandler: { (access, accessError) -> Void in
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
    
    func getAllContacts () -> [CNContact] {
        let keysToFetch = [
            CNContactGivenNameKey,
            CNContactFamilyNameKey,
            CNContactPhoneNumbersKey
        ]
        let request = CNContactFetchRequest(keysToFetch: keysToFetch as [CNKeyDescriptor])
        var contacts : [CNContact]! = [CNContact]()
        do {
            try self.contactStore.enumerateContacts(with: request) { contact, stop in
                contacts.append(contact)
            }
            
            for contact in contacts {
                print("contact:\(contact)")
                
                let firstName=String(format:"%@",contact.givenName)
                print("first:\(firstName)")
                
                let lastName=String(format:"%@",contact.familyName)
                print("last:\(lastName)")
                
                //get all phone numbers
                // for ContctNumVar: CNLabeledValue in contact.phoneNumbers
                // {
                //     let MobNumVar  = (ContctNumVar.value ).value(forKey: "digits") as? String
                //     print("ph no:\(MobNumVar!)")
                // }
                
                // get one phone number
                let MobNumVar = (contact.phoneNumbers[0].value ).value(forKey: "digits") as! String
                print("mob no:\(MobNumVar)")
            }
            DispatchQueue.main.async(execute: {
            })
        } catch let error as NSError {
            fatalError("Unresolved error \(error), \(error.userInfo)")
        }
        return contacts
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
