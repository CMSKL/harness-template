#!/usr/bin/env bash
set -e

echo "Checking clean state..."

# Check 1: No debug markers in source code
echo "[1/5] Checking for debug markers..."
if [ -d "src" ] && grep -R "console.log\|debugger\|TODO:" src 2>/dev/null; then
  echo "ERROR: Found temporary debug markers in src/"
  echo "FIX: Remove console.log, debugger statements, and TODO: comments before handoff"
  exit 1
fi

if [ -d "tests" ] && grep -R "console.log\|debugger\|TODO:" tests 2>/dev/null; then
  echo "ERROR: Found temporary debug markers in tests/"
  echo "FIX: Remove console.log, debugger statements, and TODO: comments before handoff"
  exit 1
fi

echo "  ✓ No debug markers found"

# Check 2: Build status
echo "[2/5] Checking build status..."
if make -n build 2>/dev/null | grep -q "TODO"; then
  echo "  ⚠ Build command not configured (TODO in Makefile)"
else
  if make build 2>/dev/null; then
    echo "  ✓ Build passes"
  else
    echo "ERROR: Build failed"
    echo "FIX: Fix build errors before handoff - run 'make build' to see details"
    exit 1
  fi
fi

# Check 3: Test status
echo "[3/5] Checking test status..."
if make -n test 2>/dev/null | grep -q "TODO"; then
  echo "  ⚠ Test command not configured (TODO in Makefile)"
else
  if make test 2>/dev/null; then
    echo "  ✓ All tests pass"
  else
    echo "ERROR: Tests failed"
    echo "FIX: Fix failing tests before handoff - run 'make test' to see details"
    exit 1
  fi
fi

# Check 4: Lint and typecheck
echo "[4/5] Checking lint and typecheck..."
if make -n lint 2>/dev/null | grep -q "TODO"; then
  echo "  ⚠ Lint command not configured (TODO in Makefile)"
else
  if make lint 2>/dev/null; then
    echo "  ✓ Lint passes"
  else
    echo "ERROR: Lint failed"
    echo "FIX: Fix lint errors before handoff - run 'make lint' to see details"
    exit 1
  fi
fi

if make -n typecheck 2>/dev/null | grep -q "TODO"; then
  echo "  ⚠ Typecheck command not configured (TODO in Makefile)"
else
  if make typecheck 2>/dev/null; then
    echo "  ✓ Typecheck passes"
  else
    echo "ERROR: Typecheck failed"
    echo "FIX: Fix type errors before handoff - run 'make typecheck' to see details"
    exit 1
  fi
fi

# Check 5: Git status - ensure no uncommitted changes
echo "[5/5] Checking git status..."
if [ -d ".git" ]; then
  if git diff-index --quiet HEAD -- 2>/dev/null; then
    echo "  ✓ No uncommitted changes"
  else
    echo "WARNING: There are uncommitted changes"
    echo "FIX: Run 'git status' to see uncommitted files, then commit before handoff"
    # Don't exit 1 here, just warn - sometimes you want to commit manually
  fi
else
  echo "  ⚠ Not a git repository"
fi

echo ""
echo "==================================="
echo "✓ Clean state check passed"
echo "==================================="
echo ""
echo "Remember to also:"
echo "  - Update PROGRESS.md with current status"
echo "  - Update features.json if feature states changed"
echo "  - Commit all changes with descriptive message"
