//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import Foundation
import UIKit
import RealmSwift

class WalletPresenter: NSObject {
    
    var mainVC : WalletViewController?
    var blockedAmount = UInt32(0)
    var wallet : UserWalletRLM? {
        didSet {
            blockedAmount = calculateBlockedAmount()
            print("WalletPresenter:\n\(wallet?.addresses)")
            updateWalletInfo()
        }
    }
    var account : AccountRLM?
    
    var transactionsArray = [TransactionRLM]()
    
    func updateWalletInfo() {
        mainVC?.titleLbl.text = wallet?.name
        mainVC?.updateUI()
    }
    
    var historyArray = List<HistoryRLM>() {
        didSet {
            blockedAmount = calculateBlockedAmount()
            updateWalletInfo()
        }
    }
    
    func registerCells() {
        let walletHeaderCell = UINib.init(nibName: "MainWalletHeaderCell", bundle: nil)
        self.mainVC?.tableView.register(walletHeaderCell, forCellReuseIdentifier: "MainWalletHeaderCellID")
        
//        let walletCollectionCell = UINib.init(nibName: "MainWalletCollectionViewCell", bundle: nil)
//        self.mainVC?.tableView.register(walletCollectionCell, forCellReuseIdentifier: "WalletCollectionViewCellID")
        
        let transactionCell = UINib.init(nibName: "TransactionWalletCell", bundle: nil)
        self.mainVC?.tableView.register(transactionCell, forCellReuseIdentifier: "TransactionWalletCellID")
        
        let transactionPendingCell = UINib.init(nibName: "TransactionPendingCell", bundle: nil)
        self.mainVC?.tableView.register(transactionPendingCell, forCellReuseIdentifier: "TransactionPendingCellID")
    }
    
    func fixConstraints() {
        if #available(iOS 11.0, *) {
            //OK: Storyboard was made for iOS 11
        } else {
            self.mainVC?.tableViewTopConstraint.constant = 0
        }
    }
    
    func numberOfTransactions() -> Int {
        return self.historyArray.count
    }
    
    func getHistoryAndWallet() {
        DataManager.shared.getOneWalletVerbose(account!.token, walletID: wallet!.walletID) { (wallet, error) in
            if wallet != nil {
                self.wallet = wallet
            }
        }
        
        DataManager.shared.getTransactionHistory(token: (account?.token)!, walletID: (wallet?.walletID)!) { (histList, err) in
            if err == nil && histList != nil {
               self.historyArray = histList!
            }
//            self.mainVC?.progressHUD.hide()
//            self.mainVC?.updateUI()
        }
    }
    
    func calculateBlockedAmount() -> UInt32 {
        var sum = UInt32(0)
        
        if wallet == nil {
            return sum
        }
        
        if historyArray.count == 0 {
            return sum
        }
        
//        for address in wallet!.addresses {
//            for out in address.spendableOutput {
//                if out.transactionStatus.intValue == TxStatus.MempoolIncoming.rawValue {
//                    sum += out.transactionOutAmount.uint32Value
//                } else if out.transactionStatus.intValue == TxStatus.MempoolOutcoming.rawValue {
//                    out.
//                }
//            }
//        }
        for history in historyArray {
            if history.txStatus.intValue == TxStatus.MempoolIncoming.rawValue {
                sum += history.txOutAmount.uint32Value
            } else if history.txStatus.intValue == TxStatus.MempoolOutcoming.rawValue {
                let addresses = wallet!.fetchAddresses()
                
                for tx in history.txOutputs {
                    if addresses.contains(tx.address) {
                        sum += history.txOutAmount.uint32Value
                    }
                }
            }
        }
        
        return sum
    }
}
