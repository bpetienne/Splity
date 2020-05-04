//
//  BaseModelTests.swift
//  SplityTests
//
//  Created by Benoit ETIENNE on 03/05/2020.
//  Copyright © 2020 Benoit ETIENNE. All rights reserved.
//


import XCTest
@testable import Splity


class BaseDataModelTests: XCTestCase {
    
    var dataModelId = UUID()
    var dataModel:BaseDataModel!
    
    override func setUp() {
        super.setUp()
        dataModel = BaseDataModel(id: dataModelId)
        BaseDataModelTests.setBaseModelProperties(dataModel)
        
    }
    
    func testCreateUrl()
    {
        XCTAssert(dataModel.archivedUrl!.absoluteString.contains("BaseDataModel"))
    }
    
    func testSave() {
        let data = dataModel.toData()
        
        XCTAssert(data != nil)
    }
    
    func testSaveInFile() {
        let success = dataModel.save()
        
        XCTAssert(success)
    }
    
    func testSaveAndLoadModel() {
        let data = dataModel.toData()
        
        guard let loadedDataModel: BaseDataModel = BaseDataModel(id: UUID()).fromData(data) else {
            XCTAssert(false)
            return
        }
        
        BaseDataModelTests.verifyBaseModelProperties(loadedDataModel, dataModel )
    }
    
    
    func testSaveAndLoadModelFromFile() {
        
        _ = dataModel.save()
        
        guard let loadedDataModel: BaseDataModel = BaseDataModel(id: UUID()).load(dataModelId) else {
            XCTAssert(false)
            return
        }
        
        BaseDataModelTests.verifyBaseModelProperties(loadedDataModel, dataModel )
    }
    
    func testSaveAndLoadModelWithNilMembersFromFile() {
        
        dataModel.localCreationDate = nil
        dataModel.lastLocalModificationDate = nil
        dataModel.lastRemoteSaveDate = nil
        dataModel.lastLocalSaveDate = nil
        dataModel.lastLocalLoadDate = nil
        dataModel.lastRemoteLoadDate = nil
        dataModel.remoteModificationDate = nil
        dataModel.remoteCreationDate = nil
        
        _ = dataModel.save()
        
        guard let loadedDataModel: BaseDataModel = BaseDataModel(id: UUID()).load(dataModelId) else {
            XCTAssert(false)
            return
        }
        
        
        XCTAssertEqual(loadedDataModel.id , dataModelId )
        XCTAssertEqual(loadedDataModel.recordName , dataModelId.uuidString)
        XCTAssertEqual(loadedDataModel.localCreationDate, nil)
        XCTAssertEqual(loadedDataModel.lastLocalModificationDate , nil)
        XCTAssertEqual(loadedDataModel.lastRemoteSaveDate , nil)
        XCTAssertEqual(loadedDataModel.lastLocalSaveDate , nil)
        XCTAssertEqual(loadedDataModel.lastLocalLoadDate , nil)
        XCTAssertEqual(loadedDataModel.lastRemoteLoadDate , nil)
        XCTAssertEqual(loadedDataModel.remoteModificationDate ,nil)
        XCTAssertEqual(loadedDataModel.remoteCreationDate ,nil)
    }
    
    func testCreateRecord() {
        
        let record = dataModel.toRecord()
        
        XCTAssert(record.recordType == CloudKitName.baseModelRecordType)
    }
    
    
    func testCreateAndLoadFromRecord() {
        
        let record = dataModel.toRecord()
        
        let loadedDataModel =  BaseDataModel(id: UUID())
        loadedDataModel.fromRecord(record: record)
        
        BaseDataModelTests.verifyBaseModelProperties(loadedDataModel, dataModel )
    }
    
    func testCreateAndLoadModelWithNilMembersFromRecord() {
        
        dataModel.localCreationDate = nil
        dataModel.lastLocalModificationDate = nil
        dataModel.lastRemoteSaveDate = nil
        dataModel.lastLocalSaveDate = nil
        dataModel.lastLocalLoadDate = nil
        dataModel.lastRemoteLoadDate = nil
        dataModel.remoteModificationDate = nil
        dataModel.remoteCreationDate = nil
        
        let record = dataModel.toRecord()
        
        let loadedDataModel =  BaseDataModel(id: UUID())
        loadedDataModel.fromRecord(record: record)
        
        XCTAssertEqual(loadedDataModel.id , dataModelId )
        XCTAssertEqual(loadedDataModel.recordName , dataModelId.uuidString)
        XCTAssertEqual(loadedDataModel.localCreationDate, nil)
        XCTAssertEqual(loadedDataModel.lastLocalModificationDate , nil)
        XCTAssertEqual(loadedDataModel.lastRemoteSaveDate , nil)
        XCTAssertEqual(loadedDataModel.lastLocalSaveDate , nil)
        XCTAssertEqual(loadedDataModel.lastLocalLoadDate , nil)
        XCTAssertEqual(loadedDataModel.lastRemoteLoadDate , nil)
        XCTAssertEqual(loadedDataModel.remoteModificationDate ,nil)
        XCTAssertEqual(loadedDataModel.remoteCreationDate ,nil)
    }
    
    
    static func setBaseModelProperties( _ internalModel: BaseDataModel){
        internalModel.localCreationDate = Date(timeIntervalSince1970: TimeInterval(10))
        internalModel.lastLocalModificationDate = Date(timeIntervalSince1970: TimeInterval(20))
        internalModel.lastRemoteSaveDate = Date(timeIntervalSince1970: TimeInterval(30))
        internalModel.lastLocalSaveDate = Date(timeIntervalSince1970: TimeInterval(40))
        internalModel.lastLocalLoadDate = Date(timeIntervalSince1970: TimeInterval(50))
        internalModel.lastRemoteLoadDate = Date(timeIntervalSince1970: TimeInterval(60))
        internalModel.remoteModificationDate = Date(timeIntervalSince1970: TimeInterval(70))
        internalModel.remoteCreationDate = Date(timeIntervalSince1970: TimeInterval(80))
    }
    
    static func verifyBaseModelProperties(_ internalModel: BaseDataModel, _ internalModelRef: BaseDataModel){
        XCTAssertEqual(internalModel.id , internalModelRef.id )
        XCTAssertEqual(internalModel.recordName , internalModelRef.recordName)
        XCTAssertEqual(internalModel.localCreationDate, Date(timeIntervalSince1970: TimeInterval(10)))
        XCTAssertEqual(internalModel.lastLocalModificationDate , Date(timeIntervalSince1970: TimeInterval(20)))
        XCTAssertEqual(internalModel.lastRemoteSaveDate , Date(timeIntervalSince1970: TimeInterval(30)))
        XCTAssertEqual(internalModel.lastLocalSaveDate , Date(timeIntervalSince1970: TimeInterval(40)))
        XCTAssertEqual(internalModel.lastLocalLoadDate , Date(timeIntervalSince1970: TimeInterval(50)))
        XCTAssertEqual(internalModel.lastRemoteLoadDate , Date(timeIntervalSince1970: TimeInterval(60)))
        XCTAssertEqual(internalModel.remoteModificationDate , Date(timeIntervalSince1970: TimeInterval(70)))
        XCTAssertEqual(internalModel.remoteCreationDate , Date(timeIntervalSince1970: TimeInterval(80)))
    }
}
