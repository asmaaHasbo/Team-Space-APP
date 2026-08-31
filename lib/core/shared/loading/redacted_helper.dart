import 'package:flutter/material.dart';
import 'package:redacted/redacted.dart';

/// `redacted` only walks a fixed set of widget types and hands anything else
/// back untouched, so one wrapper it does not know — a `Flexible`, a
/// `GestureDetector` — ends the walk and every text under it keeps painting.
///
/// This walker owns those wrappers and recurses through itself, handing over
/// to the package only the leaves it draws well: text, icons, images and
/// boxes. Whatever the package takes from there on, it walks its own way.
extension RedactedHelper on Widget {
  Widget redactedHelper({
    required BuildContext context,
    required bool isLoading,
  }) {
    if (!isLoading) return this;

    Widget walk(Widget child) =>
        child.redactedHelper(context: context, isLoading: true);
  
    Widget? walkOrNull(Widget? child) => child == null ? null : walk(child);

    final self = this;

    // The leaves the package turns into the grey boxes.
    if (self is Text || self is Icon || self is Image || self is Container) {
      return self.redacted(context: context, redact: true);
    }

    return switch (self) {
      // Nothing is tappable while loading, so the gesture layer just goes.
      final GestureDetector detector => walk(
        detector.child ?? const SizedBox.shrink(),
      ),
      final InkWell inkWell => walk(inkWell.child ?? const SizedBox.shrink()),
      // `Expanded` comes first — it is a `Flexible` itself.
      final Expanded expanded => Expanded(
        flex: expanded.flex,
        child: walk(expanded.child),
      ),
      final Flexible flexible => Flexible(
        flex: flexible.flex,
        fit: flexible.fit,
        child: walk(flexible.child),
      ),
      final Row row => Row(
        mainAxisAlignment: row.mainAxisAlignment,
        mainAxisSize: row.mainAxisSize,
        crossAxisAlignment: row.crossAxisAlignment,
        textDirection: row.textDirection,
        verticalDirection: row.verticalDirection,
        textBaseline: row.textBaseline,
        spacing: row.spacing,
        children: row.children.map(walk).toList(),
      ),
      final Column column => Column(
        mainAxisAlignment: column.mainAxisAlignment,
        mainAxisSize: column.mainAxisSize,
        crossAxisAlignment: column.crossAxisAlignment,
        textDirection: column.textDirection,
        verticalDirection: column.verticalDirection,
        textBaseline: column.textBaseline,
        spacing: column.spacing,
        children: column.children.map(walk).toList(),
      ),
      final Padding padding => Padding(
        padding: padding.padding,
        child: walkOrNull(padding.child),
      ),
      final SizedBox sizedBox => SizedBox(
        width: sizedBox.width,
        height: sizedBox.height,
        child: walkOrNull(sizedBox.child),
      ),
      // `Center` is an `Align`, so this one case carries both.
      final Align align => Align(
        alignment: align.alignment,
        widthFactor: align.widthFactor,
        heightFactor: align.heightFactor,
        child: walkOrNull(align.child),
      ),
      final ColoredBox coloredBox => ColoredBox(
        color: coloredBox.color,
        child: walkOrNull(coloredBox.child),
      ),
      // Our own widgets: build them and keep walking what they returned.
      final StatelessWidget stateless => walk(stateless.build(context)),
      _ => self.redacted(context: context, redact: true),
    };
  }
}
