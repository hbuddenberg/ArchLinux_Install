import pytest
from unittest.mock import patch
from archinstall_tui.services.bash_runner import BashRunner


def test_run_inline_echo():
    runner = BashRunner()
    result = runner.run_inline("echo hello")
    assert result.success is True
    assert "hello" in result.output


def test_run_inline_with_error():
    runner = BashRunner()
    result = runner.run_inline("exit 1")
    assert result.success is False
    assert result.exit_code == 1


def test_execute_script_not_found():
    runner = BashRunner()
    result = runner.execute("/nonexistent/script.sh")
    assert result.success is False
    assert "not found" in result.error.lower()
    assert result.exit_code == 127


def test_execute_script_success(tmp_path):
    script = tmp_path / "test.sh"
    script.write_text("#!/bin/bash\necho 'test output'")
    runner = BashRunner()
    result = runner.execute(script)
    assert result.success is True
    assert "test output" in result.output


def test_execute_script_with_args(tmp_path):
    script = tmp_path / "args.sh"
    script.write_text('#!/bin/bash\necho "$1 $2"')
    runner = BashRunner()
    result = runner.execute(script, args=["hello", "world"])
    assert result.success is True
    assert "hello world" in result.output


def test_execute_script_with_env(tmp_path):
    script = tmp_path / "env.sh"
    script.write_text('#!/bin/bash\necho "$MY_VAR"')
    runner = BashRunner()
    result = runner.execute(script, env={"MY_VAR": "custom_value"})
    assert result.success is True
    assert "custom_value" in result.output


def test_execute_script_with_cwd(tmp_path):
    script = tmp_path / "cwd.sh"
    script.write_text("#!/bin/bash\npwd")
    runner = BashRunner()
    result = runner.execute(script, cwd=tmp_path)
    assert result.success is True
    assert str(tmp_path) in result.output


def test_execute_script_with_stderr(tmp_path):
    script = tmp_path / "stderr.sh"
    script.write_text('#!/bin/bash\necho "error" >&2')
    runner = BashRunner()
    result = runner.execute(script)
    assert result.success is True
    assert "error" in result.error


def test_run_inline_with_cwd(tmp_path):
    runner = BashRunner()
    result = runner.run_inline("pwd", cwd=tmp_path)
    assert result.success is True
    assert str(tmp_path) in result.output


def test_run_inline_with_stderr():
    runner = BashRunner()
    result = runner.run_inline("echo error >&2")
    assert result.success is True
    assert "error" in result.error


def test_execute_script_timeout(tmp_path):
    script = tmp_path / "sleep.sh"
    script.write_text("#!/bin/bash\nsleep 10")
    runner = BashRunner(timeout=1)
    result = runner.execute(script)
    assert result.success is False
    assert result.exit_code == 124


def test_run_inline_timeout():
    runner = BashRunner(timeout=1)
    result = runner.run_inline("sleep 10")
    assert result.success is False
    assert result.exit_code == 124


def test_execute_bash_not_found(tmp_path):
    script = tmp_path / "test.sh"
    script.write_text("#!/bin/bash\necho test")
    with patch("shutil.which", return_value=None):
        runner = BashRunner()
        result = runner.execute(script)
        assert result.success is False
        assert "bash not found" in result.error.lower()
        assert result.exit_code == 127


def test_run_inline_bash_not_found():
    with patch("shutil.which", return_value=None):
        runner = BashRunner()
        result = runner.run_inline("echo test")
        assert result.success is False
        assert "bash not found" in result.error.lower()
        assert result.exit_code == 127
