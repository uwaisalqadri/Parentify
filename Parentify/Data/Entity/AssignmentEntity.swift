//
//  AssignmentEntity.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/7/22.
//

import SwiftUI
import Firebase

enum AssigmnentTypeEntity: String, Codable {
  case needToDone = "need_to_done"
  case additional = "additional"
}

struct AssignmentEntity: BodyCodable, Codable {

  enum CodingKeys: String, CodingKey {
    case id = "assignment_id"
    case iconName = "icon_name"
    case title = "title"
    case description = "description"
    case type = "type"
    case dateCreated = "date_created"
    case attachments = "attachments"
    case assignedTo = "assigned_to"
  }

  var id: String?
  var iconName: String?
  var title: String?
  var description: String?
  var type: AssigmnentTypeEntity?
  var dateCreated: Timestamp?
  var attachments: [String]?
  var assignedTo: [UserEntity]?

  init(id: String?, iconName: String?, title: String?, description: String?, type: AssigmnentTypeEntity?, dateCreated: Timestamp?, attachments: [String]?, assignedTo: [UserEntity]?) {
    self.id = id
    self.iconName = iconName
    self.title = title
    self.description = description
    self.type = type
    self.dateCreated = dateCreated
    self.attachments = attachments
    self.assignedTo = assignedTo
  }
}
