    //
    //  PaymentParticipationDataModelTests.swift
    //  SplityTests
    //
    //  Created by Benoit ETIENNE on 03/05/2020.
    //  Copyright © 2020 Benoit ETIENNE. All rights reserved.
    //
    
    import XCTest
    @testable import Splity
    
    
    class PaymentParticipationDataModelTests: XCTestCase {
        
        let dataModelId = UUID()
        var dataModel:PaymentParticipationDataModel!
        
        let costId = UUID()
        
        override func setUp()
        {
            super.setUp()
            dataModel = PaymentParticipationDataModel(id: dataModelId)
            BaseDataModelTests.setBaseModelProperties(dataModel)
            
            dataModel.amount = 10
            dataModel.ratio = 20
            dataModel.participationType = .Amount
            dataModel.costId = costId
        }
        
        func testCreateUrl()
           {
               XCTAssert(dataModel.archivedUrl!.absoluteString.contains("PaymentParticipationDataModel"))
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
            
            guard let loadDataModel: PaymentParticipationDataModel = PaymentParticipationDataModel(id: UUID()).fromData(data) else {
                XCTAssert(false)
                return
            }
            
            XCTAssertEqual(loadDataModel.amount , 10)
            XCTAssertEqual(loadDataModel.ratio , 20)
            XCTAssertEqual(loadDataModel.participationType , ParticipationType.Amount)
            XCTAssertEqual(loadDataModel.costId , costId)
            
            BaseDataModelTests.verifyBaseModelProperties(loadDataModel, dataModel )
        }
        
        
        func testSaveAndLoadModelFromFile()
        {
            _ = dataModel.save()
            
            guard let loadDataModel: PaymentParticipationDataModel = PaymentParticipationDataModel(id: UUID()).load(dataModelId) else {
                XCTAssert(false)
                return
            }
            
            XCTAssertEqual(loadDataModel.amount , 10)
            XCTAssertEqual(loadDataModel.ratio , 20)
            XCTAssertEqual(loadDataModel.participationType , ParticipationType.Amount)
            XCTAssertEqual(loadDataModel.costId , costId)
            
            BaseDataModelTests.verifyBaseModelProperties(loadDataModel, dataModel )
        }
        
        
        func testCreateRecord()
        {
            let record = dataModel.toRecord()
            
            XCTAssert(record.recordType == CloudKitName.paymentParticipationRecordType)
        }
        
        
        func testCreateAndLoadFromRecord()
        {
            let record = dataModel.toRecord()
            
            let loadDataModel =  PaymentParticipationDataModel(id: UUID())
            loadDataModel.fromRecord(record: record)
            
            XCTAssertEqual(loadDataModel.amount , 10)
            XCTAssertEqual(loadDataModel.ratio , 20)
            XCTAssertEqual(loadDataModel.participationType , ParticipationType.Amount)
            XCTAssertEqual(loadDataModel.costId , costId)
            
            BaseDataModelTests.verifyBaseModelProperties(loadDataModel, dataModel)
        }
        
    }
