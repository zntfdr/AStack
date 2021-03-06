import SwiftUI

#if swift(>=5.3)

/// Adaptive `LazyHStack`.
///
/// A view that arranges its children in a line, creating items only as needed.
/// The line grows horizontally by default, and switches to vertical based on
/// the observed environment values:
/// - if `.sizeCategory` is observed, the switch happens when its value is among
///   the accessibility ones.
/// - if `.sizeClass` is observed, the switch happens when the
///   `horizontalSizeClass` value is `.compact`.
/// - if both are observed, the switch happens when at least one of the above is
///   true.
/// - if neither is observed, the switch never happens.
@available(macOS 11, iOS 14, watchOS 7, tvOS 14, *)
public struct LazyAHStack<Content: View>: View {
  @Environment(\.sizeCategory) var sizeCategory: ContentSizeCategory
  @Environment(\.horizontalSizeClass) var horizontalSizeClass

  /// What the view observes to decide when to adapt.
  let observing: ObservingOptions

  /// `LazyHStack` alignment.
  let horizontalStackAlignment: VerticalAlignment

  /// `LazyHStack` spacing.
  let horizontalStackSpacing: CGFloat?

  /// `LazyHStack` pinned views.
  let horizontalStackPinnedViews: PinnedScrollableViews

  /// `LazyVStack` alignment.
  let verticalStackAlignment: HorizontalAlignment

  /// `LazyVStack` spacing.
  let verticalStackSpacing: CGFloat?

  /// `LazyVStack` pinned views.
  let verticalStackPinnedViews: PinnedScrollableViews

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
  ///   - horizontalStackPinnedViews: The kinds of child views that will be
  ///     pinned.
  ///   - verticalStackAlignment: The guide that will have the same horizontal
  ///     screen coordinate for all children.
  ///   - verticalStackSpacing: The distance between adjacent children, or `nil`
  ///     if the stack should choose a default distance for each pair of
  ///     children.
  ///   - verticalStackPinnedViews: The kinds of child views that will be
  ///     pinned.
  ///   - content: A view builder that creates the content of this stack.
  public init(
    observing: ObservingOptions = .sizeCategory,
    hAlignment horizontalStackAlignment: VerticalAlignment = .center,
    hSpacing horizontalStackSpacing: CGFloat? = nil,
    hPinnedViews horizontalStackPinnedViews: PinnedScrollableViews = .init(),
    vAlignment verticalStackAlignment: HorizontalAlignment = .center,
    vSpacing verticalStackSpacing: CGFloat? = nil,
    vPinnedViews verticalStackPinnedViews: PinnedScrollableViews = .init(),
    @ViewBuilder content: () -> Content
  ) {
    self.observing = observing
    self.horizontalStackAlignment = horizontalStackAlignment
    self.horizontalStackSpacing = horizontalStackSpacing
    self.horizontalStackPinnedViews = horizontalStackPinnedViews
    self.verticalStackAlignment = verticalStackAlignment
    self.verticalStackSpacing = verticalStackSpacing
    self.verticalStackPinnedViews = verticalStackPinnedViews
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
      LazyVStack(
        alignment: verticalStackAlignment,
        spacing: verticalStackSpacing,
        pinnedViews: verticalStackPinnedViews
      ) {
        content
      }
    } else {
      LazyHStack(
        alignment: horizontalStackAlignment,
        spacing: horizontalStackSpacing,
        pinnedViews: horizontalStackPinnedViews
      ) {
        content
      }
    }
  }
}

#endif
