//
//  CostDataModelTests.swift
//  SplityTests
//
//  Created by Benoit ETIENNE on 03/05/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//

import XCTest
@testable import Splity


class CostDataModelTests: XCTestCase {
    
    let dataModelId = UUID()
    var dataModel:CostDataModel!
    
    let tripId = UUID()
    let payedBy = [UUID(), UUID()]
    let payedFor = [UUID(), UUID(), UUID()]
    let date = Date(timeIntervalSince1970: 10)
    
    override func setUp()
    {
        super.setUp()
        dataModel = CostDataModel(id: dataModelId)
        BaseDataModelTests.setBaseModelProperties(dataModel)
        
        dataModel.name = "Restau"
        dataModel.date = date
        dataModel.tripId = tripId
        dataModel.amount = 10
        dataModel.categoryType = .Food
        dataModel.costType = .Refund
        dataModel.paymentType = .Cash
        dataModel.currencyCode = "USD"
        dataModel.currencyRateToEuro = 1.2
        dataModel.payedBy = payedBy
        dataModel.payedFor = payedFor
    }
    
    func testCreateUrl()
       {
           XCTAssert(dataModel.archivedUrl!.absoluteString.contains("CostDataModel"))
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
        
        guard let loadedTraveler: CostDataModel = CostDataModel(id: UUID()).fromData(data) else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(loadedTraveler.name , "Restau")
        XCTAssertEqual(loadedTraveler.date , date)
        XCTAssertEqual(loadedTraveler.tripId , tripId)
        XCTAssertEqual(loadedTraveler.amount , 10)
        XCTAssertEqual(loadedTraveler.categoryType , Category.Food)
        XCTAssertEqual(loadedTraveler.paymentType , Payment.Cash)
        XCTAssertEqual(loadedTraveler.costType , CostType.Refund)
        XCTAssertEqual(loadedTraveler.currencyCode , "USD")
        XCTAssertEqual(loadedTraveler.currencyRateToEuro , 1.2)
        XCTAssertEqual(loadedTraveler.payedBy , payedBy)
        XCTAssertEqual(loadedTraveler.payedFor , payedFor)
        BaseDataModelTests.verifyBaseModelProperties(loadedTraveler, dataModel )
    }
    
    
    func testSaveAndLoadModelFromFile()
    {
        _ = dataModel.save()
        
        guard let loadedTraveler: CostDataModel = CostDataModel(id: UUID()).load(dataModelId) else {
            XCTAssert(false)
            return
        }
        
        XCTAssertEqual(loadedTraveler.name , "Restau")
        XCTAssertEqual(loadedTraveler.date , date)
        XCTAssertEqual(loadedTraveler.tripId , tripId)
        XCTAssertEqual(loadedTraveler.amount , 10)
        XCTAssertEqual(loadedTraveler.categoryType , Category.Food)
        XCTAssertEqual(loadedTraveler.paymentType , Payment.Cash)
        XCTAssertEqual(loadedTraveler.costType , CostType.Refund)
        XCTAssertEqual(loadedTraveler.currencyCode , "USD")
        XCTAssertEqual(loadedTraveler.currencyRateToEuro , 1.2)
        XCTAssertEqual(loadedTraveler.payedBy , payedBy)
        XCTAssertEqual(loadedTraveler.payedFor , payedFor)
        BaseDataModelTests.verifyBaseModelProperties(loadedTraveler, dataModel )
    }
    
    
    func testCreateRecord()
    {
        let record = dataModel.toRecord()
        
        XCTAssert(record.recordType == CloudKitName.costRecordType)
    }
    
    
    func testCreateAndLoadFromRecord()
    {
        let record = dataModel.toRecord()
        
        let loadedTraveler =  CostDataModel(id: UUID())
        loadedTraveler.fromRecord(record: record)
        
        XCTAssertEqual(loadedTraveler.name , "Restau")
        XCTAssertEqual(loadedTraveler.date , date)
        XCTAssertEqual(loadedTraveler.tripId , tripId)
        XCTAssertEqual(loadedTraveler.amount , 10)
        XCTAssertEqual(loadedTraveler.categoryType , Category.Food)
        XCTAssertEqual(loadedTraveler.paymentType , Payment.Cash)
        XCTAssertEqual(loadedTraveler.costType , CostType.Refund)
        XCTAssertEqual(loadedTraveler.currencyCode , "USD")
        XCTAssertEqual(loadedTraveler.currencyRateToEuro , 1.2)
        XCTAssertEqual(loadedTraveler.payedBy , payedBy)
        XCTAssertEqual(loadedTraveler.payedFor , payedFor)
        BaseDataModelTests.verifyBaseModelProperties(loadedTraveler, dataModel )
    }
    
}
