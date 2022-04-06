//
//  ViewStateModifier.swift
//  Parentify
//
//  Created by Uwais Alqadri on 4/6/22.
//

import SwiftUI

struct ViewStateModifier<Data>: ViewModifier {

  var data: Published<ViewState<Data>>.Publisher
  var onSuccess: ((Data) -> Void)? = nil
  var onLoading: (() -> Void)? = nil
  var onEmpty: (() -> Void)? = nil
  var onError: ((Error) -> Void)? = nil

  func body(content: Content) -> some View {
    content
      .onReceive(data) { state in
        switch state {
        case .success(let data):
          onSuccess?(data)
        case .loading:
          onLoading?()
        case .empty:
          onEmpty?()
        case .error(let error):
          onError?(error)
        default:
          break
        }
      }
  }
}

extension View {
  func onViewStatable<Data>(
    data: Published<ViewState<Data>>.Publisher,
    onSuccess: ((Data) -> Void)? = nil,
    onLoading: (() -> Void)? = nil,
    onEmpty: (() -> Void)? = nil,
    onError: ((Error) -> Void)? = nil
  ) -> some View {
    modifier(ViewStateModifier(data: data, onSuccess: onSuccess, onLoading: onLoading, onEmpty: onEmpty, onError: onError))
  }
}
