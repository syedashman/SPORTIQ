# DESIGN RULES

## PURPOSE

This document defines the visual rules of SPORTIQ.

All developers must follow these rules.

Never redesign approved UI.

---

# DESIGN SOURCE

Google Stitch Export

is

ONLY

Visual Reference.

Never convert Stitch HTML directly into Flutter.

Rebuild every screen natively.

---

# LAYOUT

Use

8px Grid System

Allowed spacing

8

16

24

32

40

48

64

No random spacing.

---

# SAFE AREA

Always respect

Status Bar

Notch

Dynamic Island

Home Indicator

Bottom Insets

No UI element should touch screen edges.

---

# SCROLLING

Allowed

Vertical Scroll

Not Allowed

Horizontal Scroll

Exceptions

Only image carousels if introduced later.

Tabs

Filters

Tables

must NEVER require horizontal scrolling.

---

# COMPONENTS

Everything must be reusable.

Never duplicate widgets.

Create reusable

Buttons

Cards

Inputs

Dialogs

Bottom Sheets

Tables

Badges

Navigation

Tabs

Stat Cards

Timeline Cards

Player Cards

Tournament Cards

---

# TYPOGRAPHY

Use one typography system.

Never change font sizes randomly.

Consistent

Headings

Subheadings

Body

Caption

Button Text

No italic headings.

No inconsistent font weights.

---

# COLORS

Use SPORTIQ Design System only.

Dark Theme

Primary Accent

Electric Green

Background

Dark Charcoal

Never invent new colors.

---

# BUTTONS

Primary

Filled

Secondary

Outlined

Danger

Red

Success

Green

Disabled

Grey

Loading

Spinner

All buttons must have

Pressed

Focused

Disabled

Loading

States.

---

# INPUTS

Every input must support

Focused

Disabled

Error

Helper Text

Validation

Password Toggle

---

# TABLES

Tables

Standings

Scorecards

Rankings

must

Auto Fit

Responsive

No horizontal scrolling.

---

# NAVIGATION

Bottom Navigation

Persistent

Top App Bar

Consistent

Back navigation

Predictable

---

# RESPONSIVE DESIGN

Support

Small Phones

Large Phones

Tablet support

Phase Two

Never hardcode widths.

---

# LOADING STATES

Every data screen must support

Loading

Skeleton

Empty

Offline

Retry

Error

These are reusable components.

Never create separate screens.

---

# DROPDOWNS

Never use ugly native dropdowns.

Always use

Custom Bottom Sheet

or

Custom Dropdown

---

# STICKY ACTIONS

Bottom buttons

must never overlap content.

Always leave bottom padding.

---

# ACCESSIBILITY

Minimum touch target

48dp

Readable text

High contrast

Proper labels

Keyboard support where applicable.

---

# PERFORMANCE

Use

Const Widgets

Lazy Lists

Caching

Image Optimization

Pagination

Avoid unnecessary rebuilds.

---

# CODE QUALITY

No duplicated UI.

No hardcoded strings.

No hardcoded colors.

No inline styles.

Reusable widgets only.

---

# MULTI SPORT RULE

Cricket

Football

Padel

must share

Design System

Navigation

Components

Spacing

Typography

Only

Rules

Statistics

Terminology

Scoring

change.

---

# FINAL RULE

Never redesign approved Stitch UI.

Improve implementation.

Never change UX without approval.