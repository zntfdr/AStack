import SwiftUI

/// Adaptive `HStack`.
///
/// A view that arranges its children in a horizontal line by default, and
/// switches to vertical based on the observed environment values:
/// - if `.sizeCategory` is observed, the switch happens when its value is among
///   the accessibility ones.
/// - if `.sizeClass` is observed, the switch happens when the
///   `horizontalSizeClass` value is `.compact`.
/// - if both are observed, the switch happens when at least one of the above is
///   true.
/// - if neither is observed, the switch never happens.
public struct AHStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  /// What the view observes to decide when to adapt.
  let observing: ObservingOptions

  /// `HStack` alignment.
  let horizontalStackAlignment: VerticalAlignment

  /// `HStack` spacing.
  let horizontalStackSpacing: CGFloat?

  /// `VStack` alignment.
  let verticalStackAlignment: HorizontalAlignment

  /// `VStack` spacing.
  let verticalStackSpacing: CGFloat?

  /// The content of this stack.
  let content: Content

  /// Creates an instance with the given horizontal and vertical spacing and
  /// axes alignment.
  ///
  /// - Parameters:
  ///   - observing: The @Environment values used to determine when the view
  ///     should adapt. Currently `sizeCategory` and/or `sizeClass`.
  ///   - horizontalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - horizontalStackSpacing: The distance between adjacent children, or
  ///     `nil` if the stack should choose a default distance for each pair of
  ///     children.
  ///   - verticalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - verticalStackSpacing: The distance between adjacent children, or `nil`
  ///     if the stack should choose a default distance for each pair of
  ///     children.
  ///   - content: A `View` that describes the purpose of the instance.
  public init(
    observing: ObservingOptions = .sizeCategory,
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    @ViewBuilder content: () -> Content
  ) {
    self.observing = observing
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.content = content()
  }

  /// Whether this stack should switch axis (a.k.a 'adapt') or not.
  var shouldAdapt: Bool {
    observing.contains(.sizeCategory) && sizeCategory.isAccessibility ||
    observing.contains(.sizeClass) && horizontalSizeClass == .compact
  }

  @ViewBuilder
  public var body: some View {
    if shouldAdapt {
      VStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing
      ) {
        content
      }
    } else {
      HStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing
      ) {
        content
      }
    }
  }
}
