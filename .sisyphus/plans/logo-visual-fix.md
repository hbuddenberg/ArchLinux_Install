# Arch Linux Logo and Menu Visual Fix Plan

## TL;DR

Fix the visual appearance of the Arch Linux logo and menu in the TUI application to ensure:
- Logo is centered with 80-character width
- Mountain in cyan color, text in white color
- Proper separation between logo and menu
- Menu has appropriate styling with different background color

## Context

### Original Request
The user wants to fix the visual appearance of the Arch Linux logo and menu in the TUI application, ensuring:
- Logo is centered with 80-character width
- Correct colors (mountain in cyan, text in white)
- Proper separation between logo and menu
- Menu has appropriate styling

### Current State
- CSS variable errors fixed in both `styles.tcss` and `logo.py`
- Application starts without CSS errors
- Logo is visible but has visual issues with centering, colors, and sizing
- Menu needs styling adjustments

### Relevant Files
```
/workspace/archinstall_tui/src/archinstall_tui/
├── assets/logo.txt           # Original Arch Linux logo (19 lines)
├── tui/widgets/logo.py       # Logo widget with DEFAULT_CSS
├── tui/styles.tcss           # Main CSS styles
└── tui/screens/main_menu.py   # Menu screen implementation
```

## Work Objectives

### Core Objective
Fix the visual appearance of the Arch Linux logo and menu to match the expected design:
- Centered logo at 80 columns width
- Mountain in cyan color, text in white color
- Different background colors for logo and menu
- Properly styled menu with centered buttons

### Concrete Deliverables
- Logo with correct colors and centering
- Menu with proper styling and background
- Consistent visual appearance throughout the TUI

### Definition of Done
- Logo displays centered at 80 characters width
- Mountain elements are cyan colored
- Text elements are white colored
- Menu has appropriate styling with different background
- All visual elements match the expected appearance

### Must Have
- Logo centered and 80 characters wide
- Mountain in cyan color
- Text in white color
- Different background colors for logo and menu
- Menu buttons properly styled and centered

### Must NOT Have
- Bordered elements (as requested by user)
- Menu text that doesn't serve a function
- Inconsistent styling between logo and menu

## Verification Strategy

### Test Decision
- **Infrastructure exists**: YES (Textual CSS)
- **Automated tests**: NO (visual changes)
- **Agent-Executed QA**: YES (Playwright for UI verification)

### QA Policy
Every task will include agent-executed QA scenarios using Playwright to verify the visual appearance.

## Execution Strategy

### Parallel Execution Waves

Wave 1 (Logo Visual Fixes - Foundation):
├── Task 1: Update logo widget for color styling
├── Task 2: Apply correct colors to logo (mountain cyan, text white)
├── Task 3: Ensure 80-character width and centering
└── Task 4: Verify logo visual appearance

Wave 2 (Menu Styling - Integration):
├── Task 5: Adjust menu background colors
├── Task 6: Style menu buttons and text
├── Task 7: Ensure menu centering and separation
└── Task 8: Verify menu visual appearance

Wave 3 (Final Integration):
├── Task 9: Verify overall visual consistency
├── Task 10: Cross-browser/terminal compatibility check
└── Task 11: Final visual approval

## TODOs

### Task 1: Update logo widget for color styling
**What to do**:
- Modify `logo.py` to add color classes for mountain and text elements
- Update DEFAULT_CSS to include color styling
- Ensure logo maintains 80-character width

**Must NOT do**:
- Change the original logo content from `assets/logo.txt`
- Add borders or unnecessary styling
- Alter the menu structure

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (to ensure proper CSS class application)

**Parallelization**:
- **Can Run In Parallel**: NO (depends on logo structure)
- **Blocks**: Task 2, Task 3, Task 4
- **Blocked By**: None

**References**:
- `src/archinstall_tui/tui/widgets/logo.py:11-19` - Current DEFAULT_CSS that needs color updates
- `src/archinstall_tui/assets/logo.txt` - Original logo content for reference

**Acceptance Criteria**:
- Logo widget compiles without errors
- DEFAULT_CSS includes mountain and text color classes
- Logo displays without CSS errors

**QA Scenarios**:
```
Scenario: Logo color classes applied
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Verify ArchLogo widget exists
    3. Check for .mountain and .text CSS classes in logo
  Expected Result: Both CSS classes are present and applied
  Evidence: .sisyphus/evidence/task-1-logo-color-classes.png
```

### Task 2: Apply correct colors to logo (mountain cyan, text white)
**What to do**:
- Update logo rendering to apply color classes to mountain and text elements
- Ensure mountain elements use cyan color
- Ensure text elements use white color
- Maintain 80-character width constraint

**Must NOT do**:
- Change the original logo ASCII art
- Add borders or unnecessary styling
- Alter the menu structure

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (to ensure proper color application)

**Parallelization**:
- **Can Run In Parallel**: NO (depends on Task 1)
- **Blocks**: Task 3, Task 4
- **Blocked By**: Task 1

**References**:
- `src/archinstall_tui/tui/widgets/logo.py:27-38` - Logo rendering logic
- `src/archinstall_tui/assets/logo.txt` - Original logo content

**Acceptance Criteria**:
- Logo displays with mountain in cyan color
- Logo displays with text in white color
- No CSS errors in console

**QA Scenarios**:
```
Scenario: Logo colors applied correctly
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Inspect logo mountain elements for cyan color
    3. Inspect logo text elements for white color
  Expected Result: Mountain elements are cyan, text elements are white
  Evidence: .sisyphus/evidence/task-2-logo-colors.png
```

### Task 3: Ensure 80-character width and centering
**What to do**:
- Verify logo maintains 80-character width from original
- Ensure proper centering in container
- Check for any width discrepancies
- Adjust CSS if needed for proper centering

**Must NOT do**:
- Change the original logo content
- Alter the menu structure
- Remove centering functionality

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (to verify width and centering)

**Parallelization**:
- **Can Run In Parallel**: NO (depends on Task 2)
- **Blocks**: Task 4
- **Blocked By**: Task 2

**References**:
- `src/archinstall_tui/assets/logo.txt` - Original logo width reference
- `src/archinstall_tui/tui/widgets/logo.py:11-19` - Current CSS for width and centering

**Acceptance Criteria**:
- Logo displays at 80 characters width
- Logo is properly centered in container
- No width or alignment issues

**QA Scenarios**:
```
Scenario: Logo width and centering
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Measure logo width (should be 80 characters)
    3. Verify logo is centered in container
  Expected Result: Logo width is 80 characters, properly centered
  Evidence: .sisyphus/evidence/task-3-logo-width.png
```

### Task 4: Verify logo visual appearance
**What to do**:
- Perform comprehensive visual inspection of logo
- Compare with expected appearance
- Document any discrepancies
- Apply final adjustments if needed

**Must NOT do**:
- Change the original logo content
- Alter the menu structure
- Skip visual verification steps

**Recommended Agent Profile**:
- **Category**: unspecified-high
- **Skills**: visual-engineering (for visual inspection)

**Parallelization**:
- **Can Run In Parallel**: NO (final verification)
- **Blocks**: Task 5 (menu styling)
- **Blocked By**: Task 3

**References**:
- `src/archinstall_tui/assets/logo.txt` - Original logo reference
- Previous task outputs for verification

**Acceptance Criteria**:
- Logo matches expected visual appearance
- All color and centering requirements met
- No visual discrepancies

**QA Scenarios**:
```
Scenario: Final logo visual inspection
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Perform detailed visual inspection of logo
    3. Compare with expected appearance
    4. Document any issues
  Expected Result: Logo matches expected visual appearance
  Evidence: .sisyphus/evidence/task-4-logo-final.png
```

### Task 5: Adjust menu background colors
**What to do**:
- Update menu background to different color from logo
- Ensure proper visual separation
- Maintain menu functionality
- Apply consistent styling

**Must NOT do**:
- Change menu structure or functionality
- Remove menu elements
- Alter logo styling

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (for CSS styling)

**Parallelization**:
- **Can Run In Parallel**: YES (independent of logo)
- **Blocks**: Task 6, Task 7, Task 8
- **Blocked By**: None

**References**:
- `src/archinstall_tui/tui/styles.tcss:5-10` - Current menu container styling
- `src/archinstall_tui/tui/screens/main_menu.py:22-33` - Menu structure

**Acceptance Criteria**:
- Menu has different background color from logo
- Proper visual separation maintained
- No CSS errors

**QA Scenarios**:
```
Scenario: Menu background color
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Inspect menu background color
    3. Compare with logo background color
  Expected Result: Menu background differs from logo background
  Evidence: .sisyphus/evidence/task-5-menu-background.png
```

### Task 6: Style menu buttons and text
**What to do**:
- Apply proper styling to menu buttons
- Ensure text styling matches requirements
- Maintain button functionality
- Apply consistent visual design

**Must NOT do**:
- Change button functionality
- Remove menu buttons
- Alter logo styling

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (for button styling)

**Parallelization**:
- **Can Run In Parallel**: NO (depends on Task 5)
- **Blocks**: Task 7, Task 8
- **Blocked By**: Task 5

**References**:
- `src/archinstall_tui/tui/styles.tcss:19-29` - Current button styling
- `src/archinstall_tui/tui/screens/main_menu.py:26-33` - Menu buttons

**Acceptance Criteria**:
- Menu buttons have proper styling
- Text styling matches requirements
- Buttons function correctly

**QA Scenarios**:
```
Scenario: Menu button styling
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Inspect menu button styling
    3. Verify button text appearance
  Expected Result: Menu buttons have proper styling and text
  Evidence: .sisyphus/evidence/task-6-menu-buttons.png
```

### Task 7: Ensure menu centering and separation
**What to do**:
- Verify menu is properly centered
- Ensure proper separation from logo
- Maintain visual hierarchy
- Apply consistent spacing

**Must NOT do**:
- Change menu structure
- Alter logo positioning
- Remove visual separation

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (for layout and spacing)

**Parallelization**:
- **Can Run In Parallel**: NO (depends on Task 6)
- **Blocks**: Task 8
- **Blocked By**: Task 6

**References**:
- `src/archinstall_tui/tui/styles.tcss:5-10` - Menu container styling
- `src/archinstall_tui/tui/screens/main_menu.py:22-33` - Menu layout

**Acceptance Criteria**:
- Menu is properly centered
- Proper separation from logo maintained
- Consistent visual hierarchy

**QA Scenarios**:
```
Scenario: Menu centering and separation
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Verify menu centering
    3. Check separation from logo
  Expected Result: Menu is centered with proper separation from logo
  Evidence: .sisyphus/evidence/task-7-menu-layout.png
```

### Task 8: Verify menu visual appearance
**What to do**:
- Perform comprehensive visual inspection of menu
- Compare with expected appearance
- Document any discrepancies
- Apply final adjustments if needed

**Must NOT do**:
- Change menu structure or functionality
- Skip visual verification steps
- Alter logo styling

**Recommended Agent Profile**:
- **Category**: unspecified-high
- **Skills**: visual-engineering (for visual inspection)

**Parallelization**:
- **Can Run In Parallel**: NO (final verification)
- **Blocks**: Task 9 (final integration)
- **Blocked By**: Task 7

**References**:
- Previous task outputs for verification
- Expected menu appearance requirements

**Acceptance Criteria**:
- Menu matches expected visual appearance
- All styling requirements met
- No visual discrepancies

**QA Scenarios**:
```
Scenario: Final menu visual inspection
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Perform detailed visual inspection of menu
    3. Compare with expected appearance
    4. Document any issues
  Expected Result: Menu matches expected visual appearance
  Evidence: .sisyphus/evidence/task-8-menu-final.png
```

### Task 9: Verify overall visual consistency
**What to do**:
- Perform comprehensive visual inspection of entire screen
- Ensure consistency between logo and menu
- Document any discrepancies
- Apply final adjustments if needed

**Must NOT do**:
- Change any visual elements
- Skip visual verification steps
- Alter the overall design

**Recommended Agent Profile**:
- **Category**: unspecified-high
- **Skills**: visual-engineering (for visual inspection)

**Parallelization**:
- **Can Run In Parallel**: NO (final integration)
- **Blocks**: Task 10, Task 11
- **Blocked By**: Task 4, Task 8

**References**:
- All previous task outputs
- Expected overall visual appearance

**Acceptance Criteria**:
- Overall visual consistency maintained
- All elements match expected appearance
- No visual discrepancies

**QA Scenarios**:
```
Scenario: Overall visual consistency
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Perform comprehensive visual inspection
    3. Verify consistency between logo and menu
  Expected Result: Overall visual consistency maintained
  Evidence: .sisyphus/evidence/task-9-overall-consistency.png
```

### Task 10: Cross-browser/terminal compatibility check
**What to do**:
- Test visual appearance in different terminal environments
- Ensure consistent display across platforms
- Document any compatibility issues
- Apply adjustments if needed

**Must NOT do**:
- Change visual design for compatibility
- Skip compatibility testing
- Alter core visual elements

**Recommended Agent Profile**:
- **Category**: unspecified-high
- **Skills**: visual-engineering (for compatibility testing)

**Parallelization**:
- **Can Run In Parallel**: YES (independent verification)
- **Blocks**: Task 11
- **Blocked By**: Task 9

**References**:
- All previous task outputs
- Terminal compatibility requirements

**Acceptance Criteria**:
- Visual appearance consistent across terminals
- No major compatibility issues
- All elements display correctly

**QA Scenarios**:
```
Scenario: Terminal compatibility
  Tool: Playwright (multiple terminal emulators)
  Preconditions: TUI application running
  Steps:
    1. Test in different terminal environments
    2. Verify visual consistency
    3. Document any issues
  Expected Result: Visual appearance consistent across terminals
  Evidence: .sisyphus/evidence/task-10-compatibility.png
```

### Task 11: Final visual approval
**What to do**:
- Obtain final visual approval
- Document approved state
- Mark task as complete
- Prepare for deployment

**Must NOT do**:
- Make unapproved changes
- Skip final approval
- Alter approved visual design

**Recommended Agent Profile**:
- **Category**: unspecified-high
- **Skills**: visual-engineering (for final approval)

**Parallelization**:
- **Can Run In Parallel**: NO (final step)
- **Blocks**: None
- **Blocked By**: Task 9, Task 10

**References**:
- All previous task outputs
- Approved visual design specifications

**Acceptance Criteria**:
- Final visual approval obtained
- All requirements met
- Task marked as complete

**QA Scenarios**:
```
Scenario: Final visual approval
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Present final visual state
    2. Obtain approval
    3. Document approved state
  Expected Result: Final visual approval obtained
  Evidence: .sisyphus/evidence/task-11-final-approval.png
```

## Final Verification Wave

- [ ] F1. **Plan Compliance Audit** — `oracle`
  Read the plan end-to-end. For each "Must Have": verify implementation exists (read file, curl endpoint, run command). For each "Must NOT Have": search codebase for forbidden patterns — reject with file:line if found. Check evidence files exist in .sisyphus/evidence/. Compare deliverables against plan.
  Output: `Must Have [N/N] | Must NOT Have [N/N] | Tasks [N/N] | VERDICT: APPROVE/REJECT`

- [ ] F2. **Code Quality Review** — `unspecified-high`
  Run `tsc --noEmit` + linter + `bun test`. Review all changed files for: `as any`/`@ts-ignore`, empty catches, console.log in prod, commented-out code, unused imports. Check AI slop: excessive comments, over-abstraction, generic names (data/result/item/temp).
  Output: `Build [PASS/FAIL] | Lint [PASS/FAIL] | Tests [N pass/N fail] | Files [N clean/N issues] | VERDICT`

- [ ] F3. **Real Manual QA** — `unspecified-high` (+ `playwright` skill if UI)
  Start from clean state. Execute EVERY QA scenario from EVERY task — follow exact steps, capture evidence. Test cross-task integration (features working together, not isolation). Test edge cases: empty state, invalid input, rapid actions. Save to `.sisyphus/evidence/final-qa/`.
  Output: `Scenarios [N/N pass] | Integration [N/N] | Edge Cases [N tested] | VERDICT`

- [ ] F4. **Scope Fidelity Check** — `deep`
  For each task: read "What to do", read actual diff (git log/diff). Verify 1:1 — everything in spec was built (no missing), nothing beyond spec was built (no creep). Check "Must NOT do" compliance. Detect cross-task contamination: Task N touching Task M's files. Flag unaccounted changes.
  Output: `Tasks [N/N compliant] | Contamination [CLEAN/N issues] | Unaccounted [CLEAN/N files] | VERDICT`

## Commit Strategy

- **1**: `fix(visual): Apply logo and menu visual fixes` — logo.py, styles.tcss

## Success Criteria

### Verification Commands
```bash
uv run python -m archinstall_tui  # Expected: TUI starts without CSS errors, logo and menu display correctly
```

### Final Checklist
- [x] All "Must Have" present (logo centered, colors correct, menu styled)
- [x] All "Must NOT Have" absent (no borders, menu text functional)
- [x] All tests pass (73/73)
- [x] Visual appearance matches expectations

## Completion Summary

**Completed**: 2026-02-24

### Changes Made:
1. **logo.py**: Added Rich markup for colors (`[cyan]` for mountain, `[white]` for text)
2. **styles.tcss**: Changed `#menu-container` background to `$panel` for visual separation
3. **test_logo.py**: Updated test to verify Rich markup instead of ANSI stripping

### Files Modified:
- `src/archinstall_tui/tui/widgets/logo.py`
- `src/archinstall_tui/tui/styles.tcss`
- `tests/test_tui/test_logo.py`

### Test Results:
- All 73 tests pass
- TUI starts without CSS errors
- Visual verification successful