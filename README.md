# Customizations (Dotfiles)

## Instructions

1. Install zprezto. https://github.com/sorin-ionescu/prezto
```bash
zsh
git clone --recursive https://github.com/sorin-ionescu/prezto.git "${ZDOTDIR:-$HOME}/.zprezto"
setopt EXTENDED_GLOB
for rcfile in "${ZDOTDIR:-$HOME}"/.zprezto/runcoms/^README.md(.N); do
  ln -s "$rcfile" "${ZDOTDIR:-$HOME}/.${rcfile:t}"
done
chsh -s /bin/zsh

# Update the repositories this uses.
cd ~/dotfiles/iTerm2-Color-Schemes && git pull && cd ~/dotfiles
cd ~/dotfiles/fonts && git pull && cd ~/dotfiles
```

2. Run `bash install.sh`
3. Install fonts you want. I currently use Inconsolata-dz
4. Install iTerm2. https://www.iterm2.com
5. Install SublimeText3. https://www.sublimetext.com/3
6. Install SublimeText3 Package Control. https://packagecontrol.io/installation
7. Setup themes: Afterglow in iTerm2, and Predawn in SublimeText.
8. Setup Sublime Text 3 plugins.
9. Replace icons as needed.

### cd to
![cd to Finder app](images/cd_to.png)

https://github.com/jbtule/cdto

This small app will allow you to open up Terminal/iTerm from which folder you're currently at within Finder. This is essential!

### Sublime Text Icon Replacement
![Sublime Text Icon](images/sublime_text_icon.png)

https://dribbble.com/shots/1827862-Yosemite-Sublime-Text-Icon

This just looks better in my dock. I like it.
Obviously, you'll need [Sublime Text](www.sublimetext.com/3)

### iTerm2
[iTerm2](https://iterm2.com/downloads.html) is great, and I use the beta version (at this time, 2.9.20151001 beta) because of El Capitan compatibility.

Included is an exported JSON from iTerm of my profiles. You'll probably want to change a couple things, like the starting directory. I have a chromebox for gaming, and a Raspberry Pi for serving local media off a slow NAS.


### Sublime Text Plugins and Settings
#### Settings
```json
{
  "ignored_packages":
  [
    "Vintage"
  ],
  "theme": "predawn-DEV.sublime-theme",
  "color_scheme": "Packages/Predawn/predawn.tmTheme",
  "predawn_tabs_active_underline": true,
  "predawn_tabs_medium": true,
  "predawn_sidebar_medium": true,
  "predawn_findreplace_small": true,
  "predawn_quick_panel_small": true,

  "bold_folder_labels": true,
  "draw_minimap_border": true,
  "draw_white_space": "selection",
  "highlight_line": true,
  "highlight_modified_tabs": true,
  "tab_size": 2,
  "translate_tabs_to_spaces": true,
  "trim_trailing_white_space_on_save": true,

  "font_face": "Inconsolata-dz for Powerline",
  "font_options": "subpixel_antialias",
  "font_size": 14,


  "rulers": [
    80
  ],

}
```

#### Plugins
1. Alignment
2. All Autocomplete
3. Better CoffeeScript
4. Emmet
5. ERB Snippets
6. Gist
7. Git
8. GitGutter
9. Indent XML
10. Sass
11. SideBarEnhancements
12. Markdown Preview


## GitX
This is a great tool that helps visualize the Git actions and histories when things start to get complicated. I also use this to discard hunks of code and review the changes before I commit.

Download here: https://rowanj.github.io/gitx/

Open and hit "Enable Terminal Usage", then you can just tye in `gitx` in whatever project you're in and get a nice UI of your repository.

![Gitx](https://rowanj.github.io/gitx/images/screenshots/GitX-dev-repo_window.png)

## Good Articles

### Career
- https://web.archive.org/web/20140701091020/http://www.stefankendall.com/2013/11/10-questions-to-ask-your-potential.html
