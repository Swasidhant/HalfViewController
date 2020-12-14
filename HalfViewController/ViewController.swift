//
//  ViewController.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 08/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

class OptionsViewController: UIViewController {
    
    struct CellDisplayModel: Codable {
        var cellTitle: String
        var cellXibName: String
        var additionalData: [String: String]?
        
        enum CodingKeys: String, CodingKey {
            case cellTitle = "title"
            case cellXibName = "xib"
            case additionalData
        }
    }
    
    var arrData: [CellDisplayModel] = []

    @IBOutlet weak var collectionView: UICollectionView!
        
    override func viewDidLoad() {
        super.viewDidLoad()
        collectionView.collectionViewLayout = UICollectionViewFlowLayout()
        initialiseData()
        collectionView.reloadData()
        // Do any additional setup after loading the view.
    }
    
    private func initialiseData() {
        if let dataURL = Bundle.main.url(forResource: "data", withExtension: "json") {
            do {
                let data = try Data.init(contentsOf: dataURL)
                self.arrData = try JSONDecoder().decode([CellDisplayModel].self, from: data)
            } catch {
                print("data.json is not present")
            }
        }
    }
    
    private func indexSelected(_ index: Int) {
        switch index {
        case 0:
            let displayModel = InfoView.DisplayModel(title: "The Flash", subtitle: "Secret Identities", desc: "Barry Allen\nJay Garrick\nWally West\nBart Allen", imgName: "flash")
            let halfVC = HalfViewController.controller(xibName: "InfoView", bundle: Bundle.main, data: displayModel)
            halfVC.bgColor = UIColor.black.withAlphaComponent(0.8)
            halfVC.halfViewDelegate = self
            self.present(halfVC, animated: true, completion: nil)
        case 1:
            let displayModel = InfoView.DisplayModel(title: "Green Lantern", subtitle: "Secret Identities", desc: "Hal Jordan\nJohn Stewart\nGur Gardner\nKyle Rayner\n\nThis view will not dismiss on tapping on background", imgName: "lantern")
            let halfVC = HalfViewController.controller(xibName: "InfoView", bundle: Bundle.main, data: displayModel)
            halfVC.bgColor = UIColor.black.withAlphaComponent(0.8)
            halfVC.dismissOnOutsideTap = false
            halfVC.halfViewDelegate = self
            self.present(halfVC, animated: true, completion: nil)
        case 2:
            let displayModel = KeyboardView.DisplayModel(title: "Batman", desc: "What do you think of Batman?")
            let halfVC = HalfViewController.controller(xibName: "KeyboardView", bundle: Bundle.main, data: displayModel)
            halfVC.bgColor = UIColor.black.withAlphaComponent(0.8)
            halfVC.halfViewDelegate = self
            self.present(halfVC, animated: true, completion: nil)
        case 3:
            let displayModel = AlertExampleView.DisplayModel(title: "Nightwing", desc: "The following button will share Nightwing's identity", alertMsg: "Dick Grayson is Nightwing!")
            let halfVC = HalfViewController.controller(xibName: "AlertExampleView", bundle: Bundle.main, data: displayModel)
            halfVC.bgColor = UIColor.black.withAlphaComponent(0.8)
            halfVC.halfViewDelegate = self
            self.present(halfVC, animated: true, completion: nil)
        case 4:
            let displayModel = TableExampleView.DisplayModel.init(title: "Superman", tableRowRepeatTitle: "• Man of Steel")
            let halfVC = HalfViewController.controller(xibName: "TableExampleView", bundle: Bundle.main, data: displayModel)
            halfVC.bgColor = UIColor.black.withAlphaComponent(0.8)
            halfVC.maxHeight = UIScreen.main.bounds.height - 200.0
            halfVC.halfViewDelegate = self
            self.present(halfVC, animated: true, completion: nil)
        case 5:
            let secondDisplayModel = TwoViewSecondView.DisplayModel.init(title: "Clark Kent")
            let displayModel = TwoViewFirstView.DisplayModel.init(title: "Superman", subtitle: "Secret Identity", desc: "We now reveal the secret identity of Superman! Hold your horses!. This is the big one...", newXIBName: "TwoViewSecond", nextScreenModel: secondDisplayModel)
            let halfVC = HalfViewController.controller(xibName: "TwoViewFirst", bundle: Bundle.main, data: displayModel)
            halfVC.bgColor = UIColor.black.withAlphaComponent(0.8)
            halfVC.halfViewDelegate = self
            self.present(halfVC, animated: true, completion: nil)
        default:
            break
        }
    }
}

extension OptionsViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        arrData.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "OptionsCell", for: indexPath) as! OptionsCollectionCell
        let model = arrData[indexPath.item]
        cell.assignTitle(model.cellTitle)
        return cell
    }
}

extension OptionsViewController: UICollectionViewDelegate, UICollectionViewDelegateFlowLayout {
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let screenWidth = UIScreen.main.bounds.width
        return CGSize(width: screenWidth/2.0 - 5.0, height: 80.0)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 10.0
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        indexSelected(indexPath.item)
    }
}

extension OptionsViewController: InfoViewDelegate {
    func understandBtnPressed() {
        self.dismiss(animated: true, completion: nil)
    }
}

extension OptionsViewController: KeyboardViewDelegate {
    func donePressed(text: String) {
        print(text)
    }
}

extension OptionsViewController: TableExampleViewDelegate {
    func didSelect(index: Int) {
        print(index)
    }
}

extension OptionsViewController: TwoViewSecondViewDelegate {
    func donePressed() {
        self.dismiss(animated: true, completion: nil)
    }
}
