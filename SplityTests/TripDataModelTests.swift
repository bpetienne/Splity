//
//  TripDataModelTests.swift
//  SplityTests
//
//  Created by Benoit ETIENNE on 03/05/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import XCTest
@testable import Splity


class TripDataModelTests: XCTestCase {
    
    let dataModelId = UUID()
    var dataModel:TripDataModel!
     
    
    let tripId = UUID()
       let costIds = [UUID(), UUID()]
       let travelerIds = [UUID(), UUID(), UUID()]
       let beginDate = Date(timeIntervalSince1970: 10)
       let endDate = Date(timeIntervalSince1970: 20)

    let imageData = Data()
    let countries = ["France", "USA"]
    let currencyCodes = ["EUR", "USD"]


    override func setUp()
    {
        super.setUp()
        dataModel = TripDataModel(id: dataModelId)
        BaseDataModelTests.setBaseModelProperties(dataModel)
        
        dataModel.name = "New York"
        dataModel.beginDate = beginDate
        dataModel.endDate = endDate
        dataModel.countries = countries
        dataModel.currencyCodes = currencyCodes
        dataModel.imageData = imageData
        dataModel.mainCountry = "France"
        dataModel.lastCurrencyCode = "USD"
        dataModel.costIds = costIds
        dataModel.travelerIds = travelerIds
    }
    
    func testCreateUrl()
    {
        XCTAssert(dataModel.archivedUrl!.absoluteString.contains("TripDataModel"))
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
        
        guard let loadedTraveler: TripDataModel = TripDataModel(id: UUID()).fromData(data) else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(loadedTraveler.name , "New York")
        XCTAssertEqual(loadedTraveler.beginDate , beginDate)
        XCTAssertEqual(loadedTraveler.endDate , endDate)
        XCTAssertEqual(loadedTraveler.mainCountry , "France")
        XCTAssertEqual(loadedTraveler.lastCurrencyCode , "USD")
        XCTAssertEqual(loadedTraveler.countries , countries)
        XCTAssertEqual(loadedTraveler.currencyCodes , currencyCodes)
        XCTAssertEqual(loadedTraveler.imageData , imageData)
        XCTAssertEqual(loadedTraveler.costIds , costIds)
        XCTAssertEqual(loadedTraveler.travelerIds , travelerIds)
        BaseDataModelTests.verifyBaseModelProperties(loadedTraveler, dataModel )
    }
    
    
    func testSaveAndLoadModelFromFile()
    {
        _ = dataModel.save()
        
        guard let loadedTraveler: TripDataModel = TripDataModel(id: UUID()).load(dataModelId) else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(loadedTraveler.name , "New York")
        XCTAssertEqual(loadedTraveler.beginDate , beginDate)
        XCTAssertEqual(loadedTraveler.endDate , endDate)
        XCTAssertEqual(loadedTraveler.mainCountry , "France")
        XCTAssertEqual(loadedTraveler.lastCurrencyCode , "USD")
        XCTAssertEqual(loadedTraveler.countries , countries)
        XCTAssertEqual(loadedTraveler.currencyCodes , currencyCodes)
        XCTAssertEqual(loadedTraveler.imageData , imageData)
        XCTAssertEqual(loadedTraveler.costIds , costIds)
        XCTAssertEqual(loadedTraveler.travelerIds , travelerIds)
        BaseDataModelTests.verifyBaseModelProperties(loadedTraveler, dataModel )
    }
    
    
    func testCreateRecord()
    {
        let record = dataModel.toRecord()
        
        XCTAssert(record.recordType == CloudKitName.tripRecordType)
    }
    
    
    func testCreateAndLoadFromRecord()
    {
        let record = dataModel.toRecord()
        
        let loadedTraveler =  TripDataModel(id: UUID())
        loadedTraveler.fromRecord(record: record)
        
        XCTAssertEqual(loadedTraveler.name , "New York")
        XCTAssertEqual(loadedTraveler.beginDate , beginDate)
        XCTAssertEqual(loadedTraveler.endDate , endDate)
        XCTAssertEqual(loadedTraveler.mainCountry , "France")
        XCTAssertEqual(loadedTraveler.lastCurrencyCode , "USD")
        XCTAssertEqual(loadedTraveler.countries , countries)
        XCTAssertEqual(loadedTraveler.currencyCodes , currencyCodes)
        XCTAssertEqual(loadedTraveler.costIds , costIds)
        XCTAssertEqual(loadedTraveler.travelerIds , travelerIds)

        BaseDataModelTests.verifyBaseModelProperties(loadedTraveler, dataModel )
        
        //todo
        //XCTAssertEqual(loadedTraveler.imageData , imageData)

    }

}
