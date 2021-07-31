#!/usr/bin/env bash
if [ $(playerctl --player=ncspot status) == "Playing" ] 
then
	playerctl --player=ncspot metadata --format "▶ {{ xesam:title }} : {{ xesam:albumArtist}}"
else
	playerctl --player=ncspot metadata --format "⏸ {{ xesam:title }} : {{ xesam:albumArtist }}"
fi

