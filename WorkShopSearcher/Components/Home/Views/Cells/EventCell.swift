//
//  EventCell.swift
//  WorkShopSearcher
//
//  Created by 伊藤凌也 on 2019/04/07.
//  Copyright © 2019 ry-itto. All rights reserved.
//

import UIKit
import SkeletonView

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
    
    @IBOutlet weak var serviceLogoImage: UIImageView! {
        didSet {
            serviceLogoImage.isSkeletonable = true
            serviceLogoImage.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var eventTitleLabel: UILabel! {
        didSet {
            eventTitleLabel.isSkeletonable = true
            eventTitleLabel.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var holdDateLabel: UILabel! {
        didSet {
            holdDateLabel.isSkeletonable = true
            holdDateLabel.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var participantView: UIView! {
        didSet {
            participantView.layer.cornerRadius = 10
            participantView.clipsToBounds = true
            participantView.layer.borderColor = UIColor.lightGray.cgColor
            participantView.layer.borderWidth = 0.4
            participantView.backgroundColor = .white
            participantView.isSkeletonable = true
            participantView.showAnimatedSkeleton()
        }
    }
    @IBOutlet weak var numOfParticipantLabel: UILabel! {
        didSet {
            numOfParticipantLabel.isSkeletonable = true
            numOfParticipantLabel.showAnimatedSkeleton()
        }
    }
    
    /// スケルトンビューを表示する
    func showAllAnimatedSkeleton() {
        serviceLogoImage.showAnimatedSkeleton()
        eventTitleLabel.showAnimatedSkeleton()
        holdDateLabel.showAnimatedSkeleton()
        participantView.showAnimatedSkeleton()
        numOfParticipantLabel.showAnimatedSkeleton()
    }
    
    func configure(service: Service, event: ConnpassResponse.Event) {
        serviceLogoImage.hideSkeleton()
        eventTitleLabel.hideSkeleton()
        holdDateLabel.hideSkeleton()
        participantView.hideSkeleton()
        numOfParticipantLabel.hideSkeleton()
        
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
