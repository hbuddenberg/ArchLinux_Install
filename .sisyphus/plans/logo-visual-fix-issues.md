# Arch Linux Logo and Menu Visual Fix - Issues Resolution Plan

## TL;DR
Fix remaining visual issues from the previous implementation:
- Logo centering and proper 80-character width
- Menu button visibility and styling
- Menu text proper styling
- Overall layout consistency

## Context

### Current Issues Identified
From the screenshot, the following problems exist:
1. **Logo not centered** - Cyan logo is left-aligned instead of centered
2. **Menu buttons not visible** - Only "Nueva Instalación" button is showing
3. **Menu text styling** - "Selecciona una opción" text needs proper styling
4. **Layout inconsistencies** - Overall positioning needs adjustment

### Previous Work
- Logo colors applied correctly (cyan mountain, white text)
- Menu background color different from logo
- All tests passing

## Work Objectives

### Core Objective
Fix the remaining visual layout and styling issues to match the expected design:
- Proper logo centering at 80 characters width
- Visible and properly styled menu buttons
- Proper menu text styling
- Consistent overall layout

### Concrete Deliverables
- Centered logo with proper width
- Visible menu buttons with proper styling
- Styled menu text
- Consistent visual layout

### Definition of Done
- Logo is properly centered and 80 characters wide
- All menu buttons are visible and properly styled
- Menu text has appropriate styling
- Overall layout is consistent and matches expectations

## Verification Strategy

### Test Decision
- **Infrastructure exists**: YES (Textual CSS)
- **Automated tests**: NO (visual layout changes)
- **Agent-Executed QA**: YES (Playwright for UI verification)

### QA Policy
Every task will include agent-executed QA scenarios using Playwright to verify the visual appearance.

## Execution Strategy

### Parallel Execution Waves

Wave 1 (Logo Centering and Width - Critical):
├── Task 1: Fix logo centering and 80-character width
└── Task 2: Verify logo positioning

Wave 2 (Menu Button Visibility and Styling):
├── Task 3: Ensure all menu buttons are visible
├── Task 4: Style menu buttons properly
└── Task 5: Verify button styling

Wave 3 (Menu Text and Layout):
├── Task 6: Style menu text "Selecciona una opción"
├── Task 7: Ensure proper menu layout and spacing
└── Task 8: Verify overall layout consistency

## TODOs

### Task 1: Fix logo centering and 80-character width
**What to do**:
- Update ArchLogo CSS to ensure proper centering
- Verify logo maintains 80-character width constraint
- Adjust padding and margins for proper positioning

**Must NOT do**:
- Change the original logo content
- Alter color styling already applied
- Remove existing functionality

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (for CSS layout adjustments)

**Parallelization**:
- **Can Run In Parallel**: NO (critical foundation)
- **Blocks**: Task 2
- **Blocked By**: None

**References**:
- `src/archinstall_tui/tui/widgets/logo.py:11-19` - Current ArchLogo CSS
- `src/archinstall_tui/assets/logo.txt` - Original logo width reference

**Acceptance Criteria**:
- Logo is properly centered in container
- Logo maintains 80-character width
- No CSS layout errors

**QA Scenarios**:
```
Scenario: Logo centering and width
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Verify logo is centered horizontally
    3. Measure logo width (should be 80 characters)
  Expected Result: Logo is centered and 80 characters wide
  Evidence: .sisyphus/evidence/task-1-logo-centering.png
```

### Task 2: Verify logo positioning
**What to do**:
- Perform visual inspection of logo positioning
- Compare with expected centered appearance
- Document any remaining positioning issues

**Must NOT do**:
- Change logo styling or content
- Skip visual verification steps

**Recommended Agent Profile**:
- **Category**: unspecified-high
- **Skills**: visual-engineering (for layout inspection)

**Parallelization**:
- **Can Run In Parallel**: NO (verification)
- **Blocks**: Task 3 (menu work)
- **Blocked By**: Task 1

**References**:
- Task 1 output for verification
- Expected logo positioning requirements

**Acceptance Criteria**:
- Logo positioning matches expectations
- No remaining centering issues
- Visual appearance is correct

**QA Scenarios**:
```
Scenario: Final logo positioning
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Perform detailed visual inspection of logo positioning
    3. Compare with expected centered appearance
  Expected Result: Logo is properly centered and positioned
  Evidence: .sisyphus/evidence/task-2-logo-positioning.png
```

### Task 3: Ensure all menu buttons are visible
**What to do**:
- Verify all three buttons are visible (Nueva Instalación, Utilidades, Salir)
- Ensure proper button sizing and visibility
- Check for any display issues

**Must NOT do**:
- Change button functionality
- Remove menu buttons
- Alter logo styling

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (for button visibility)

**Parallelization**:
- **Can Run In Parallel**: NO (depends on logo fix)
- **Blocks**: Task 4, Task 5
- **Blocked By**: Task 2

**References**:
- `src/archinstall_tui/tui/screens/main_menu.py:26-33` - Menu buttons
- `src/archinstall_tui/tui/styles.tcss:19-29` - Current button styling

**Acceptance Criteria**:
- All three buttons are visible
- Buttons display correctly
- No button visibility issues

**QA Scenarios**:
```
Scenario: Menu button visibility
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Verify all three buttons are visible
    3. Check button text and appearance
  Expected Result: All three menu buttons are visible and properly displayed
  Evidence: .sisyphus/evidence/task-3-button-visibility.png
```

### Task 4: Style menu buttons properly
**What to do**:
- Apply consistent button styling
- Ensure proper button appearance
- Maintain button functionality

**Must NOT do**:
- Change button functionality
- Remove menu buttons
- Alter logo styling

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (for button styling)

**Parallelization**:
- **Can Run In Parallel**: NO (depends on Task 3)
- **Blocks**: Task 5
- **Blocked By**: Task 3

**References**:
- `src/archinstall_tui/tui/styles.tcss:19-29` - Current button styling
- `src/archinstall_tui/tui/screens/main_menu.py:26-33` - Menu buttons

**Acceptance Criteria**:
- Menu buttons have proper styling
- Buttons display consistently
- No styling issues

**QA Scenarios**:
```
Scenario: Menu button styling
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Inspect menu button styling
    3. Verify button appearance and consistency
  Expected Result: Menu buttons have proper styling and consistent appearance
  Evidence: .sisyphus/evidence/task-4-button-styling.png
```

### Task 5: Verify button styling
**What to do**:
- Perform visual inspection of button styling
- Compare with expected appearance
- Document any styling discrepancies

**Must NOT do**:
- Change button styling
- Skip visual verification

**Recommended Agent Profile**:
- **Category**: unspecified-high
- **Skills**: visual-engineering (for button inspection)

**Parallelization**:
- **Can Run In Parallel**: NO (verification)
- **Blocks**: Task 6 (menu text work)
- **Blocked By**: Task 4

**References**:
- Task 4 output for verification
- Expected button styling requirements

**Acceptance Criteria**:
- Button styling matches expectations
- No remaining styling issues
- Visual appearance is correct

**QA Scenarios**:
```
Scenario: Final button styling
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Perform detailed visual inspection of buttons
    3. Compare with expected styling
  Expected Result: Buttons have proper styling and appearance
  Evidence: .sisyphus/evidence/task-5-button-final.png
```

### Task 6: Style menu text "Selecciona una opción"
**What to do**:
- Apply proper styling to menu prompt text
- Ensure text is visible and properly formatted
- Maintain text functionality

**Must NOT do**:
- Change menu text content
- Remove menu text
- Alter button styling

**Recommended Agent Profile**:
- **Category**: quick
- **Skills**: code-review (for text styling)

**Parallelization**:
- **Can Run In Parallel**: NO (depends on Task 5)
- **Blocks**: Task 7
- **Blocked By**: Task 5

**References**:
- `src/archinstall_tui/tui/styles.tcss:14-19` - Current menu prompt styling
- `src/archinstall_tui/tui/screens/main_menu.py:24` - Menu prompt implementation

**Acceptance Criteria**:
- Menu text has proper styling
- Text is visible and readable
- No text styling issues

**QA Scenarios**:
```
Scenario: Menu text styling
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Inspect "Selecciona una opción" text styling
    3. Verify text appearance
  Expected Result: Menu text has proper styling and is visible
  Evidence: .sisyphus/evidence/task-6-menu-text.png
```

### Task 7: Ensure proper menu layout and spacing
**What to do**:
- Verify proper menu layout and spacing
- Ensure consistent visual hierarchy
- Maintain proper separation between elements

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
- Menu layout is proper and consistent
- Visual hierarchy is maintained
- Proper spacing between elements

**QA Scenarios**:
```
Scenario: Menu layout and spacing
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Verify menu layout and spacing
    3. Check element positioning
  Expected Result: Menu has proper layout and spacing
  Evidence: .sisyphus/evidence/task-7-menu-layout.png
```

### Task 8: Verify overall layout consistency
**What to do**:
- Perform comprehensive visual inspection of entire screen
- Ensure consistency between all elements
- Document any layout discrepancies

**Must NOT do**:
- Change any visual elements
- Skip visual verification
- Alter approved layout

**Recommended Agent Profile**:
- **Category**: unspecified-high
- **Skills**: visual-engineering (for layout inspection)

**Parallelization**:
- **Can Run In Parallel**: NO (final verification)
- **Blocks**: None
- **Blocked By**: Task 7

**References**:
- All previous task outputs
- Expected overall layout requirements

**Acceptance Criteria**:
- Overall layout is consistent
- All elements positioned correctly
- No layout discrepancies

**QA Scenarios**:
```
Scenario: Overall layout consistency
  Tool: Playwright
  Preconditions: TUI application running
  Steps:
    1. Navigate to main menu screen
    2. Perform comprehensive visual inspection
    3. Verify layout consistency
  Expected Result: Overall layout is consistent and correct
  Evidence: .sisyphus/evidence/task-8-layout-final.png
```

## Final Verification Wave

- [ ] F1. **Plan Compliance Audit** — `oracle`
  Verify implementation matches plan requirements.

- [ ] F2. **Code Quality Review** — `unspecified-high`
  Run tests and review code quality.

- [ ] F3. **Real Manual QA** — `unspecified-high` (+ `playwright` skill)
  Execute all QA scenarios and verify visual appearance.

- [ ] F4. **Scope Fidelity Check** — `deep`
  Verify all changes match plan specifications.

## Commit Strategy

- **1**: `fix(visual): Resolve logo and menu layout issues` — logo.py, styles.tcss

## Success Criteria

### Verification Commands
```bash
uv run python -m archinstall_tui  # Expected: TUI displays with properly centered logo and visible menu buttons
```

### Final Checklist
- [ ] Logo properly centered and 80 characters wide
- [ ] All menu buttons visible and properly styled
- [ ] Menu text properly styled
- [ ] Overall layout consistent and correct
- [ ] All tests pass

## Next Steps

Run `/start-work logo-visual-fix-issues` to execute this plan and resolve the visual issues.