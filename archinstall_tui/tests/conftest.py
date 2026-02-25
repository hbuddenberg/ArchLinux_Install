"""Pytest configuration and fixtures."""

import pytest


@pytest.fixture
def mock_tui_app():
    """Mock TUI app for testing."""
    return "mock_app"


@pytest.fixture
def mock_logger():
    """Mock logger for testing."""
    return "mock_logger"
