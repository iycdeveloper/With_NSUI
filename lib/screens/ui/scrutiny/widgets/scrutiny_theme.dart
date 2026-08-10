import 'package:flutter/material.dart';

/// Gen-Z chrome for the Scrutiny module, matching Membership / Nomination.
///
/// Tokens (keep in sync with the rest of the app):
///   page background  #F1F4FF -> #F8FAFF (top -> bottom)
///   hero gradient    #1356BF -> #5B2EC4 -> #2CC7E2 (topLeft -> bottomRight)
///   button gradient  #1356BF -> #2CC7E2
///   brand indigo     #1356BF   ink #1F2A44   hairline #E7EDF9
class ScrutinyTheme {
  ScrutinyTheme._();

  static const Color brand = Color(0xFF1356BF);
  static const Color ink = Color(0xFF1F2A44);
  static const Color hairline = Color(0xFFE7EDF9);
  static const Color accent = Color(0xFF2CC7E2);

  static const LinearGradient pageGradient = LinearGradient(
    begin: Alignment.topCenter,
    end: Alignment.bottomCenter,
    colors: [Color(0xFFF1F4FF), Color(0xFFF8FAFF)],
  );

  static const LinearGradient heroGradient = LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF1356BF), Color(0xFF5B2EC4), Color(0xFF2CC7E2)],
  );

  static const LinearGradient buttonGradient = LinearGradient(
    colors: [Color(0xFF1356BF), Color(0xFF2CC7E2)],
  );

  static List<BoxShadow> get cardShadow => [
        BoxShadow(
          color: Colors.black.withOpacity(0.06),
          blurRadius: 14,
          offset: const Offset(0, 6),
        ),
      ];

  /// White app bar with a bold indigo title, as used across the redesign.
  static PreferredSizeWidget appBar(BuildContext context, String title,
      {List<Widget>? actions, PreferredSizeWidget? bottom}) {
    return AppBar(
      backgroundColor: Colors.white,
      elevation: 0,
      surfaceTintColor: Colors.white,
      iconTheme: const IconThemeData(color: brand),
      title: Text(title,
          style: const TextStyle(
              color: brand, fontSize: 19, fontWeight: FontWeight.bold)),
      actions: actions,
      bottom: bottom,
    );
  }
}

/// Full-bleed gradient page background.
class ScrutinyPageBackground extends StatelessWidget {
  final Widget child;
  const ScrutinyPageBackground({Key? key, required this.child})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      height: double.infinity,
      decoration: const BoxDecoration(gradient: ScrutinyTheme.pageGradient),
      child: child,
    );
  }
}

/// Gradient hero card — icon chip + title + subtitle.
class ScrutinyHero extends StatelessWidget {
  final IconData icon;
  final String title;
  final String subtitle;
  const ScrutinyHero(
      {Key? key,
      required this.icon,
      required this.title,
      required this.subtitle})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.fromLTRB(16, 12, 16, 4),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        gradient: ScrutinyTheme.heroGradient,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: ScrutinyTheme.brand.withOpacity(0.30),
            blurRadius: 20,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.white.withOpacity(0.18),
              borderRadius: BorderRadius.circular(16),
            ),
            child: Icon(icon, color: Colors.white, size: 26),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(title,
                    style: const TextStyle(
                        color: Colors.white,
                        fontSize: 19,
                        fontWeight: FontWeight.bold)),
                const SizedBox(height: 3),
                Text(subtitle,
                    style: const TextStyle(
                        color: Colors.white70, fontSize: 12.5)),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

/// Labelled section divider: tinted icon chip + bold title + hairline rule.
class ScrutinySectionHeader extends StatelessWidget {
  final IconData icon;
  final String title;
  const ScrutinySectionHeader(
      {Key? key, required this.icon, required this.title})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(18, 20, 18, 2),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(7),
            decoration: BoxDecoration(
              color: ScrutinyTheme.brand.withOpacity(0.10),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Icon(icon, size: 16, color: ScrutinyTheme.brand),
          ),
          const SizedBox(width: 10),
          Text(title,
              style: const TextStyle(
                  fontSize: 15,
                  fontWeight: FontWeight.bold,
                  color: ScrutinyTheme.ink)),
          const SizedBox(width: 12),
          const Expanded(child: Divider(color: ScrutinyTheme.hairline)),
        ],
      ),
    );
  }
}

/// App-gradient CTA.
class ScrutinyGradientButton extends StatelessWidget {
  final String label;
  final VoidCallback onTap;
  final EdgeInsetsGeometry margin;
  const ScrutinyGradientButton(
      {Key? key,
      required this.label,
      required this.onTap,
      this.margin = const EdgeInsets.all(5)})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 54,
        margin: margin,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          gradient: ScrutinyTheme.buttonGradient,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: ScrutinyTheme.brand.withOpacity(0.35),
              blurRadius: 16,
              offset: const Offset(0, 8),
            ),
          ],
        ),
        child: Text(label,
            style: const TextStyle(
                color: Colors.white,
                fontSize: 16,
                fontWeight: FontWeight.bold)),
      ),
    );
  }
}

/// White rounded card used by the batch / member lists.
class ScrutinyCard extends StatelessWidget {
  final Widget child;
  final VoidCallback? onTap;
  const ScrutinyCard({Key? key, required this.child, this.onTap})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(18),
          border: Border.all(color: ScrutinyTheme.hairline),
          boxShadow: ScrutinyTheme.cardShadow,
        ),
        child: child,
      ),
    );
  }
}

/// Small status pill, e.g. "3 on hold".
class ScrutinyChip extends StatelessWidget {
  final String label;
  final Color color;
  final IconData? icon;
  const ScrutinyChip(
      {Key? key, required this.label, required this.color, this.icon})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
      decoration: BoxDecoration(
        color: color.withOpacity(0.10),
        borderRadius: BorderRadius.circular(20),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (icon != null) ...[
            Icon(icon, size: 12, color: color),
            const SizedBox(width: 4),
          ],

          /// Flexible + ellipsis so a long status never overflows its row.
          Flexible(
            child: Text(label,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(
                    color: color, fontSize: 11.5, fontWeight: FontWeight.w700)),
          ),
        ],
      ),
    );
  }
}
