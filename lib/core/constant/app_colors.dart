import 'package:flutter/material.dart';

/// ================================================
/// :art: APP COLOR PALETTE - LIGHT & DARK THEMES
/// Organized & Complete for easy reference
/// ================================================
/// :large_green_square: BACKGROUND
const Color backgroundMainLight = Color(0xFFEAEAEA);
const Color backgroundMainDark = Color(0xFF111111);
const Color backgroundWhiteLight = Color(0xFFFFFFFF);
const Color backgroundWhiteDark = Color(0xFF000000);

/// :large_red_square: PRIMARY & SECONDARY
const Color primaryLight = Color(0xFF006D92);
const Color primaryDark = Color(0xFF006D92);
const Color secondaryLight = Color(0xFFD37B7B);
const Color secondaryDark = Color(0xFF705353);

/// :receipt: TYPOGRAPHY
const Color typographyMainLight = Color(0xFF006D92);
const Color typographyMainDark = Color(0xFF006D92);
const Color headingLight = Color(0xFF000000);
const Color headingDark = Color(0xFFFFFFFF);
const Color paragraphLight = Color(0xFF474747);
const Color paragraphDark = Color(0xFFCFCFCF);
const Color textWhiteLight = Color(0xFFFFFFFF);
const Color textWhiteDark = Color(0xFFFFFFFF);

/// :radio_button: BUTTONS
// ─ Primary
const Color buttonPrimaryBgLight = Color(0xFF006D92);
const Color buttonPrimaryBgDark = Color(0xFF006D92);
const Color buttonPrimaryTextLight = Color(0xFFFFFFFF);
const Color buttonPrimaryTextDark = Color(0xFFFFFFFF);
const Color buttonPrimaryBgWhiteLight = Color(0xFFFFFFFF);
const Color buttonPrimaryBgWhiteDark = Color(0xFF1D1D1D);
// ─ Secondary
const Color buttonSecondaryTextLight = Color(0xFF717171);
const Color buttonSecondaryTextDark = Color(0xFFEAEAEA);
const Color buttonSecondaryBorderLight = Color(0xFFA4A4A4);
const Color buttonSecondaryBorderDark = Color(0xFFFFFFFF);

/// :compass: NAVBAR
const Color navbarBgLight = Color(0xFFFFFFFF);
const Color navbarBgDark = Color(0xFF000000);
const Color navbarTextLight = Color(0xFF474747);
const Color navbarTextDark = Color(0xFFFFFFFF);
const Color navbarStrokeLight = Color(0xFFC1C1C1);
const Color navbarStrokeDark = Color(0xFFAFAFAF);

/// :jigsaw: ICONS
const Color iconDefaultLight = Color(0xFF006D92);
const Color iconDefaultDark = Color(0xFF006D92);
const Color iconWhiteLight = Color(0xFFFFFFFF);
const Color iconWhiteDark = Color(0xFFFFFFFF);
const Color iconGrayLight = Color(0xFF707070);
const Color iconGrayDark = Color(0xFFEBEBEB);

/// :straight_ruler: STROKES / BORDERS
const Color strokeGrayLight = Color(0xFF9B9B9B);
const Color strokeGrayDark = Color(0xFF9B9B9B);
const Color strokeRedLight = Color(0xFF006D92);
const Color strokeRedDark = Color(0xFF006D92);
const Color strokeBlackToWhiteLight = Color(0xFF000000);
const Color strokeBlackToWhiteDark = Color(0xFFFFFFFF);

/// :fog: EFFECTS / SHADOWS
const Color shadowLight = Color(0x3F000000); // 25% Black
const Color shadowDark = Color(0x1AFFFFFF); // 10% White
/// :small_orange_diamond: ACCENT & SCAFFOLD
const Color accentColor = Color(0xFFBA1B1B);
const Color scaffoldLight = Color(0xFF419BBA);
const Color scaffoldDark = Color(0xFF02A1D6);

/// ================================================
/// :small_blue_diamond: DYNAMIC COLOR FUNCTIONS (AUTO BASED ON THEME)
/// ================================================
Color backgroundColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? backgroundMainLight
        : backgroundMainDark;

Color backgroundWhiteColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? backgroundWhiteLight
        : backgroundWhiteDark;

Color primaryColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? primaryLight
        : primaryDark;

Color secondaryColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? secondaryLight
        : secondaryDark;

Color typographyMainColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? typographyMainLight
        : typographyMainDark;


Color headingColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? headingLight
        : headingDark;

Color paragraphColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? paragraphLight
        : paragraphDark;

Color buttonPrimaryBgColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? buttonPrimaryBgLight
        : buttonPrimaryBgDark;

Color buttonPrimaryTextColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? buttonPrimaryTextLight
        : buttonPrimaryTextDark;

Color buttonSecondaryTextColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? buttonSecondaryTextLight
        : buttonSecondaryTextDark;

Color buttonSecondaryBorderColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? buttonSecondaryBorderLight
        : buttonSecondaryBorderDark;

Color navbarBgColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? navbarBgLight
        : navbarBgDark;

Color navbarTextColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? navbarTextLight
        : navbarTextDark;

Color navbarStrokeColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? navbarStrokeLight
        : navbarStrokeDark;

Color iconDefaultColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? iconDefaultLight
        : iconDefaultDark;

Color iconGrayColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? iconGrayLight
        : iconGrayDark;

Color strokeGrayColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? strokeGrayLight
        : strokeGrayDark;

Color strokeRedColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? strokeRedLight
        : strokeRedDark;

Color shadowColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light ? shadowLight : shadowDark;

Color scaffoldBackgroundColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? scaffoldLight
        : scaffoldDark;

Color buttonBgWhiteColor(BuildContext context) =>
    Theme.of(context).brightness == Brightness.light
        ? buttonPrimaryBgWhiteLight
        : buttonPrimaryBgWhiteDark;
