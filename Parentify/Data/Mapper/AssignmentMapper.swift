//
//  AssignmentMapper.swift
//  Parentify
//
//  Created by Uwais Alqadri on 3/8/22.
//

import SwiftUI

extension AssigmnentType {
  func map() -> AssigmnentTypeEntity {
    return AssigmnentTypeEntity(rawValue: self.rawValue)!
  }
}

extension AssignmentEntity {
  func map() -> Assignment {
    return Assignment(
      id: id.orEmpty(),
      iconName: iconName.orEmpty(),
      title: title.orEmpty(),
      description: description.orEmpty(),
      type: AssigmnentType(rawValue: type?.rawValue ?? "")!,
      dateCreated: dateCreated?.toDate() ?? Date(),
      attachments: attachments ?? [],
      assignedTo: assignedTo?.map { $0.map() } ?? [],
      isDone: isDone ?? false
    )
  }
}

extension Assignment {
  func map() -> AssignmentEntity {
    return AssignmentEntity(
      id: id,
      iconName: iconName,
      title: title,
      description: description,
      type: AssigmnentTypeEntity(rawValue: type.rawValue),
      dateCreated: String(dateCreated.timeIntervalSince1970),
      attachments: attachments,
      assignedTo: assignedTo.map { $0.map() },
      isDone: isDone
    )
  }
}

extension Array where Element == Assignment {
  func filterAssignedAssignments(currentUser: User) -> [Assignment] {
    return self
      .filter { $0.assignedTo.filter { $0.userId == currentUser.userId }.count > 0 }
      .filter { $0.isDone == false }
  }
}
