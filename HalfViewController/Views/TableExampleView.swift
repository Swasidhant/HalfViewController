//
//  TableExampleView.swift
//  HalfViewController
//
//  Created by swasidhant chowdhury on 12/12/20.
//  Copyright © 2020 swasidhant chowdhury. All rights reserved.
//

import UIKit

protocol TableExampleViewDelegate: class {
    func didSelect(index: Int)
}

class TableExampleView: UIView {
    struct DisplayModel {
        var title: String
        var tableRowRepeatTitle: String
    }

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    weak var delegate: HalfVCDelegate?
    weak var tableDelegate: TableExampleViewDelegate?
    
    var displayModel: DisplayModel?
    
    private func initialUISetting() {
        registerCells()
        self.layer.cornerRadius = 15.0
        self.layer.maskedCorners = [.layerMaxXMinYCorner, .layerMinXMinYCorner]
        titleLabel.text = displayModel?.title
        tableView.reloadData()
    }
    
    private func registerCells() {
        tableView.register(UINib.init(nibName: "TableExampleViewCell", bundle: Bundle.main), forCellReuseIdentifier: "TableCell")
    }
}

extension TableExampleView: HalfVCView {

    public func assignValues(_ data: Any?, delegate: HalfVCDelegate) {
        self.delegate = delegate
        if let displayModel = data as? DisplayModel {
            self.displayModel = displayModel
        }
        self.initialUISetting()
    }

    public func giveSizeWith() -> CGSize {
        self.layoutIfNeeded()
        if self.intrinsicContentSize.width < 0 || self.intrinsicContentSize.height < 0 {
            return self.systemLayoutSizeFitting(UIView.layoutFittingExpandedSize)
        } else {
            return self.intrinsicContentSize
        }
    }

    public func assignPresentingControllerDelegates(delegate: Any?) {
        if let tableDelegate = delegate as? TableExampleViewDelegate {
            self.tableDelegate = tableDelegate
        }
    }
}

extension TableExampleView: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 20
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TableCell") as! TableViewExampleCell
        cell.rowLabel.text = displayModel?.tableRowRepeatTitle
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableDelegate?.didSelect(index: indexPath.row)
    }
}
