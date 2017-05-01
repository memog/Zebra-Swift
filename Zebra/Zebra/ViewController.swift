//
//  ViewController.swift
//  Zebra
//
//  Created by Guillermo Garcia on 30/04/17.
//  Copyright © 2017 Guillermo Garcia. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        let thread = Thread(target:self, selector:#selector(start), object:nil)
        thread.start()
    }
    
    func start(){
        EAAccessoryManager.shared().registerForLocalNotifications()
        
        let bluetoothPrinters = EAAccessoryManager.shared().connectedAccessories
        let printer = bluetoothPrinters.first
        
        autoreleasepool{
            let connection:MfiBtPrinterConnection = MfiBtPrinterConnection(serialNumber: printer?.serialNumber)
            
            let open = connection.open()
            if(open)//connection.isConnected())
            {
                do {
                    //    try SGD.SET("bluetooth.page_scan_window", withValue: "60", andWithPrinterConnection: connection)
                    let  printer   =  try ZebraPrinterFactory.getInstance(connection)
                    let lang =  printer.getControlLanguage()
                    
                    if(lang != PRINTER_LANGUAGE_CPCL){
                        let tool = printer.getToolsUtil()
                        try  tool?.sendCommand("^XA^FO17,16^GB379,371,8^FS^FT65,255^A0N,135,134^FDMEMO^FS^XZ")
                    }
                } catch {
                    print(error)
                }
                connection.close()
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

