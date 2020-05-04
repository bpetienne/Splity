//
//  ApplicationDataModelTests.swift
//  SplityTests
//
//  Created by Benoit ETIENNE on 03/05/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import XCTest
@testable import Splity


class ApplicationDataModelTests: XCTestCase {
    
    let dataModelId = UUID()
    var dataModel:ApplicationDataModel!
    
    let tripIds = [UUID(),UUID()]
    let deletedTripIds = [UUID(),UUID()]
    let costIds = [UUID(),UUID()]
    let travelerIds = [UUID(),UUID()]
    let paymentParticipationIds = [UUID(),UUID()]

    override func setUp()
    {
        super.setUp()
        dataModel = ApplicationDataModel(id: dataModelId)
        BaseDataModelTests.setBaseModelProperties(dataModel)
        
        dataModel.tripIds = tripIds
        dataModel.deletedTripIds = deletedTripIds
        dataModel.costIds = costIds
        dataModel.travelerIds = travelerIds
        dataModel.paymentParticipationIds = paymentParticipationIds
    }
    
    func testCreateUrl()
       {
           XCTAssert(dataModel.archivedUrl!.absoluteString.contains("ApplicationDataModel"))
       }
    
    func testSave()
    {
        let data = dataModel.toData()
        
        XCTAssert(data != nil)
    }
    
    func testSaveInFile() {
        let success = dataModel.save()
        
        XCTAssert(success)
    }
    
    func testSaveAndLoadModel()
    {
        let data = dataModel.toData()
        
        guard let loadedDataModel: ApplicationDataModel = ApplicationDataModel(id: UUID()).fromData(data) else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(loadedDataModel.tripIds , tripIds)
        XCTAssertEqual(loadedDataModel.deletedTripIds , deletedTripIds)
        XCTAssertEqual(loadedDataModel.costIds , costIds)
        XCTAssertEqual(loadedDataModel.travelerIds , travelerIds)
        XCTAssertEqual(loadedDataModel.paymentParticipationIds , paymentParticipationIds)
        BaseDataModelTests.verifyBaseModelProperties(loadedDataModel, dataModel )
    }
    
    
    func testSaveAndLoadModelFromFile()
    {
        _ = dataModel.save()
        
        guard let loadedDataModel: ApplicationDataModel = ApplicationDataModel(id: UUID()).load(dataModelId) else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(loadedDataModel.tripIds , tripIds)
        XCTAssertEqual(loadedDataModel.deletedTripIds , deletedTripIds)
        XCTAssertEqual(loadedDataModel.costIds , costIds)
        XCTAssertEqual(loadedDataModel.travelerIds , travelerIds)
        XCTAssertEqual(loadedDataModel.paymentParticipationIds , paymentParticipationIds)
        BaseDataModelTests.verifyBaseModelProperties(loadedDataModel, dataModel )
    }
    
    
    func testCreateRecord()
    {
        let record = dataModel.toRecord()
        
        XCTAssert(record.recordType == CloudKitName.appRecordType)
    }
    
    
    func testCreateAndLoadFromRecord()
    {
        let record = dataModel.toRecord()
        
        let loadedDataModel =  ApplicationDataModel(id: UUID())
        loadedDataModel.fromRecord(record: record)
        
        XCTAssertEqual(loadedDataModel.tripIds , tripIds)
        XCTAssertEqual(loadedDataModel.deletedTripIds , deletedTripIds)
        XCTAssertEqual(loadedDataModel.costIds , costIds)
        XCTAssertEqual(loadedDataModel.travelerIds , travelerIds)
        XCTAssertEqual(loadedDataModel.paymentParticipationIds , paymentParticipationIds)
        BaseDataModelTests.verifyBaseModelProperties(loadedDataModel, dataModel )
    }

}
