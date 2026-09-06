# SPORTIQ PROJECT DECISIONS

## PURPOSE

This document records permanent architectural and product decisions.

These decisions must not be changed unless explicitly approved.

---

# DESIGN

The Cricket UI is the master visual reference.

Football and Padel will reuse the same

• Design System

• Components

• Navigation

• Theme

• Layout

Only sport-specific rules, terminology, scoring and statistics will change.

---

# UI SOURCE

Google Stitch Export is the official UI reference.

It is NOT production Flutter code.

Every screen must be rebuilt natively.

---

# LIVE COMMENTARY

Live Commentary is removed.

It is replaced by

Match Events

Timeline

Live Score

---

# SCORECARDS

There will be ONE reusable Scorecard module.

Tabs

• Batting

• Bowling

• Partnerships

• Fall of Wickets

• Statistics

Do not build separate scorecard applications.

---

# USER ROLES

Supported roles

Admin

Organizer

Captain

Vice Captain

Player

Scorer

Official

Spectator

Commentator

---

# OPTIONAL ROLES

Officials

Optional

Scorer

Optional

Commentator

Optional

Users should be able to continue even if these roles are not assigned.

---

# TOURNAMENT

Tournament Creator

↓

Owner

Owner may invite another Organizer.

Owner always retains ownership unless ownership transfer is implemented in the future.

---

# MATCH EVENTS

Every match event must be stored.

Never overwrite score directly.

Score should always be generated from events.

This allows

Undo

Replay

Audit

Statistics

Offline Sync

Future AI Analysis

---

# MULTI SPORT

SPORTIQ supports

Cricket

Football

Padel

Shared modules

Authentication

Dashboard

Profile

Settings

Notifications

Search

Teams

Tournament

Brackets

Standings

Rankings

Sport-specific modules

Scoring

Statistics

Rules

Terminology

---

# MVP

Launch only with required features.

Future ideas must not delay release.

---

# POST LAUNCH

AI Analytics

Coach Dashboard

Referee Dashboard

Sponsors

Media

Transfers

Fantasy

Heatmaps

Ticketing

Video

Advanced Reports

All are Phase Two.

---

# DEVELOPMENT RULES

Never regenerate completed code.

Never redesign approved UI.

Never duplicate widgets.

Always build reusable components.

Always update

PROJECT_STATE.md

TODO.md

after every sprint.

---

# TESTING

Every sprint must leave the application

Compiling

Runnable

Stable

No unfinished broken code should be merged.

---

# FINAL RULE

If there is a conflict between a future prompt and this file,

this file takes priority

unless explicitly updated.