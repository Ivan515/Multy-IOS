//Copyright 2017 Idealnaya rabota LLC
//Licensed under Multy.io license.
//See LICENSE for details

import UIKit

class TransactionViewController: UIViewController {

    @IBOutlet weak var titleLbl: UILabel!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var backView: UIView!
    @IBOutlet weak var dateLbl: UILabel!
    @IBOutlet weak var transactionImg: UIImageView!
    @IBOutlet weak var transctionSumLbl: UILabel! // +0.0152 receive | -0.0123 send
    @IBOutlet weak var transactionCurencyLbl: UILabel! // BTC | ETH
    @IBOutlet weak var sumInFiatLbl: UILabel! //+1 174 USD receive | -1 123 EUR send
    @IBOutlet weak var noteLbl: UILabel!
    @IBOutlet weak var walletFromAddressLbl: UILabel!
    @IBOutlet weak var arrowImg: UIImageView!  // downArrow receive | upArrow send
    @IBOutlet weak var blockchainImg: UIImageView!
    @IBOutlet weak var personNameLbl: UILabel!   // To Vadim
    @IBOutlet weak var walletToAddressLbl: UILabel!
    @IBOutlet weak var numberOfConfirmationLbl: UILabel! // 6 Confirmations
    @IBOutlet weak var viewInBlockchainBtn: UIButton!
    @IBOutlet weak var constraintNoteFiatSum: NSLayoutConstraint! // set 20 if note == "
    
    @IBOutlet weak var donationView: UIView!
    @IBOutlet weak var donationCryptoSum: UILabel!
    @IBOutlet weak var donationCryptoName: UILabel!
    @IBOutlet weak var donationFiatSumAndName: UILabel!
    @IBOutlet weak var constraintDonationHeight: NSLayoutConstraint!
    
    let presenter = TransactionPresenter()
    
    var isForReceive = true
    var cryptoName = "BTC"
    
    var sumInCripto = 1.125
    var fiatSum = 1255.23
    var fiatName = "USD"
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.presenter.transctionVC = self
        self.tabBarController?.tabBar.isHidden = true
        self.tabBarController?.tabBar.frame = CGRect(x: 0, y: 0, width: 0, height: 0)
        self.checkHeightForSrollAvailability()
        self.checkForSendOrReceive()
        self.constraintDonationHeight.constant = 0
        self.donationView.isHidden = true
        self.updateUI()
    }

    func checkHeightForSrollAvailability() {
//        if screenHeight >= 667 {
//            self.scrollView.isScrollEnabled = false
//        }
    }
    
    func checkForSendOrReceive() {
        if self.isForReceive == true {  // RECEIVE
            self.makeBackColor(color: self.presenter.receiveBackColor)
        } else {                        // SEND
            self.makeBackColor(color: self.presenter.sendBackColor)
            self.titleLbl.text = "Send \(self.cryptoName)"
            self.transactionImg.image = #imageLiteral(resourceName: "sendBigIcon")
            self.transctionSumLbl.text = "-\(self.sumInCripto)"
            self.transactionCurencyLbl.text = self.cryptoName.uppercased()
            self.sumInFiatLbl.text = "-\(self.fiatSum) \(self.fiatName)"
            self.constraintNoteFiatSum.constant = 15 // make check of note
            self.noteLbl.isHidden = true
//            self.walletFromAddressLbl.text = "" //Set address from here
//            self.blockchainImg.image // Set blockchain image here
//            self.personNameLbl.text = ""  // Set name from address book
//            self.walletToAddressLbl.text = "" // Set address to here
//            self.numberOfConfirmationLbl.text = "" // Set information from sockets here
            
        }
    }
    
    func updateUI() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH:mm, d MMMM yyyy"
        
        let cryptoSumInBTC = convertSatoshiToBTC(sum: UInt32(truncating: presenter.histObj.txOutAmount))
        
        self.dateLbl.text = dateFormatter.string(from: presenter.histObj.blockTime)
        self.transctionSumLbl.text = "+\(cryptoSumInBTC.fixedFraction(digits: 8))"
//        self.transactionCurencyLbl.text = presenter.histObj.     // check currencyID
        self.sumInFiatLbl.text = "+\((cryptoSumInBTC * presenter.histObj.btcToUsd).fixedFraction(digits: 2)) USD"
        self.noteLbl.text = "" // NOTE FROM HIST OBJ
        self.noteLbl.frame.size.height = 0
        var addressFromArr = String()
        for output in presenter.histObj.txOutputs {
            if output.address != presenter.histObj.addresses {
                addressFromArr.append(output.address)
            }
        }
        self.walletFromAddressLbl.text = addressFromArr
        self.personNameLbl.text = ""   // before we don`t have address book
        self.walletToAddressLbl.text = presenter.histObj.addresses
        self.numberOfConfirmationLbl.text = "\(presenter.histObj.confirmations) Confirmation"
    }
    
    func makeBackColor(color: UIColor) {
        self.backView.backgroundColor = color
        self.scrollView.backgroundColor = color
    }
    
    @IBAction func closeAction() {
        self.navigationController?.popViewController(animated: true)
    }
    
    @IBAction func viewInBlockchainAction(_ sender: Any) {
        self.performSegue(withIdentifier: "viewInBlockchain", sender: nil)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "viewInBlockchain" {
            let blockchainVC = segue.destination as! ViewInBlockchainViewController
            blockchainVC.presenter.txId = presenter.histObj.txId
        }
    }
    
}
