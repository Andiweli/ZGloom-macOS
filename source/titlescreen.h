#pragma once
#include <SDL2/SDL.h>
#include "font.h"

#include <vector>
#include <string>

class TitleScreen
{
	public:
		enum TitleReturn
		{
			TITLERET_PLAY,
			TITLERET_SELECT,
			TITLERET_QUIT,
			TITLERET_NOTHING
		};

		TitleScreen();
		void Render(SDL_Surface* src, SDL_Surface* dest, Font& font);
		void Clock() { timer++; };
		TitleReturn Update(SDL_Event& tevent, int& levelout);
		void SetLevels(std::vector<std::string> names)
		{
			levelnames.clear();
			levelnames.reserve(names.size());
			const std::string::size_type kMaxChars = 36;
			for (const auto& srcName : names)
			{
				std::string display = srcName;
				if (display.length() > kMaxChars)
				{
					display = display.substr(0, kMaxChars) + "...";
				}
				levelnames.push_back(display);
			}
		};

	private:
		enum TITLESTATUS
		{
			TITLESTATUS_MAIN,
			TITLESTATUS_ABOUT,
			TITLESTATUS_SELECT
		};

		enum MAINENTRIES
		{
			MAINENTRY_PLAY,
			MAINENTRY_SELECT,
			MAINENTRY_ABOUT,
			MAINENTRY_QUIT,
			MAINENTRY_END
		};

		std::vector<std::string> levelnames;
		TITLESTATUS status;
		int selection;
		int timer;

};

