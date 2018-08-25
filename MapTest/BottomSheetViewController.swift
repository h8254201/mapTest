//
//  BottomSheetViewController.swift
//  viewTest
//
//  Created by Swifty on 2018/8/25.
//  Copyright © 2018年 Swifty. All rights reserved.
//

import UIKit
enum BottomSheetStatus {
  case close
  case openProcess
  case openAll
}

class BottomSheetViewController: UIViewController {
  @IBOutlet weak var topStack: UIStackView!
  @IBOutlet weak var collect: UICollectionView!
  @IBOutlet weak var tableview: UITableView!
  
  var bottomStatus = BottomSheetStatus.openProcess
  override func viewDidLoad() {
    super.viewDidLoad()
    let gesture = UIPanGestureRecognizer.init(target: self, action: #selector(BottomSheetViewController.panGesture))
    
    view.addGestureRecognizer(gesture)
    // Do any additional setup after loading the view.
  }
  
  override func didReceiveMemoryWarning() {
    super.didReceiveMemoryWarning()
    // Dispose of any resources that can be recreated.
  }
  override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)
    prepareBackgroundView()

  }
  override func viewDidAppear(_ animated: Bool) {
    super.viewDidAppear(animated)
    
    UIView.animate(withDuration: 0.3) { [weak self] in
      let frame = self?.view.frame
      let yComponent = UIScreen.main.bounds.height - 200
      self?.view.frame = CGRect(x: 0, y: yComponent, width: frame!.width, height: frame!.height)
    }
  }
  
  func prepareBackgroundView(){
    let blurEffect = UIBlurEffect.init(style: .dark)
    let visualEffect = UIVisualEffectView.init(effect: blurEffect)
    let bluredView = UIVisualEffectView.init(effect: blurEffect)
    bluredView.contentView.addSubview(visualEffect)
    
    visualEffect.frame = UIScreen.main.bounds
    bluredView.frame = UIScreen.main.bounds
    
    view.insertSubview(bluredView, at: 0)
  }
  
  @objc func panGesture(recognizer: UIPanGestureRecognizer) {
    let translation = recognizer.translation(in: self.view)
    let y = self.view.frame.minY
    
    if recognizer.state == .ended {
      switch self.bottomStatus {
      case .close:
        UIView.animate(withDuration: 0.3) { [unowned self] in
          self.view.frame = CGRect(x: 0, y: self.view.frame.height - (self.topStack.frame.height + 8 + 10), width: self.view.frame.width, height: self.view.frame.height)
        }
      case .openProcess:
        UIView.animate(withDuration: 0.3) { [unowned self] in
          self.view.frame = CGRect(x: 0, y: self.view.frame.height - (self.topStack.frame.height + self.collect.frame.height + 16 + 10), width: self.view.frame.width, height: self.view.frame.height)
        }
      case .openAll:
        UIView.animate(withDuration: 0.3) { [unowned self] in
          self.view.frame = CGRect(x: 0, y: 100, width: self.view.frame.width, height: self.view.frame.height)
        }
      }
      
      recognizer.setTranslation(CGPoint.zero, in: self.view)
    } else {
      
      
      
      switch y + translation.y {
      case ..<150:
        self.bottomStatus = .openAll
        self.view.frame = CGRect(x: 0, y: 150, width: view.frame.width, height: view.frame.height)
      case 151...self.view.frame.height - (self.view.frame.height / 3):
        self.bottomStatus = .openProcess
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
      default:
        self.bottomStatus = .close
        self.view.frame = CGRect(x: 0, y: y + translation.y, width: view.frame.width, height: view.frame.height)
      }
      
      recognizer.setTranslation(CGPoint.zero, in: self.view)
    }
    
    
    
  }
  
  /*
   // MARK: - Navigation
   
   // In a storyboard-based application, you will often want to do a little preparation before navigation
   override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
   // Get the new view controller using segue.destinationViewController.
   // Pass the selected object to the new view controller.
   }
   */
  
}
