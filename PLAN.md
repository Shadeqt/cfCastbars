# cfCastbars - Implementation Plan

## Status
- [x] Pet feature + GUI
- [ ] Party feature + GUI
- [ ] Nameplate feature + GUI
- [x] Player feature + GUI
- [ ] Target feature + GUI

## Prerequisites
- [x] Split Test.lua into per-domain toggles (TestPlayer, TestTarget, TestParty, TestPet, TestNameplate)
- [x] /cbt still toggles all

## Build order (GUI layout: Player|Target on top, Party|Pet below)

### 1. Player (done)
- [x] UpdatePlayer with all DB keys
- [x] SetPoint hook for Blizzard repositioning
- [x] Spark/border/icon resize on height change
- [x] GUI with sliders, checkboxes, BindChildren, reset

### 2. Target
- [ ] Add DB keys to UpdateTarget (modifies TargetFrameSpellBar)
- [ ] Apply scale, x, y, width, height to bar
- [ ] Apply icon, timer, text, border toggles + offsets
- [ ] Update spark/border on size change
- [ ] GUI: checkboxes + sliders, test checkbox, BindChildren, reset

### 3. Party
- [ ] Add DB keys to UpdateParty
- [ ] Apply scale, x, y, width, height offsets
- [ ] Apply icon, timer, text, border toggles + offsets
- [ ] Hook SetPoint for repositioning (Blizzard resets)
- [ ] GUI: checkboxes + sliders, test checkbox, BindChildren, reset

### 4. Pet (done)

### 5. Nameplate
- [ ] Add DB keys to UpdateNameplate
- [ ] Apply scale, x, y, width, height to bar
- [ ] Apply icon, timer, text, border toggles + offsets
- [ ] Update spark/border on size change
- [ ] GUI: checkboxes + sliders, test checkbox, BindChildren, reset

## GUI Layout (single scrollable panel)
```
Player          | Target
  checkboxes    |   checkboxes
  sliders       |   sliders
────────────────|────────────────
Party           | Pet
  checkboxes    |   checkboxes
  sliders       |   sliders
────────────────|────────────────
Nameplate
  checkboxes
  sliders
```
- Horizontal separators between rows
- Vertical separator between columns
- Per-section test checkbox (no global test)
- Per-section reset button
