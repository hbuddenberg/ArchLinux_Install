import argparse
import sys

from archinstall_tui.core.config import Config, set_config
from archinstall_tui.core.i18n import get_available_languages
from archinstall_tui.core.logger import get_logger


def main(argv: list[str] | None = None) -> int:
    parser = argparse.ArgumentParser(
        prog="archinstall-tui",
        description="ArchLinux Installation TUI",
    )

    parser.add_argument(
        "--lang",
        "-l",
        choices=get_available_languages(),
        default=None,
        help="Interface language (es/en)",
    )

    parser.add_argument(
        "--list-languages",
        action="store_true",
        help="List available languages",
    )

    parser.add_argument(
        "--module",
        "-m",
        choices=["new_install", "utilities", "exit"],
        default=None,
        help="Run specific module directly",
    )

    parser.add_argument(
        "--cli",
        action="store_true",
        help="Run in CLI mode (no TUI)",
    )

    parser.add_argument(
        "--debug",
        action="store_true",
        help="Enable debug logging",
    )

    args = parser.parse_args(argv)

    logger = get_logger("cli")

    if args.debug:
        import logging

        logger.setLevel(logging.DEBUG)

    if args.list_languages:
        print("Available languages:", ", ".join(get_available_languages()))
        return 0

    if args.lang:
        config = Config(lang=args.lang)
        set_config(config)

    if args.cli or args.module:
        return _run_cli_mode(args.module, logger)

    return _run_tui_mode(args.lang, logger)


def _run_tui_mode(lang: str | None, logger) -> int:
    try:
        from archinstall_tui.tui.app import ArchInstallApp

        app = ArchInstallApp(lang=lang)
        app.run()
        return 0

    except Exception as e:
        logger.error(f"TUI error: {e}")
        return 1


def _run_cli_mode(module_id: str | None, logger) -> int:
    if not module_id:
        logger.error("CLI mode requires --module")
        return 1

    from archinstall_tui.modules.exit.module import ExitModule
    from archinstall_tui.modules.new_install.module import NewInstallModule
    from archinstall_tui.modules.utilities.module import UtilitiesModule

    modules = {
        "new_install": NewInstallModule,
        "utilities": UtilitiesModule,
        "exit": ExitModule,
    }

    if module_id not in modules:
        logger.error(f"Unknown module: {module_id}")
        return 1

    module = modules[module_id]()
    result = module.run()

    print(f"Module: {module.info.name}")
    print(f"Status: {'OK' if result.success else 'FAILED'}")
    print(f"Message: {result.message}")

    return 0 if result.success else 1


if __name__ == "__main__":
    sys.exit(main())
