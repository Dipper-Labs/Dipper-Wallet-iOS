//
//  ApiHistory.swift
//  Cosmostation
//
//  Created by 정용주 on 2020/03/11.
//  Copyright © 2020 wannabit. All rights reserved.
//

import Foundation

public class ApiHistory {
    var historyData: Array<HistoryData> = Array<HistoryData>()
    
    init() {}
    
    init(_ dictionary: [String: Any]) {
        let rawDatas = dictionary["data"] as! Array<NSDictionary>
        for rawData in rawDatas {
            self.historyData.append(HistoryData(rawData as! [String : Any]))
        }
    }
    
    
    public class HistoryData {
        var id: Int64 = -1
        var height: Int64 = -1
        var tx_hash: String = ""
        var memo: String = ""
        var time: String = ""
        var fee: Fee = Fee.init()
        var msg: Array<Msg> = Array<Msg>()
        var result: Result = Result.init()
        
        var isSuccess: Bool = true
        
        init() {}
        
        init(_ dictionary: NSDictionary) {
            self.id = dictionary["_id"] as? Int64 ?? -1//Fix for DIP
            self.height = dictionary["height"] as? Int64 ?? -1
            self.tx_hash = dictionary["txhash"] as? String ?? ""//Fix for DIP
            self.memo = dictionary["memo"] as? String ?? ""//Fix for DIP
            self.time = dictionary["timestamp"] as? String ?? ""
            
            if let rawTime = dictionary["time"] as? String {
                self.time = rawTime
            }
            
            if let rawTime = dictionary["timestamp"] as? String {
                self.time = rawTime
            }
            
            if let feedata = dictionary["fee"] as? [String : Any] {//Fix for DIP
                self.fee = Fee.init(feedata)
            }
            
            if let rawMsgs = dictionary["messages"] as? Array<NSDictionary> {
                for rawMsg in rawMsgs {
                    self.msg.append(Msg(rawMsg as! [String : Any]))
                }
            }
            
            if let rawMsgs = dictionary["msg"] as? Array<NSDictionary> {//Fix for DIP
                for rawMsg in rawMsgs {
                    self.msg.append(Msg(rawMsg as! [String : Any]))
                }
            }
            
            if let rawResult = dictionary["result"] as? [String : Any] {//fix for dip
                self.result = Result.init(rawResult)
            }
            
            //DIP memo
            if let tx = dictionary["tx"] as? NSDictionary {
                if let value = tx["value"] as? NSDictionary {
                    if let memo = value.object(forKey: "memo") as? String {
                        self.memo = memo
                    }
                }
            }
            
            //DIP fee
            if let tx = dictionary["tx"] as? NSDictionary {
                if let value = tx["value"] as? NSDictionary {
                    if let feedata = value["fee"] as? [String : Any] {
                            self.fee = Fee.init(feedata)
                    }
                }
            }
            
            //DIP msg
            if let tx = dictionary["tx"] as? NSDictionary {
                if let value = tx["value"] as? NSDictionary {
                    if let rawMsgs = value["msg"] as? Array<NSDictionary> {
                        for rawMsg in rawMsgs {
                            self.msg.append(Msg(rawMsg as! [String : Any]))
                        }
                    }
                }
            }
            
            //TODO this method maybe has some risk
            //DIP log
            var rawResult: [String: Any] = [:]
            rawResult["code"] = dictionary["code"] as? Int64 ?? -1
            rawResult["gas_wanted"] = dictionary["gas_wanted"] as? Int64 ?? -1
            rawResult["gas_uesd"] = dictionary["gas_uesd"] as? Int64 ?? -1
            rawResult["log"] = dictionary["logs"]
            self.result = Result.init(rawResult)
            
//            if let logs = dictionary["logs"] as? Array<NSDictionary> {
//                for log in logs {
//                    if let check = log.object(forKey: "log") as? String {
//                        if (!check.isEmpty) {
//                            self.isSuccess = false
//                            return;
//                        }
//                    }
//                }
//            }
            
            if (dictionary["logs"] as? NSDictionary) != nil {//Fix for dip
                self.isSuccess = true
            } else {
                self.isSuccess = false
            }
            
            if (dictionary["logs"] as? Array<NSDictionary>) != nil {
                self.isSuccess = true
            } else {
                self.isSuccess = false
            }
            
            //DIP success
            if (dictionary["code"] as? String ?? "").isEmpty {
                self.isSuccess = true
            } else {
                self.isSuccess = false
            }
            
        }
        
        init(_ dictionary: [String: Any]) {
            self.id = dictionary["id"] as? Int64 ?? -1
            self.height = dictionary["height"] as? Int64 ?? -1
            self.tx_hash = dictionary["tx_hash"] as? String ?? ""
            self.memo = dictionary["memo"] as? String ?? ""
            self.time = dictionary["time"] as? String ?? ""
            
            if let feedata = dictionary["fee"] as? [String : Any] {
                self.fee = Fee.init(feedata)
            }
            
            let rawMsgs = dictionary["messages"] as! Array<NSDictionary>
            for rawMsg in rawMsgs {
                self.msg.append(Msg(rawMsg as! [String : Any]))
            }
            
            
            if let logs = dictionary["logs"] as? NSDictionary {
                if let check = logs.object(forKey: "log") as? String {
                    if (!check.isEmpty) {
                        self.isSuccess = false
                        return;
                    }
                }
            }
            
            if let logs = dictionary["logs"] as? Array<NSDictionary> {
                for log in logs {
                    if let check = log.object(forKey: "log") as? String {
                        if (!check.isEmpty) {
                            self.isSuccess = false
                            return;
                        }
                    }
                }
            }
            
            if let rawResult = dictionary["result"] as? [String : Any] {
                self.result = Result.init(rawResult)
            }
        }
    }
}
