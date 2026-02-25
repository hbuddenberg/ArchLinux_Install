# Logo Centering Fix - Learnings

## Problem Identified
The nested Static widget inside ArchLogo's compose() method didn't inherit the text-align: center CSS property from the parent ArchLogo widget.

## Solution Applied
**Removed the compose() method and set content directly in __init__()**:
- Pass logo content to Static constructor in __init__: `super().__init__(self._load_logo(), markup=True, **kwargs)`
- This allows the ArchLogo Static to directly display the content and properly inherit CSS properties

## Files Modified
1. `/workspace/archinstall_tui/src/archinstall_tui/tui/widgets/logo.py`
   - Removed compose() method (lines 27-28)
   - Set content in __init__() constructor (line 25)
   - Renamed internal attribute from `_logo_path` to `logo_path` for public API consistency

2. `/workspace/archinstall_tui/src/archinstall_tui/tui/styles.tcss`
   - No changes needed - already has correct text-align: center configuration

## Test Results
- All 73 tests pass (7 logo tests + 66 other tests)
- No regressions introduced
- Logo properly displays with cyan mountains and white text

## Visual Verification
- Application runs successfully: `uv run python -m archinstall_tui`
- Logo is properly centered in the container
- Rich markup colors ([cyan] and [white]) are preserved
- Logo maintains 80-character width constraint (controlled by container CSS)

## Key Learnings
1. **CSS Inheritance**: In Textual/Textual widgets, child widgets don't automatically inherit CSS properties that are defined on the parent unless explicitly inherited
2. **Direct Content Setting**: Setting content directly in the parent constructor is more reliable than yielding nested widgets
3. **Public vs Private Attributes**: Keeping internal attributes public (logo_path instead of _logo_path) maintains API consistency with existing tests
