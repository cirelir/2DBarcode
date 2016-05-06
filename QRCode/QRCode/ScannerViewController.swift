//
//  ScannerViewController.swift
//  QRCode
//
//  Created by Erwin on 16/5/5.
//  Copyright © 2016年 Erwin. All rights reserved.
//

import UIKit
import AVFoundation

class ScannerViewController: UIViewController,AVCaptureMetadataOutputObjectsDelegate,UIImagePickerControllerDelegate,UINavigationControllerDelegate {
    
    //相机显示视图
    let cameraView = UIView(frame: UIScreen.mainScreen().bounds)
    
    //屏幕扫描区域视图
    let barcodeView = UIView(frame: CGRectMake(UIScreen.mainScreen().bounds.size.width * 0.2, UIScreen.mainScreen().bounds.size.height * 0.35, UIScreen.mainScreen().bounds.size.width * 0.6, UIScreen.mainScreen().bounds.size.width * 0.6))
    
    //扫描线
    let scanLayer = CALayer()
    
    let captureSession = AVCaptureSession()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "扫一扫"
        
        
        //设置导航栏
        let barButtonItem = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Add, target: self, action: #selector(ScannerViewController.selectPhotoFormPhotoLibrary(_:)))
        self.navigationItem.rightBarButtonItem = barButtonItem
        
        self.view.addSubview(cameraView)
        
        //初始化捕捉设备（AVCaptureDevice），类型AVMdeiaTypeVideo
        let captureDevice = AVCaptureDevice.defaultDeviceWithMediaType(AVMediaTypeVideo)
        
        let input :AVCaptureDeviceInput
        
        //创建媒体数据输出流
        let output = AVCaptureMetadataOutput()
        
        do{
            //创建输入流
            input = try AVCaptureDeviceInput(device: captureDevice)
            
            //把输入流添加到会话
            captureSession.addInput(input)
            
            //把输出流添加到会话
            captureSession.addOutput(output)
        }catch {
            print("异常")
        }
        
        //创建串行队列
        let dispatchQueue = dispatch_queue_create("queue", nil)
        
        //设置输出流的代理
        output.setMetadataObjectsDelegate(self, queue: dispatchQueue)
        
        //设置输出媒体的数据类型
        output.metadataObjectTypes = NSArray(array: [AVMetadataObjectTypeQRCode,AVMetadataObjectTypeEAN13Code,AVMetadataObjectTypeEAN8Code, AVMetadataObjectTypeCode128Code]) as [AnyObject]
        
        //创建预览图层
        let videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        
        //设置预览图层的填充方式
        videoPreviewLayer.videoGravity = AVLayerVideoGravityResizeAspectFill
        
        //设置预览图层的frame
        videoPreviewLayer.frame = cameraView.bounds
        
        //将预览图层添加到预览视图上
        cameraView.layer.addSublayer(videoPreviewLayer)
        
        //设置扫描范围
        output.rectOfInterest = CGRectMake(0.2, 0.2, 0.6, 0.6)
        
        barcodeView.layer.borderWidth = 1.0
        barcodeView.layer.borderColor = UIColor.greenColor().CGColor
        
        cameraView.addSubview(barcodeView)
        
        //设置扫描线
        scanLayer.frame = CGRectMake(0, 0, barcodeView.frame.size.width, 1)
        
        //添加扫描线图层
        barcodeView.layer.addSublayer(scanLayer)
        
        NSTimer.scheduledTimerWithTimeInterval(0.2, target: self, selector: #selector(ScannerViewController.moveScannerLayer(_:)), userInfo: nil, repeats: true)
        
        captureSession.startRunning()
        
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        captureSession.startRunning()
    }
    //扫描代理方法
    func captureOutput(captureOutput: AVCaptureOutput!, didOutputMetadataObjects metadataObjects: [AnyObject]!, fromConnection connection: AVCaptureConnection!) {
        if metadataObjects != nil && metadataObjects.count > 0 {
            let metaData = metadataObjects.first
            print(metaData?.stringValue)
            dispatch_async(dispatch_get_main_queue(), { 
                let result = WebViewController()
                result.url = metaData?.stringValue
                
                self.navigationController?.pushViewController(result, animated: true)
            })
            captureSession.stopRunning()
        }
    }
    
    //让扫描线滚动
    func moveScannerLayer(timer : NSTimer) {
        var frame = scanLayer.frame
        if barcodeView.frame.size.height < frame.origin.y {
            frame.origin.y = 0
            scanLayer.frame = frame
        }else{
            frame.origin.y += 5
            scanLayer.frame = frame
        }
    }
    
    
    //从相册中选择图片
    func selectPhotoFormPhotoLibrary(sender : AnyObject){
        let picture = UIImagePickerController()
        picture.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        picture.delegate = self
        self.presentViewController(picture, animated: true, completion: nil)
        
    }
    
    //选择相册中的图片完成，进行获取二维码信息
    
    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : AnyObject]) {
        let image = info[UIImagePickerControllerOriginalImage]
        
        let imageData = UIImagePNGRepresentation(image as! UIImage)
        
        let ciImage = CIImage(data: imageData!)
        
        let detector = CIDetector(ofType: CIDetectorTypeQRCode, context: nil, options: [CIDetectorAccuracy: CIDetectorAccuracyLow])
        
        let array = detector.featuresInImage(ciImage!)
        
        let result : CIQRCodeFeature = array.first as! CIQRCodeFeature
        
        
        let resultView = WebViewController()
        resultView.url = result.messageString
        
        self.navigationController?.pushViewController(resultView, animated: true)
        picker.dismissViewControllerAnimated(true, completion: nil)
        print(result.messageString)
        
        
    }

}
