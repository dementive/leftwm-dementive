# Firefox Userchrome for vertical tabs

These are the css customizations I use. These work with any firefox based browser.

Requires a vertical tabs add-on such as "Tree Style Tabs".

Basically what it does is hides the tabs on top, compacts things in a way that isn't ugly, and adds a responsive hover animation to the vertical tabs container.

# How to enable

1. Type in `about:config` in firefox url and search for `toolkit.legacyUserProfileCustomizations.stylesheets` and set this setting to `True`.

2. Type in `about:support` and find the section that says "Profile Directory". Click the button that says "Open Directory".

3. Make a new folder in this "Profile Directory" named `chrome`. Now place the `UserChrome.css` and `UserContent.css` files in the newly made `chrome` folder.

4. Download the "Tree Style Tabs" add-on and then restart firefox.