//
//  EventCell.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit

enum Service {
    case connpass
    case supporterz
    case doorkeeper
    
    var image: UIImage? {
        switch self {
        case .connpass:
            return UIImage(named: "connpass_logo")
        case .supporterz:
            return UIImage(named: "supporterzcolab_logo_2")
        case .doorkeeper:
            return nil
        }
    }
}

class EventCell: UITableViewCell {
    
    static let rowHeight: CGFloat = 92.5
    class var cellIdentifier: String {
        return String(describing: type(of: self))
    }
    
    private var holdDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy/MM/dd hh:mm"
        return formatter
    }
    
    @IBOutlet weak var serviceLogoImage: UIImageView!
    @IBOutlet weak var eventTitleLabel: UILabel!
    @IBOutlet weak var holdDateLabel: UILabel!
    @IBOutlet weak var participantView: UIView! {
        didSet {
            participantView.layer.cornerRadius = 10
            participantView.clipsToBounds = true
            participantView.layer.borderColor = UIColor.lightGray.cgColor
            participantView.layer.borderWidth = 0.4
            participantView.backgroundColor = .white
        }
    }
    @IBOutlet weak var numOfParticipantLabel: UILabel!
    
    func configure(service: Service, event: ConnpassResponse.Event) {
        eventTitleLabel.text = event.title
        holdDateLabel.text = "\(holdDateFormatter.string(from: event.startedAt)) ~ 開催"
        if let limit = event.limit {
            numOfParticipantLabel.text = "\(event.accepted)/\(limit)"
        } else {
            numOfParticipantLabel.text = "\(event.accepted)"
        }
        
        serviceLogoImage.image = service.image
    }
}
