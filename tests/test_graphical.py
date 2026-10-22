import pytest

from graphicalMM1 import clamp, mean, movingaverage


def test_queue_statistics():
    assert mean([]) is False
    assert mean([2.0, 4.0]) == 3.0
    assert movingaverage([2.0, 4.0, 6.0]) == [2.0, 3.0, 4.0]
    assert movingaverage([]) == []


@pytest.mark.parametrize("value, expected", [(-1, 0), (4, 4), (11, 10)])
def test_animation_speed_clamps_to_supported_range(value, expected):
    assert clamp(0, value, 10) == expected
