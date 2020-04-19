//
//  InternalProtocol.swift
//  Splity
//
//  Created by Benoit ETIENNE on 18/04/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import Foundation
import CloudKit

protocol CloudProtocol {
    
    func createRecord() -> CKRecord
    func fillRecord(record: CKRecord)
    func fromRecord(record: CKRecord)
}

protocol LocalProtocol: Codable {
    static func getArchivedUrl(_ uuid: UUID?) -> URL?
    var archivedUrl: URL? {get}
}

