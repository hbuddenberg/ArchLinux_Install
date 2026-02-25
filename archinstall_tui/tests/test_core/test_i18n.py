from archinstall_tui.core.i18n import t, get_available_languages, STRINGS


def test_t_returns_spanish_by_default():
    from archinstall_tui.core.config import set_config, Config

    set_config(Config(lang="es"))
    text = t("menu.new_install")
    assert text == "Nueva Instalación"






def test_t_returns_english_when_specified():
    text = t("menu.new_install", "en")
    assert text == "New Installation"


def test_t_returns_key_when_not_found():
    text = t("nonexistent.key")
    assert text == "nonexistent.key"


def test_t_fallback_to_english_for_unknown_lang():
    text = t("menu.new_install", "fr")
    assert text == "New Installation"


def test_get_available_languages():
    langs = get_available_languages()
    assert "es" in langs
    assert "en" in langs
    assert len(langs) == 2


def test_all_keys_exist_in_both_languages():
    es_keys = set(STRINGS["es"].keys())
    en_keys = set(STRINGS["en"].keys())
    assert es_keys == en_keys
