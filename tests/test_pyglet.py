import runpy


def test_pyglet_entrypoint_builds_and_draws_headless(monkeypatch):
    import pyglet

    monkeypatch.setitem(pyglet.options, "headless", True)
    monkeypatch.setattr(pyglet.app, "run", lambda: None)
    namespace = runpy.run_path("pygletMM1.py", run_name="__main__")
    simulation = namespace["simulation"]
    try:
        simulation.update(1 / 60)
        simulation.on_draw()
    finally:
        pyglet.clock.unschedule(simulation.update)
        simulation.window.close()
