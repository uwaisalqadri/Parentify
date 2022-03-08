//
//  AssignmentMapper.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/8/22.
//

import SwiftUI

extension AssignmentEntity {
  func map() -> Assignment {
    return Assignment(
      id: UUID(uuidString: id.orEmpty()) ?? UUID(),
      iconName: iconName.orEmpty(),
      title: title.orEmpty(),
      description: description.orEmpty(),
      type: AssigmnentType(rawValue: type?.rawValue ?? "")!,
      dateCreated: dateCreated?.date ?? Date(),
      attachments: attachments ?? [],
      assignedTo: assignedTo?.map { $0.map() } ?? []
    )
  }
}

extension Assignment {
  func map() -> AssignmentEntity {
    return AssignmentEntity(
      id: id.uuidString,
      iconName: iconName,
      title: title,
      description: description,
      type: AssigmnentTypeEntity(rawValue: type.rawValue),
      dateCreated: dateCreated.string,
      attachments: attachments,
      assignedTo: assignedTo.map { $0.map() }
    )
  }
}
