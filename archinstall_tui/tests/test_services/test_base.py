"""Tests for base service classes."""

import pytest
from archinstall_tui.services.base import Service, ServiceResult


def test_service_result_defaults():
    """Test ServiceResult dataclass default values."""
    result = ServiceResult(success=True, output="test")
    assert result.success is True
    assert result.output == "test"
    assert result.error is None
    assert result.exit_code == 0


def test_service_result_with_error():
    """Test ServiceResult with error information."""
    result = ServiceResult(success=False, output="", error="Error", exit_code=1)
    assert result.success is False
    assert result.error == "Error"
    assert result.exit_code == 1


def test_service_is_abstract():
    """Test that Service is an abstract base class."""
    assert Service.__abstractmethods__ == frozenset({"execute"})
